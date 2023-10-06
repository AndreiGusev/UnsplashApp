import UIKit

// MARK: - Class
class PhotoViewController: UIViewController {
    
    // MARK: - Properties
    var originalSizeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = false
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint()
        setConstraints()
        setupNavigationBar()
        view.backgroundColor = .systemBackground
    }
    
    //MARK: - Ыуегз UI + constraints
    private func setConstraints() {
        view.addSubview(originalSizeImage)
        NSLayoutConstraint.activate([
            originalSizeImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            originalSizeImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            originalSizeImage.topAnchor.constraint(equalTo: view.topAnchor),
            originalSizeImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveAction)
        )
    }
    
    // MARK: - Action for buttons
    @objc private func saveAction() {
        guard let image = originalSizeImage.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageWillSave(_:_:_:)), nil)
    }
    
    @objc func imageWillSave(_ image: UIImage, _ error: Error?, _ contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(with: "Error while saving", and: error.localizedDescription)
        } else {
            showAlert(with: "Save successfully", and: "Image has been saved to your photo library.")
        }
    }
    
    // MARK: - Alerts
    private func showAlert(with title: String, and massage: String) {
        let alert = UIAlertController(title: title, message: massage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
}
