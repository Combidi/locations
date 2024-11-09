//
//  Created by Peter Combee on 08/11/2024.
//

struct PresentableLocation: Equatable {
    
    let name: String
    let onSelection: () -> Void
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
