import UIKit
import WaterfallLayout

// MARK: - Class
class ImagesViewController: UIViewController {
    
    // MARK: - Properties
    lazy var layoutButton: UIBarButtonItem = {
        UIBarButtonItem(image: UIImage(systemName: "arrow.clockwise"),style: .plain,
                        target: self, action: #selector(refreshButtonTapped))
    }()
    
    lazy var cellSizes: [CGSize] = {
        let width = 500
        var sizes = [CGSize]()
        (0...100).forEach { _ in
            let height = [300, 400, 500, 600, 700, 800, 900].randomElement()!
            sizes.append(.init(width: width, height: height))
        }
        return sizes
    }()
    
    private let layout = WaterfallLayout()
    private let spinner: UIActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    private var images = [UnsplashPicturesModel]()
    private let detailViewController = DetailViewController()
    private let searchController = UISearchController()
    private var timer: Timer?
    private var isAnimated = false
    private var isFetched = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    @objc func refreshButtonTapped() {
        getRandomImages()
        isAnimated = false
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(!isFetched) { getRandomImages() }
        debugPrint(isFetched)
        debugPrint(images.count)
    }
    
    // MARK: - Action for buttons
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        getRandomImages()
    }
    
    // MARK: - Setup func
    private func setupNavigationBar() {
        let titleLabel = UILabel.makeTitleLable(title: "Pictures")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
        navigationItem.rightBarButtonItem = layoutButton
        navigationItem.setBackButton()
        setupSearchController()
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchBar.placeholder = "Search photos by keyword"
        searchController.searchBar.delegate = self
    }
    
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func getRandomImages() {
        clearData()
        NetworkManager.shared.fetchRandomImages () { [weak self] randomPhotos in
            guard let fetchedPhotos = randomPhotos else { return }
            self?.spinner.stopAnimating()
            self?.images = fetchedPhotos
            self?.collectionView.reloadData()
            self?.isFetched = true
        }
    }
    
    func clearData(){
        images = []
        collectionView.reloadData()
        spinner.startAnimating()
        isAnimated = false
        StorageManager.clearMemory()
    }
    
    func loadMore() {
        if (images.count > StorageManager.cacheLimitNumber) { StorageManager.clearMemory() }
        guard let searchText = searchController.searchBar.text else { return }
        
        // Check what to load:
        if (!searchText.isEmpty) {
            NetworkManager.shared.page += 1
            NetworkManager.shared.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                self?.images.append(contentsOf: fetchedPhotos.results)
                self?.collectionView.reloadData()
                debugPrint("Load more with search bar")
            }
        } else {
            NetworkManager.shared.fetchRandomImages () { [weak self] randomPhotos in
                guard let fetchedPhotos = randomPhotos else { return }
                self?.images.append(contentsOf: fetchedPhotos)
                self?.collectionView.reloadData()
                debugPrint("Load more")
            }
        }
    }
    
    
}

// MARK: - UISearchBarDelegate
extension ImagesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        clearData()
        
        //  Bacause the API has a limit of 50 requests per hour, we try minimize unnecessary requests
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (_) in
            NetworkManager.shared.page = 1
            NetworkManager.shared.fetchImages(searchTerm: searchText) { [weak self] (searchResults) in
                guard let fetchedPhotos = searchResults else { return }
                
                self?.spinner.stopAnimating()
                self?.images = fetchedPhotos.results
                self?.collectionView.reloadData()
            }
            if(searchText.isEmpty) { self.getRandomImages() }
        })
    }
    
    
    // MARK: - Animation
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isAnimated { return }
        if indexPath.row > 18 { return}
        UIView.makeAlphaAnimate(elements: [cell], duration: 0.4, delay: (0.05 * Double(indexPath.row)))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isAnimated = true
    }
    
}

// MARK: - UICollectionViewDelegateWaterfallLayout
extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, numberOfColumnsInSection section: Int) -> Int {
        // You can dynamically configure the number of columns in a section here, e.g., depending on the horizontal size of the collection view.
        return traitCollection.horizontalSizeClass == .compact ? 2 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumColumnSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == images.count - 1 { loadMore() } // Load more when scrolled to last row
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCell", for: indexPath) as? RandomImagesCollectionViewCell else { return UICollectionViewCell() }
        let unsplashImage = images[indexPath.item]
        cell.unsplashImage = unsplashImage
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! RandomImagesCollectionViewCell
        
        guard let image = cell.imageView.image else { return }
        let ID = cell.unsplashImage.id
        
        debugPrint("CLick \(ID)")
        
        detailViewController.prepareForPush(image: image, id: ID)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
