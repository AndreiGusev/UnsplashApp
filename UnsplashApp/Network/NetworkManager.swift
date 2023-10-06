import Foundation
import UIKit
import SDWebImage

class NetworkManager {
    
    static let shared = NetworkManager(RequestService())
    
    init(_ requestManager: RequestServiceing) {
        self.requestManager = requestManager
    }
    
    private var requestManager: RequestServiceing
    
    lazy var page = 1
    
    func fetchImages(searchTerm: String, completion: @escaping (SearchResults?) -> ()) {
        requestManager.request(searchTerm: searchTerm, id: nil) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: SearchResults.self, from: data)
            completion(decode)
        }
    }
    
    func fetchRandomImages(completion: @escaping ([UnsplashPicturesModel]?) -> ()) {
        requestManager.request(searchTerm: nil, id: nil) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: [UnsplashPicturesModel].self, from: data)
            completion(decode)
            debugPrint("Succes decode")
        }
    }
    
    func fetchAndCacheImage(unsplashPicturesModel: UnsplashPicturesModel, url: PictureURL, completion: @escaping (UIImage) -> ()) {
        let photoUrl = unsplashPicturesModel.urls[url.rawValue]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else { return }
        guard let imagePlug = UIImage(systemName: "photo") else { return }
        let imageView = UIImageView()
        
        imageView.sd_setImage(with: url) { fetchedImage, _, _, _ in
            completion(imageView.image ?? imagePlug)
        }
    }
    
    func fetchImageWithDetails(id: String, completion: @escaping (UnsplashPicturesModel?) -> ()) {
        requestManager.request(searchTerm: nil, id: id) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            let decode = self.decodeJSON(type: UnsplashPicturesModel.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
    
}

