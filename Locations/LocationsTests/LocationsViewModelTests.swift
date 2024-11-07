//
//  Created by Peter Combee on 06/11/2024.
//

import XCTest
import Combine
@testable import Locations

@MainActor
final class LocationsViewModelTests: XCTestCase {
    
    func test_loadLocations_requestsLocationsFromProvider() async {
        let locationsProvider = LocationsProviderSpy()
        let sut = LocationsViewModel(locationsProvider: locationsProvider)
        
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
        let locationsProvider = LocationsProviderSpy()
        let sut = LocationsViewModel(locationsProvider: locationsProvider)
        
        XCTAssertEqual(sut.state, .loading)
    }
    
    func test_states_duringLoading() async {
        let locationsProvider = LocationsProviderSpy()
        let sut = LocationsViewModel(locationsProvider: locationsProvider)
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

        XCTAssertEqual(
            capturedStates, [.loading, .error, .loading, .presenting([location])],
            "Expected second loading state followed by presentation state after successful loading"
        )
    }
}

// MARK: Helpers

private final class LocationsProviderSpy: LocationsProvider {

    var stub: Result<[Location], Error> = .success([])
    
    private(set) var callcount: Int = 0
    
    func getLocations() throws -> [Location] {
        callcount += 1
        return try stub.get()
    }
}
