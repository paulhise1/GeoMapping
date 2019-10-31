import UIKit
import MapKit

class MapViewController: UIViewController {
    private struct Constant {
        // move to viewmodel maybe?
        static let initialLocation = CLLocation(latitude: 47.650467, longitude: -122.349935)

        static let initialRegionRadius: CLLocationDistance = 500
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }
    
    private let stubbedLocations = [Location(id: 5, title: "five", message: "this is 5", latitude: 47.6514, longitude: -122.351),
                                    Location(id: 2, title: "two", message: "this one's name is two", latitude: 47.64946, longitude: -122.34948),
                                    Location(id: 3, title: "Troll", message: "trollin Hard", latitude: 47.65105, longitude: -122.34724),
                                    Location(id: 1, title: "one", message: "one time for the 1 time", latitude: 47.64918, longitude: -122.3502596),
                                    Location(id: 4, title: "four", message: "4!!!", latitude: 47.65063, longitude: -122.35118)
    ]
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        centerMapOnLocation(location: Constant.initialLocation, regionRadius: Constant.initialRegionRadius)
        createPinsAt(locations: stubbedLocations)
    }
    
    func centerMapOnLocation(location: CLLocation, regionRadius: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
      mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func createPinsAt(locations: [Location]) {
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            annotations.append(annotation)
        }
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pinIdent = "Pin"
            var pinView: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: pinIdent) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                pinView = dequeuedView
            }
            else {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinIdent)
            }
            return pinView;
        
    }
}
