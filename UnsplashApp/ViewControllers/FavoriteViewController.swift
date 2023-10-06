import UIKit

// MARK: - Class
class FavoriteViewController: UIViewController {
    
    // MARK: - Properties
    private let itemsPerRow: CGFloat = 3
    private let spaceInserts = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 10)
    private var isNeedAnimate = true
    
    private var images: [UnsplashPicturesModel] = []
    
    private let detailViewController = DetailViewController()
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        images = StorageManager.fetchFavoritesList()
        isNeedAnimate = true
        collectionView.reloadData()
    }
    
    // MARK: - Setup
    private func setupCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func setupNavigation() {
        let titleLabel = UILabel.makeTitleLable(title: "Favorites")
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.setBackButton()
    }
    
    
}

// MARK: - Extension
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritePictureCell", for: indexPath) as? FavoriteCollectionViewCell else { return UICollectionViewCell() }
        
        let unsplashImage = images[indexPath.item]
        cell.unsplashImage = unsplashImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! FavoriteCollectionViewCell
        
        guard let image = cell.imageView.image else { return }
        let ID = cell.unsplashImage.id
        
        debugPrint("CLick \(ID)")
        
        detailViewController.prepareForPush(image: image, id: ID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = spaceInserts.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        spaceInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        spaceInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isNeedAnimate { return }
        if indexPath.row > 18 { return}
        UIView.makeAlphaAnimate(elements: [cell], duration: 0.3, delay: (0.05 * Double(indexPath.row)))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isNeedAnimate = false
    }
}
