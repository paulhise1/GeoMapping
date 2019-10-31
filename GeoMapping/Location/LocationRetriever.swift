import Foundation
import Combine

protocol LocationDataSource {
    func locationsFromURL(_ url: URL) -> [Location]
}

class LocationRetriever: LocationDataSource {
    func locationsFromURL(_ url: URL) -> Future<[Location], > {
        // it should take in a url and start a urlsession
        
        
        // it should recieve the url session data json as a callback
        
        //it should parse the json into locations
        
        //it should return the locations
        return []
    }
}
