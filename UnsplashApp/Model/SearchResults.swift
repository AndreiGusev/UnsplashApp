import Foundation

struct SearchResults: Codable {
    let total: Int?
    let results: [UnsplashPicturesModel]
}
