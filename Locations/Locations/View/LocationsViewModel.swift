//
//  Created by Peter Combee on 06/11/2024.
//

import Foundation

struct PresentableLocation: Equatable {
    let name: String
}

@MainActor
final class LocationsViewModel: ObservableObject {
    
    private let locationsProvider: LocationsProvider
    
    init(locationsProvider: LocationsProvider) {
        self.locationsProvider = locationsProvider
    }
    
    @Published private(set) var state: LocationsLoadingState = .loading
    
    func loadLocations() async {
        if state != .loading { state = .loading }
        do {
            let locations = try await locationsProvider.getLocations()
            let presentableLocations = locations.map {
                PresentableLocation(name: $0.name)
            }
            state = .presenting(presentableLocations)
        } catch {
            state = .error
        }
    }
}
