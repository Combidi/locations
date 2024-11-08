//
//  Created by Peter Combee on 08/11/2024.
//

import XCTest
import Foundation
@testable import Locations

final class WikipediaLocationNavigatorTests {
    
    func test_showLocationOnWikipedia_opensWikipediaUrl() {
        let urlOpenerSpy = UrlOpenerSpy()
        let sut = WikipediaLocationNavigator(openUrl: urlOpenerSpy.openUrl)
                
        XCTAssertEqual(
            urlOpenerSpy.capturedUrls, [],
            "Expected no URLs before show location"
        )

        let arnhem = Location(name: "Arnhem", latitude: 0, longitude: 0)
        sut.showLocationOnWikipedia(arnhem)
        
        XCTAssertEqual(
            urlOpenerSpy.capturedUrls,
            [URL(string: "https://en.wikipedia.org/wiki/arnhem")!],
            "Expected first URL"
        )

        let amsterdam = Location(name: "Arnhem", latitude: 0, longitude: 0)
        sut.showLocationOnWikipedia(amsterdam)
        
        XCTAssertEqual(
            urlOpenerSpy.capturedUrls,
            [
                URL(string: "https://en.wikipedia.org/wiki/arnhem")!,
                URL(string: "https://en.wikipedia.org/wiki/amsterdam")!,
            ],
            "Expected second URL"
        )
    }
}

// MARK: - Helpers

private final class UrlOpenerSpy {
    
    private(set) var capturedUrls: [URL] = []
    
    func openUrl(_ url: URL) {
        capturedUrls.append(url)
    }
}
