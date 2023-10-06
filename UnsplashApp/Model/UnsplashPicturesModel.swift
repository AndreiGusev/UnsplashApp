import Foundation

struct UnsplashPicturesModel: Codable {
    let id: String
    let created_at: String?
    let width: Int
    let height: Int
    let downloads: Int?
    let description: String?
    let urls: [PictureURL.RawValue:String]
    let location: PictureLocation?
    let user: PictureAuthor?
}
