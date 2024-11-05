//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

struct LocationsView: View {
    
    enum LoadingState {
        case loading
    }
    
    let state: LoadingState
    
    var body: some View {
        switch state {
        case .loading:
            Text("Loading...")
        }
    }
}

#Preview {
    LocationsView(state: .loading)
}
