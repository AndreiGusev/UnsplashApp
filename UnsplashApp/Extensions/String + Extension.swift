import Foundation

extension String {
    func formatDate() -> String {
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from:self) ?? Date()
        return date.formatted()
    }
}
