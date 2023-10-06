import Foundation
import UIKit

extension UIImageView {
    func updateAppearenceForCell(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        contentMode = .scaleAspectFill
        layer.cornerRadius = 10
        layer.masksToBounds = true
        clipsToBounds = true
    }
}
