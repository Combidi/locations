//
//  Created by Peter Combee on 05/11/2024.
//

import XCTest
@testable import Locations

final class RemoteLocationsProviderTests: XCTestCase {
    
    private var client: HTTPClientSpy!
    private var sut: RemoteLocationsProvider!
    
    override func setUp() {
        super.setUp()
        client = HTTPClientSpy()
        sut = RemoteLocationsProvider(httpClient: client)
    }
    
    func test_getLocations_getsLocationsFromUrl() async {
        _ = try? await sut.getLocations()
        
        let expectedUrl = URL(string: "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json")!
        XCTAssertEqual(client.capturedUrls, [expectedUrl])
    }
    
    func test_getLocations_deliversErrorOnHttpClientError() async {
        let error = NSError(domain: "any", code: 0)
        client.stub = .failure(error)
        
        do {
            _ = try await sut.getLocations()
            XCTFail("Expected error on client error")
        } catch let capturedError {
            XCTAssertEqual(capturedError as NSError, error)
        }
    }
    
    func test_getLocations_deliversErrorOnInvalidLocationsJson() async {
        client.stub = .success(Data("any invalid locations json data".utf8))
        
        do {
            _ = try await sut.getLocations()
            XCTFail("Expected error on client error")
        } catch {}
    }
    
    func test_getLocations_deliversLocationsOnValidLocationsJson() async throws {
        let locationsJson = """
        {
          "locations": 
          [
            {
              "name": "Amsterdam",
              "lat": 52.3547498,
              "long": 4.8339215
            },
            {
              "name": "Mumbai",
              "lat": 19.0823998,
              "long": 72.8111468
            },
            {
              "name": "Copenhagen",
              "lat": 55.6713442,
              "long": 12.523785
            },
            {
              "lat": 40.4380638,
              "long": -3.7495758
            }
          ]
        }
        """
        let validLocationsJsonData = Data(locationsJson.utf8)
        client.stub = .success(validLocationsJsonData)
        
        let locations = try await sut.getLocations()
        
        let expectedLocations = [
            Location(name: "Amsterdam", latitude: 52.3547498, longitude: 4.8339215),
            Location(name: "Mumbai", latitude: 19.0823998, longitude: 72.8111468),
            Location(name: "Copenhagen", latitude: 55.6713442, longitude: 12.523785)
        ]
        XCTAssertEqual(locations.count, 3)
        XCTAssertEqual(locations[0], expectedLocations[0])
        XCTAssertEqual(locations[1], expectedLocations[1])
        XCTAssertEqual(locations[2], expectedLocations[2])
    }
}

// MARK: - Helpers

private final class HTTPClientSpy: HttpClient {
    
    var stub: Result<Data, Error> = .failure(NSError(domain: "", code: 1))
        
    private(set) var capturedUrls: [URL] = []
    
    func get(from url: URL) throws -> Data {
        capturedUrls.append(url)
        return try stub.get()
    }
}
