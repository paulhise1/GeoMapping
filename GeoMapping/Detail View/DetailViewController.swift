import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    func configure(title: String, message: String, latitude: String, longitude: String) {
        titleLabel.text = title
        messageLabel.text = message
        LatitudeLabel.text = latitude
        longitudeLabel.text = longitude
    }
}
