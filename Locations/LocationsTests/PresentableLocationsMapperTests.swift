//
//  Created by Peter Combee on 09/11/2024.
//

import XCTest
@testable import Locations

struct PresentableLocationMapper {
    func mapToPresentableLocations(locations: [Location]) -> [PresentableLocation] {
        locations.map { location in
            PresentableLocation(name: location.name, onSelection: {})
        }
    }
}

final class PresentableLocationsMapperTests: XCTestCase {

    func test_mapToPresentableLocations_correctlyMapsPresentableValues() {
        let sut = PresentableLocationMapper()
        
        let locations = [
            Location(name: "Amsterdam", latitude: 1, longitude: 2),
            Location(name: "Arnhem", latitude: 1, longitude: 2)
        ]
        
        let presentables = sut.mapToPresentableLocations(locations: locations)
        
        XCTAssertEqual(presentables.count, 2)
        XCTAssertEqual(presentables[0].name, "Amsterdam")
        XCTAssertEqual(presentables[1].name, "Arnhem")
    }
}
