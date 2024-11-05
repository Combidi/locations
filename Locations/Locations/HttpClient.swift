//
//  Created by Peter Combee on 05/11/2024.
//

import Foundation

protocol HttpClient {
    func get(from url: URL) throws -> Data
}
