import UIKit

extension UIButton {
    func setupAppearence(image: UIImage?, title: String?){
        setImage(image, for: .normal)
        setTitle(title, for: .normal)
        
        layer.cornerRadius = 20
        backgroundColor = .secondarySystemBackground
        translatesAutoresizingMaskIntoConstraints = false
    }
}
