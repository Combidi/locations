//
//  Created by Peter Combee on 06/11/2024.
//

enum LocationsLoadingState: Equatable {
    case loading
    case error
    case presenting([PresentableLocation])
}
