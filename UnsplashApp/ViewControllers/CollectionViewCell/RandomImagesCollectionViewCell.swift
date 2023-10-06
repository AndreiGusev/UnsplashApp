import UIKit

// MARK: - Class
class RandomImagesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    
    var unsplashImage: UnsplashPicturesModel! {
        didSet {
            NetworkManager.shared.fetchAndCacheImage(unsplashPicturesModel: unsplashImage, url: .small) { [weak self] fetchedImage in
                self?.imageView.image = fetchedImage
            }
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
       super.awakeFromNib()
        setupConstraints()
        imageView.updateAppearenceForCell()
    }
    
    // MARK: - Setup 
    func setupConstraints() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
    
}


