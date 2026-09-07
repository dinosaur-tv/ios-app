import Foundation

enum DinoHomeLinks {
    static let homeURL = URL(string: "https://home.dym-dino.ru/console/")!
    private static let allowedHosts = Set(["home.dym-dino.ru"])

    static func sanitized(_ url: URL) -> URL {
        guard url.scheme?.lowercased() == "https", let host = url.host?.lowercased(), allowedHosts.contains(host) else {
            return homeURL
        }
        return url
    }
}
