//
//  Created by Peter Combee on 08/11/2024.
//

import XCTest
@testable import Locations

final class WikipediaLocationNavigatorTests: XCTestCase {
    
    func test_showLocationOnWikipedia_opensWikipediaUrl() {
        let urlOpenerSpy = UrlOpenerSpy()
        let sut = WikipediaLocationNavigator(openUrl: urlOpenerSpy.openUrl)
                
        XCTAssertEqual(
            urlOpenerSpy.openedUrls, [],
            "Expected no URL before show location"
        )

        let arnhem = Location(name: "Arnhem", latitude: 0, longitude: 0)
        sut.showLocationOnWikipedia(arnhem)
        
        XCTAssertEqual(
            urlOpenerSpy.openedUrls,
            [URL(string: "https://en.wikipedia.org/wiki/Arnhem")!],
            "Expected first URL"
        )

        let amsterdam = Location(name: "Amsterdam", latitude: 0, longitude: 0)
        sut.showLocationOnWikipedia(amsterdam)
        
        XCTAssertEqual(
            urlOpenerSpy.openedUrls,
            [
                URL(string: "https://en.wikipedia.org/wiki/Arnhem")!,
                URL(string: "https://en.wikipedia.org/wiki/Amsterdam")!,
            ],
            "Expected second URL"
        )
    }
}

// MARK: - Helpers

private final class UrlOpenerSpy {
    
    private(set) var openedUrls: [URL] = []
    
    func openUrl(_ url: URL) {
        openedUrls.append(url)
    }
}
