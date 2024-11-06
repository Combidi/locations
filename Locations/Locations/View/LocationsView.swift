//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

struct LocationsView: View {
            
    @ObservedObject private var model: LocationsViewModel
    
    init(model: LocationsViewModel) {
        self.model = model
    }
    
    var body: some View {
        LocationsPresentingView(state: model.state)
    }
}
