//
//  Created by Peter Combee on 06/11/2024.
//

import XCTest
@testable import Locations

final class LocationsViewModelTests: XCTestCase {
    
    func test_loadLocations_requestsLocationsFromProvider() async {
        let locationsProvider = LocationsProviderSpy()
        let sut = LocationsView.Model(locationsProvider: locationsProvider)
        
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
}

// MARK: Helpers

private final class LocationsProviderSpy: LocationsProvider {

    private(set) var callcount: Int = 0
    
    func getLocations() async throws -> [Location] {
        callcount += 1
        return []
    }
}
