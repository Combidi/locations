//
//  Created by Peter Combee on 05/11/2024.
//

@testable import Locations

private struct RemoteLocationsProvider: LocationsProvider {
    
    private let httpClient: HTTPClientSpy
    
    init(httpClient: HTTPClientSpy) {
        self.httpClient = httpClient
    }
    
    func getLocations() async -> [Location] {
        let locationsURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        httpClient.get(from: locationsURL)
        return []
    }
}

import XCTest

final class RemoteLocationsProviderTests: XCTestCase {
    
    func test_getLocations_getsLocationsFromUrl() async {
        let client = HTTPClientSpy()
        let sut = RemoteLocationsProvider(httpClient: client)
        
        _ = await sut.getLocations()
        
        let expectedUrl = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        XCTAssertEqual(client.capturedUrls, [expectedUrl])
    }
}

// MARK: - Helpers

private final class HTTPClientSpy {
    
    private(set) var capturedUrls: [URL] = []
    
    func get(from url: URL) {
        capturedUrls.append(url)
    }
}
