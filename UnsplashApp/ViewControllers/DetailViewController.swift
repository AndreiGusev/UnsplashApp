import UIKit

// MARK: - Class
class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private var infoView = InfoView()
    
    private let imageView: UIImageView  = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var unsplashImage: UnsplashPicturesModel? {
        didSet {
            //  Asynchronously loading a higher quality image
            guard let unsplashImage = unsplashImage else { return }
            NetworkManager.shared.fetchAndCacheImage(unsplashPicturesModel: unsplashImage,
                                                     url: .regular) { [weak self] fetchedImage in
                self?.imageView.image = fetchedImage
            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.setBackButton()
        infoView.delegate = self
        generateConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIView.makeAlphaAnimate(elements: [imageView], duration: 0.6, delay: 0)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Flow func
    func prepareForPush(image: UIImage, id: String) {
        imageView.image = nil
        infoView.prepareInfoView()
        NetworkManager.shared.fetchImageWithDetails(id: id) { [weak self] (detailResults) in
            guard let fetchedPhoto = detailResults else { return }
            self?.imageView.image = image // Setup already fetched image of small quality to avoid flickers and waiting
            self?.updateDetailView(unsplashImage: fetchedPhoto)
        }
    }
    
    private func updateDetailView(unsplashImage: UnsplashPicturesModel) {
        self.unsplashImage = unsplashImage
        infoView.updateInfoView(unsplashPhoto: unsplashImage)
    }
    
    //MARK: - UI + constraints
    private func generateConstraints() {
        view.addSubview(imageView)
        view.addSubview(infoView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoView.translatesAutoresizingMaskIntoConstraints = false
        
        setupImageViewConstraints()
        setupInfoViewConstraints()
    }
    
    private func setupImageViewConstraints(){
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.8),
        ])
    }
    
    private func setupInfoViewConstraints() {
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            infoView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}


// MARK: - InfoViewDelegate
extension DetailViewController: InfoViewDelegate {
    
    func showSizeButtonTapped() {
        let photoVC = PhotoViewController()
        photoVC.originalSizeImage.image = imageView.image
        navigationController?.pushViewController(photoVC, animated: true)
    }
    
    func actionButtonTapped() {
        let shareController = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        
        present(shareController, animated: true, completion: nil)
    }
}
