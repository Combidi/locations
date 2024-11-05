//
//  Created by Peter Combee on 05/11/2024.
//

protocol LocationsProvider {
    func getLocations() async throws -> [Location]
}
