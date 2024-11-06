//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

struct LocationsView: View {
    
    enum LoadingState {
        case loading
        case error
        case presenting([Location])
    }
    
    let state: LoadingState
    
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
    LocationsView(state: .loading)
}

#Preview("Locations error") {
    LocationsView(state: .error)
}

#Preview("Locations presenting") {
    LocationsView(state: .presenting([
        Location(name: "Amsterdam", latitude: 0, longitude: 0),
        Location(name: "Mumbai", latitude: 0, longitude: 0),
        Location(name: "Copenhagen", latitude: 0, longitude: 0)
    ]))
}
