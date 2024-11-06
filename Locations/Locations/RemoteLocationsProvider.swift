//
//  Created by Peter Combee on 05/11/2024.
//

import Foundation

struct RemoteLocationsProvider: LocationsProvider {

    private struct DecodableLocations: Decodable {
        let locations: [DecodableLocation]
    }
    
    private struct DecodableLocation: Decodable {
        let name: String?
        let lat: Double
        let long: Double
    }
    
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func getLocations() async throws -> [Location] {
        let locationsURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        let (data, _) = try await httpClient.get(from: locationsURL)
        let decodableLocations = try JSONDecoder().decode(DecodableLocations.self, from: data)
        let locations = decodableLocations.locations.compactMap(mapLocation)
        return locations
    }
    
    private func mapLocation(_ location: DecodableLocation) -> Location? {
        guard let name = location.name else { return nil }
        return Location(name: name, latitude: location.lat, longitude: location.long)
    }
}
