import UIKit
import MapKit

protocol DetailViewControllerDelegate: class {
    func detailViewDidLoad()
}

class DetailViewController: UIViewController {
    
    weak var delegate: DetailViewControllerDelegate?
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        
        delegate?.detailViewDidLoad()
    }
    
    func configure(title: String, message: String, latitude: String, longitude: String, coordinateRegion: MKCoordinateRegion) {
        titleLabel.text = title
        messageLabel.text = message
        latitudeLabel.text = latitude
        longitudeLabel.text = longitude
        
        detailMapView.setRegion(coordinateRegion, animated: false)
        detailMapView.isUserInteractionEnabled = false
    }
}
