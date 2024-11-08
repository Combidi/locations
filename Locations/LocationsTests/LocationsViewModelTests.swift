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
        let sut = LocationsViewModel(
            locationsProvider: locationsProvider,
            onLocationSelection: { _ in }
        )
        
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
        let sut = LocationsViewModel(
            locationsProvider: locationsProvider,
            onLocationSelection: { _ in }
        )
        
        XCTAssertEqual(sut.state, .loading)
    }
    
    func test_states_duringLoading() async {
        let locationsProvider = LocationsProviderSpy()
        let sut = LocationsViewModel(
            locationsProvider: locationsProvider,
            onLocationSelection: { _ in }
        )
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
    
    func test_selectingLocation_notifiesHandler() async {
        let locationsProvider = LocationsProviderSpy()
        let locationSelectionHandler = LocationSelectionHandlerSpy()
        let sut = LocationsViewModel(
            locationsProvider: locationsProvider,
            onLocationSelection: locationSelectionHandler.onLocationSelection
        )
        let firstLocation = Location(name: "First", latitude: 1, longitude: 2)
        let secondLocation = Location(name: "Second", latitude: 1, longitude: 2)
        locationsProvider.stub = .success([firstLocation, secondLocation])
        
        await sut.loadLocations()

        guard case let .presenting(presentableLocations) = sut.state else {
            return XCTFail("Expected presenting state with locations, got \(sut.state) instead")
        }
        
        XCTAssertEqual(
            locationSelectionHandler.capturedLocations, [],
            "Expected no locations before first location has been selected"
        )
        
        presentableLocations[0].onSelection()
        
        XCTAssertEqual(
            locationSelectionHandler.capturedLocations, [firstLocation],
            "Expected first location after location has been selected"
        )

        presentableLocations[1].onSelection()

        XCTAssertEqual(
            locationSelectionHandler.capturedLocations, [firstLocation, secondLocation],
            "Expected second location after another location has been selected"
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

private final class LocationSelectionHandlerSpy {
    
    private(set) var capturedLocations: [Location] = []
    
    func onLocationSelection(_ location: Location) {
        capturedLocations.append(location)
    }
}
