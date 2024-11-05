//
//  Created by Peter Combee on 05/11/2024.
//

import Foundation

protocol HttpClient {
    func get(from url: URL) throws -> Data
}

struct RemoteLocationsProvider: LocationsProvider {

    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func getLocations() async throws -> [Location] {
        let locationsURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        let data = try httpClient.get(from: locationsURL)
        
        struct DecodableLocations: Decodable {
            
            struct DecodableLocation: Decodable {
                let name: String?
                let lat: Double
                let long: Double
            }

            let locations: [DecodableLocation]
        }
        
        let decodableLocations = try JSONDecoder().decode(DecodableLocations.self, from: data)
                
        let locations: [Location] = decodableLocations.locations.compactMap {
            guard let name = $0.name else { return nil }
            return Location(name: name, latitude: $0.lat, longitude: $0.long)
        }
        
        return locations
    }
}
