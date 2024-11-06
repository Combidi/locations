//
//  Created by Peter Combee on 06/11/2024.
//

import SwiftUI

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
                Button(action: {}) {
                    Text(location.name)                    
                }
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
