//
//  Created by Peter Combee on 09/11/2024.
//

import XCTest
import Combine
@testable import Locations

@MainActor
final class LocationsViewModelIntegrationTests: XCTestCase {

    private lazy var locationsProvider = LocationsProviderSpy()
    private lazy var urlOpener = UrlOpenerSpy()
    private lazy var sut = LocationsViewModelAssembler.make(
        locationsProvider: locationsProvider,
        openUrl: urlOpener.openUrl
    )
    
    func test_loadLocations_requestsLocationsFromProvider() async {
        XCTAssertEqual(
            locationsProvider.callcount, 0,
            "Expected no load request before calling `loadLocations`"
        )

        await sut.loadLocations()

        XCTAssertEqual(
            locationsProvider.callcount, 1,
            "Expected one load request after calling `loadLocations`"
        )
    }
    
    func test_state_isLoadingByDefault() {
        XCTAssertEqual(sut.state, .loading)
    }

    func test_states_duringLoading() async {
        var cancellables: Set<AnyCancellable> = []
        var capturedStates: [LocationsLoadingState] = []
        sut.$state
            .sink { capturedStates.append($0) }
            .store(in: &cancellables)
                
        XCTAssertEqual(
            capturedStates, [.loading],
            "Expected initial state to be .loading"
        )
        
        locationsProvider.stub = .failure(NSError(domain: "any", code: 0))
        
        await sut.loadLocations()
        
        XCTAssertEqual(
            capturedStates, [.loading, .error],
            "Expected error state on loading failure"
        )

        let location = Location(name: "Velp", latitude: 1, longitude: 2)
        locationsProvider.stub = .success([location])
        
        await sut.loadLocations()

        let presentableLocation = PresentableLocation(name: "Velp", onSelection: {})
        XCTAssertEqual(
            capturedStates, [.loading, .error, .loading, .presenting([presentableLocation])],
            "Expected second loading state followed by presentation state after successful loading"
        )
    }

    func test_selectingLocation_opensWikipediaUrl() async {
        let firstLocation = Location(name: "Arnhem", latitude: 1, longitude: 2)
        let secondLocation = Location(name: "Amsterdam", latitude: 1, longitude: 2)
        locationsProvider.stub = .success([firstLocation, secondLocation])
        
        await sut.loadLocations()

        guard case let .presenting(presentableLocations) = sut.state else {
            return XCTFail("Expected presenting state with locations, got \(sut.state) instead")
        }
        
        XCTAssertEqual(
            urlOpener.openedUrls, [],
            "Expected no urls to be opened before first location has been selected"
        )
        
        presentableLocations[0].onSelection()
        
        XCTAssertEqual(
            urlOpener.openedUrls,
            [URL(string: "https://en.wikipedia.org/wiki/Arnhem")!]
        )

        presentableLocations[1].onSelection()

        XCTAssertEqual(
            urlOpener.openedUrls,
            [
                URL(string: "https://en.wikipedia.org/wiki/Arnhem")!,
                URL(string: "https://en.wikipedia.org/wiki/Amsterdam")!
            ]
        )
    }
}

// MARK: - Helpers

private final class UrlOpenerSpy {
    
    private(set) var openedUrls: [URL] = []
    
    func openUrl(_ url: URL) {
        openedUrls.append(url)
    }
}

private final class LocationsProviderSpy: LocationsProvider {

    var stub: Result<[Location], Error> = .success([])
    
    private(set) var callcount: Int = 0
    
    func getLocations() throws -> [Location] {
        callcount += 1
        return try stub.get()
    }
}
