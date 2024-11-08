//
//  Created by Peter Combee on 08/11/2024.
//

import Foundation

struct WikipediaLocationNavigator {
    
    private let openUrl: (URL) -> Void
    
    init(openUrl: @escaping (URL) -> Void) {
        self.openUrl = openUrl
    }
    
    func showLocationOnWikipedia(_ location: Location) {
        let locationUrl = URL(string: "https://en.wikipedia.org")!
            .appendingPathComponent("wiki")
            .appendingPathComponent(location.name)
        
        openUrl(locationUrl)
    }
}
