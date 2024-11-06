//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

enum LocationsLoadingState: Equatable {
    case loading
    case error
    case presenting([Location])
}

struct LocationsView: View {
            
    @ObservedObject private var model: LocationsViewModel
    
    init(model: LocationsViewModel) {
        self.model = model
    }
    
    var body: some View {
        LocationsPresentingView(state: model.state)
    }
}

struct LocationsPresentingView: View {
    
    private let state: LocationsLoadingState
    
    init(state: LocationsLoadingState) {
        self.state = state
    }
    
    var body: some View {
        switch state {
        case .loading:
            Text("Loading...")
        case .error:
            Text("Oeps! Something went wrong...")
        case let .presenting(locations):
            List(locations, id: \.name) { location in
                Text(location.name)
            }
        }
    }
}

#Preview("Locations loading") {
    LocationsPresentingView(state: .loading)
}

#Preview("Locations error") {
    LocationsPresentingView(state: .error)
}

#Preview("Locations presenting") {
    LocationsPresentingView(state: .presenting([
        Location(name: "Amsterdam", latitude: 0, longitude: 0),
        Location(name: "Mumbai", latitude: 0, longitude: 0),
        Location(name: "Copenhagen", latitude: 0, longitude: 0)
    ]))
}
