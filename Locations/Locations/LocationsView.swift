//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

struct LocationsView: View {
    
    enum LoadingState {
        case loading
        case error
    }
    
    let state: LoadingState
    
    var body: some View {
        switch state {
        case .loading:
            Text("Loading...")
        case .error:
            Text("Oeps! Something went wrong...")
        }
    }
}

#Preview {
    LocationsView(state: .loading)
}

#Preview {
    LocationsView(state: .error)
}
