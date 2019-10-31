import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
    }
    
    func configure(title: String, message: String, latitude: String, longitude: String) {
        titleLabel.text = title
        messageLabel.text = message
        latitudeLabel.text = latitude
        longitudeLabel.text = longitude
    }
}
