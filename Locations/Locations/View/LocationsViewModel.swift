//
//  Created by Peter Combee on 06/11/2024.
//

import Foundation

struct PresentableLocation: Equatable {
    
    let name: String
    let onSelection: () -> Void
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}

@MainActor
final class LocationsViewModel: ObservableObject {
    
    private let locationsProvider: LocationsProvider
    private let onLocationSelection: (Location) -> Void
    
    init(
        locationsProvider: LocationsProvider,
        onLocationSelection: @escaping (Location) -> Void
    ) {
        self.locationsProvider = locationsProvider
        self.onLocationSelection = onLocationSelection
    }
    
    @Published private(set) var state: LocationsLoadingState = .loading
    
    func loadLocations() async {
        if state != .loading { state = .loading }
        do {
            let locations = try await locationsProvider.getLocations()
            let presentableLocations = locations.map { location in
                PresentableLocation(
                    name: location.name,
                    onSelection: {
                        self.onLocationSelection(location)
                    })
            }
            state = .presenting(presentableLocations)
        } catch {
            state = .error
        }
    }
}
