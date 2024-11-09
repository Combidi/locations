//
//  Created by Peter Combee on 08/11/2024.
//

struct PresentableLocation: Equatable, Identifiable {
    
    let name: String
    let onSelection: () -> Void
    
    var id: String { name }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name
    }
}
