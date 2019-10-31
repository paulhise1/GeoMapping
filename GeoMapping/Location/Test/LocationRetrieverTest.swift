import Foundation
import XCTest

@testable import GeoMapping

class LocationRetrieverTest: XCTestCase {
    private var subject: LocationRetriever!
    
    override func setUp() {
        super.setUp()
        subject = LocationRetriever()
    }
    func testLocationFromURL() {
        // GIVEN:
        let url = URL.testMake()
        
        // WHEN:
        let locations = subject.locationsFromURL(url)
        
        // Then:
        XCTAssert(<#T##expression: Bool##Bool#>)
        
        // it should take in a url and start a urlsession
        
        // it should recieve the url session data json as a callback
        
        //it should parse the json into locations
        
        //it should return the locations
        
    }
}
