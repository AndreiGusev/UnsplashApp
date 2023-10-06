import UIKit

// MARK: - Class
class FavoriteCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    
    var unsplashImage: UnsplashPicturesModel! {
        didSet {
            NetworkManager.shared.fetchAndCacheImage(unsplashPicturesModel: unsplashImage, url: .regular) { [weak self] fetchedImage in
                self?.imageView.image = fetchedImage
                self?.authorLabel.text = self?.unsplashImage.user?.username
            }
        }
    }
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConstraints()
        setupView()
        imageView.updateAppearenceForCell()
        imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    // MARK: - Setup 
    func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
    }
    
    func setupConstraints() {
        addSubview(imageView)
        addSubview(authorLabel)
        NSLayoutConstraint.activate ([
            
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8),
            
            authorLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            authorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            authorLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
