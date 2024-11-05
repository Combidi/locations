//
//  Created by Peter Combee on 05/11/2024.
//

struct Location: Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
}

protocol LocationsProvider {
    func getLocations() async throws -> [Location]
}
