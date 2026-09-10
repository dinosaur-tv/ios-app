import Foundation

enum DinoHomeLinks {
    static var homeURL: URL {
        let raw = UserDefaults.standard.string(forKey: "dinoServer") ?? ""
        if let configured = serverURL(raw) { return configured }
        guard let placeholder = URL(string: "https://home.example.invalid/console/") else {
            preconditionFailure("Invalid static placeholder URL")
        }
        return placeholder
    }

    static func serverURL(_ input: String) -> URL? {
        guard var parts = URLComponents(string: input.trimmingCharacters(in: .whitespacesAndNewlines)),
              parts.scheme == "https", let host = parts.host, !host.isEmpty,
              parts.user == nil, parts.password == nil, parts.query == nil, parts.fragment == nil,
              ["", "/", "/console", "/console/"].contains(parts.path),
              (parts.port.map { (1...65535).contains($0) } ?? true) else { return nil }
        parts.path = "/console/"
        return parts.url
    }

    static func sanitized(_ url: URL) -> URL {
        guard url.scheme?.lowercased() == "https", url.user == nil, url.password == nil,
              url.host?.lowercased() == homeURL.host?.lowercased(),
              (url.port ?? 443) == (homeURL.port ?? 443) else {
            return homeURL
        }
        return url
    }
}
