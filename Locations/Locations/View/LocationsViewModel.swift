//
//  Created by Peter Combee on 06/11/2024.
//

import Foundation

@MainActor
final class LocationsViewModel: ObservableObject {
    
    private let locationsProvider: LocationsProvider
    private let mapToPresentableLocations: ([Location]) -> [PresentableLocation]
    
    init(
        locationsProvider: LocationsProvider,
        mapToPresentableLocations: @escaping ([Location]) -> [PresentableLocation]
    ) {
        self.locationsProvider = locationsProvider
        self.mapToPresentableLocations = mapToPresentableLocations
    }
    
    @Published private(set) var state: LocationsLoadingState = .loading
    
    func loadLocations() async {
        if state != .loading { state = .loading }
        do {
            let locations = try await locationsProvider.getLocations()
            let presentableLocations = mapToPresentableLocations(locations)
            state = .presenting(presentableLocations)
        } catch {
            state = .error
        }
    }    
}
