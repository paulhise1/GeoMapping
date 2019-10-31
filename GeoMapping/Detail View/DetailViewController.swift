import UIKit

class DetailView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var LatitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    func configure(title: String, message: String, latitude: String, longitude: String) {
        titleLabel.text = title
        messageLabel.text = message
        LatitudeLabel.text = latitude
        longitudeLabel.text = longitude
    }
}
