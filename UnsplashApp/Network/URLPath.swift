import Foundation

enum URLPath: String {
    static var fullPath: String {
        "https://api.unsplash.com"
    }
    case randomPhoto = "/photos/random"
    case searchPhoto = "/search/photos"
}
