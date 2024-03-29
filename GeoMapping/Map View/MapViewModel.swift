import Foundation
import MapKit
import Combine

protocol MapViewModelDelegate: class {
    func createPinsFromAnnotations(_ annotations: [MKPointAnnotation])
    func setCoordinateRegionOnMap(_ coordinateRegion: MKCoordinateRegion)
    func resetSelectedMapPin()
}

class MapViewModel {
    private struct Constant {
        static let initialLocation = CLLocation(latitude: 47.650467, longitude: -122.349935)
        static let initialRegionRadius: CLLocationDistance = 500
        static let detailRegionRadius: CLLocationDistance = 150
        static let showDetailViewSegue = "ShowDetailViewSegue"
        static let locationsEndpointString = "https://codetest.geocaching.com/destinations"
        static let detailViewControllerColor = UIColor(red: 4/255.0, green: 114/255.0, blue: 77/255.0, alpha: 1)
    }
    
    weak var delegate: MapViewModelDelegate?
    
    private let locationRetriever = LocationRetriever()
    private let locationsURL = URL(string: Constant.locationsEndpointString)
    private var subscriptions = Set<AnyCancellable>()
    private var selectedLocation: Location?
    private var detailViewController: DetailViewController? {
        didSet {
            guard let detailViewController = detailViewController else { return }
            detailViewController.delegate = self
        }
    }
    private var locations: [Location]? {
        didSet {
            guard let locations = locations else { return }
            delegate?.createPinsFromAnnotations(annotationsFromLocations(locations))
        }
    }
    private let imageURLs: [Int: URL?] = LocationImageURLDataStore.urls
    
    public var selectedAnnotation: MKAnnotation?
    public let detailViewSegueID = Constant.showDetailViewSegue
    
    public func mapViewDidAppear() {
        centerMapAtCLLocation(Constant.initialLocation, with: Constant.initialRegionRadius)
        
        retrieveLocations()
        delegate?.resetSelectedMapPin()
    }
    
    public func setDetailViewController(_ detailViewController: DetailViewController) {
        self.detailViewController = detailViewController
    }
    
    private func centerMapAtCLLocation(_ clLocation: CLLocation, with regionRadius: CLLocationDistance) {
        delegate?.setCoordinateRegionOnMap(coordinateRegionFromclLocation(clLocation, with: regionRadius))
    }
    
    public func setSelectedLocationFromLocationID(_ locationTitle: String) {
        self.selectedLocation = locationForPin(locationTitle: locationTitle)
    }
    
    public func setSelectedAnnotation(_ annnotation: MKAnnotation) {
        self.selectedAnnotation = annnotation
    }
    
    private func retrieveLocations() {
        guard let locationsURL = locationsURL else { return }
        locationRetriever.fetchLocations(from: locationsURL)
        .sink(receiveCompletion: { [unowned self] completion in
            if case let .failure(error) = completion {
                self.handleError(apiError: error)
            }
            }, receiveValue: {
                let value = $0
                self.locations = value
        })
            .store(in: &subscriptions)
    }
    
    private func annotationFromLocation(_ location: Location) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = location.title
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        return annotation
    }
    
    private func annotationsFromLocations(_ locations: [Location]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let annotation = annotationFromLocation(location)
            annotations.append(annotation)
        }
        return annotations
    }
    
    private func configureDetailViewWithLocation(_ detailViewController: DetailViewController, _ location: Location) {
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        let imageURL = imageURLForLocation(locationID: location.id)
        let mapPinAnnotation = annotationFromLocation(location)
        mapPinAnnotation.title = location.title
        
        detailViewController.configure(title: location.title, message: location.message, latitude: String(describing: location.latitude), longitude: String(describing: location.longitude), coordinateRegion: coordinateRegionFromclLocation(clLocation, with: Constant.detailRegionRadius), imageURL: imageURL, navigationBarIsHidden: false, detailVeiwColor: Constant.detailViewControllerColor, mapPinAnnotation: mapPinAnnotation)
    }
    
    private func imageURLForLocation(locationID: Int) -> URL? {
        return imageURLs[locationID] ?? nil
    }
    
    private func locationForPin(locationTitle: String) -> Location? {
        return locations?.first(where: {$0.title == locationTitle})
    }
    
    private func coordinateRegionFromclLocation(_ clLocation: CLLocation, with regionRadius: CLLocationDistance) -> MKCoordinateRegion {
        return MKCoordinateRegion(center: clLocation.coordinate,
        latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    }
    
    private func handleError(apiError: LocationAPIError) {
        /*
         Appropriately handle the errors.  One example below to alert the user.
         
         let alertController = UIAlertController(title: "Error", message: apiError.localizedDescription, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         present(alertController, animated: true)
         */
    }
}

extension MapViewModel: DetailViewControllerDelegate {
    func detailViewDidLoad() {
        guard let location = selectedLocation, let detailViewController = detailViewController else { return }
        configureDetailViewWithLocation(detailViewController, location)
    }
}
