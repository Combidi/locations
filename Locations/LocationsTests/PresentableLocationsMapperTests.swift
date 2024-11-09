//
//  Created by Peter Combee on 09/11/2024.
//

import XCTest
@testable import Locations

final class PresentableLocationsMapperTests: XCTestCase {

    private lazy var selectionHandlerSpy = LocationSelectionHandlerSpy()
    private lazy var sut = PresentableLocationMapper(
        onLocationSelection: selectionHandlerSpy.onLocationSelection
    )
    
    func test_mapToPresentableLocations_correctlyMapsPresentableValues() {
        let locations = [
            Location(name: "Amsterdam", latitude: 1, longitude: 2),
            Location(name: "Arnhem", latitude: 1, longitude: 2)
        ]
        
        let presentables = sut.mapToPresentableLocations(locations: locations)
        
        XCTAssertEqual(presentables.count, 2)
        XCTAssertEqual(presentables[0].name, "Amsterdam")
        XCTAssertEqual(presentables[1].name, "Arnhem")
    }
    
    func test_presentableLocationSelection_notifiesSelectionHandler() {
        let amsterdam = Location(name: "Amsterdam", latitude: 1, longitude: 2)
        let arnhem = Location(name: "Arnhem", latitude: 1, longitude: 2)
        
        let presentables = sut.mapToPresentableLocations(locations: [amsterdam, arnhem])
 
        XCTAssertEqual(
            selectionHandlerSpy.selectedLocations, [],
            "Expected no locations before first location has been selected"
        )
        
        presentables[1].onSelection()
        
        XCTAssertEqual(
            selectionHandlerSpy.selectedLocations, [arnhem],
            "Expected first location after Arnhem has been selected"
        )

        presentables[0].onSelection()

        XCTAssertEqual(
            selectionHandlerSpy.selectedLocations, [arnhem, amsterdam],
            "Expected second location after Amsterdam has been selected"
        )
    }
}

// MARK: - Helpers

private final class LocationSelectionHandlerSpy {
    
    private(set) var selectedLocations: [Location] = []
    
    func onLocationSelection(_ location: Location) {
        selectedLocations.append(location)
    }
}
