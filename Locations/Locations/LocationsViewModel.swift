//
//  Created by Peter Combee on 06/11/2024.
//

import Foundation

final class LocationsViewModel: ObservableObject {
    
    private let locationsProvider: LocationsProvider
    
    init(locationsProvider: LocationsProvider) {
        self.locationsProvider = locationsProvider
    }
    
    @Published private(set) var state: LocationsLoadingState = .loading
    
    func loadLocations() async {
        if state != .loading { state = .loading }
        do {
            state = .presenting(try await locationsProvider.getLocations())
        } catch {
            state = .error
        }
    }
}
