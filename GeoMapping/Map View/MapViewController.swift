import UIKit
import MapKit
import Combine

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
        }
    }

    private let viewModel = MapViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        viewModel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.mapViewDidAppear()
    }
    
    private func setRegionOnMap(_ coordinateRegion: MKCoordinateRegion) {
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func showDetailView(segueIdentifier: String) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? DetailViewController {
            viewModel.setDetailViewController(destinationViewController)
        }
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        guard let annotationTitle = annotation.title else { return }
        guard let locationTitle = annotationTitle else { return }
        viewModel.setSelectedLocationFromLocationID(locationTitle)
        viewModel.setSelectedAnnotation(annotation)
        
        showDetailView(segueIdentifier: viewModel.detailViewSegueID)
    }
}

extension MapViewController: MapViewModelDelegate {
    func createPinsFromAnnotations(_ annotations: [MKPointAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    func setCoordinateRegionOnMap(_ coordinateRegion: MKCoordinateRegion) {
        setRegionOnMap(coordinateRegion)
    }
    
    func resetSelectedMapPin() {
        guard let annotationToDeselect = viewModel.selectedAnnotation else { return }
        mapView.deselectAnnotation(annotationToDeselect, animated: true)
    }
}
