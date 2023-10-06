import UIKit

extension UINavigationItem {
    func setBackButton() {
        backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem?.tintColor = .black
    }
}
