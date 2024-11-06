//
//  Created by Peter Combee on 06/11/2024.
//

import Foundation

struct UrlSessionHttpClient: HttpClient {

    private struct NonHttpResponseError: Error {}
    
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        let (data, response) = try await session.data(from: url)
        guard let httpUrlResponse = response as? HTTPURLResponse else {
            throw NonHttpResponseError()
        }
        return (data, httpUrlResponse)
    }
}
