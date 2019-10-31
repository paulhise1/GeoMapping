import Foundation

struct Location: Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let message: String
    let latitude: Double
    let longitude: Double
}

struct LocationsResponse: Codable {
    let waypoints: [Location]
}
