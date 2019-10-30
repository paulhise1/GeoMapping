import Foundation

protocol LocationDataSource {
    func locationsFromURL(_ url: URL) -> [Location]
}

class LocationRetriever: LocationDataSource {
    func locationsFromURL(_ url: URL) -> [Location] {
        return []
    }
}
