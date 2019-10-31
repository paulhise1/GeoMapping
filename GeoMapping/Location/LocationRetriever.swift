import Foundation
import Combine

protocol LocationDataSource {
    func fetchLocations(from url: URL) -> Future<[Location], LocationAPIError>
}

class LocationRetriever: LocationDataSource {
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    private var subscriptions = Set<AnyCancellable>()
    
    func fetchLocations(from url: URL) -> Future<[Location], LocationAPIError> {
        return Future<[Location], LocationAPIError> { [unowned self] promise in
            self.urlSession.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw LocationAPIError.responseError((response as? HTTPURLResponse)?.statusCode ?? 500)
                    }
                    return data
            }
            .decode(type: LocationsResponse.self, decoder: self.jsonDecoder)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { (completion) in
            if case let .failure(error) = completion {
                switch error {
                case let urlError as URLError:
                    promise(.failure(.urlError(urlError)))
                case let decodingError as DecodingError:
                    promise(.failure(.decodingError(decodingError)))
                case let apiERrror as LocationAPIError:
                    promise(.failure(apiERrror))
                default:
                    promise(.failure(.genericError))
                    
                }
            }
            }, receiveValue: { promise(.success($0.waypoints)) })
                .store(in: &self.subscriptions)
        }
    }
}
