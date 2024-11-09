//
//  Created by Peter Combee on 05/11/2024.
//

import SwiftUI

struct LocationsView: View {
            
    @ObservedObject private var viewModel: LocationsViewModel
    
    init(viewModel: LocationsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        LocationsPresentingView(state: viewModel.state)
            .task { await viewModel.loadLocations() }
    }
}
