//
//  Created by Peter Combee on 05/11/2024.
//

@testable import Locations

private struct RemoteLocationsProvider: LocationsProvider {
    
    private let httpClient: HTTPClientSpy
    
    init(httpClient: HTTPClientSpy) {
        self.httpClient = httpClient
    }
    
    func getLocations() async throws -> [Location] {
        let locationsURL = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        try httpClient.get(from: locationsURL)
        return []
    }
}

import XCTest

final class RemoteLocationsProviderTests: XCTestCase {
    
    func test_getLocations_getsLocationsFromUrl() async throws {
        let client = HTTPClientSpy()
        let sut = RemoteLocationsProvider(httpClient: client)
        
        _ = try await sut.getLocations()
        
        let expectedUrl = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        XCTAssertEqual(client.capturedUrls, [expectedUrl])
    }
    
    func test_getLocations_deliversErrorOnHttpClientError() async {
        let client = HTTPClientSpy()
        let sut = RemoteLocationsProvider(httpClient: client)
        
        let error = NSError(domain: "any", code: 0)
        client.stub = error
        
        do {
            _ = try await sut.getLocations()
            XCTFail("Expected error on client error")
        } catch let capturedError {
            XCTAssertEqual(capturedError as NSError, error)
        }
    }
}

// MARK: - Helpers

private final class HTTPClientSpy {
    
    var stub: Error?
    
    private(set) var capturedUrls: [URL] = []
    
    func get(from url: URL) throws {
        capturedUrls.append(url)
        try stub.map { throw $0 }
    }
}
