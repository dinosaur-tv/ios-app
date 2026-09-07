import Foundation
import SwiftUI
import WebKit

@MainActor
final class DinoHomeWebModel: ObservableObject {
    @Published var isLoading = true
    @Published var showOfflineOverlay = false
    weak var webView: WKWebView?
    private var pendingURL: URL?

    func attach(_ webView: WKWebView) {
        self.webView = webView
        webView.load(URLRequest(url: pendingURL ?? DinoHomeLinks.homeURL, cachePolicy: .reloadIgnoringLocalCacheData))
        pendingURL = nil
    }

    func open(_ url: URL) {
        let safeURL = DinoHomeLinks.sanitized(url)
        guard let webView else { pendingURL = safeURL; return }
        webView.load(URLRequest(url: safeURL))
    }

    func didFinishLoading() {
        isLoading = false
        showOfflineOverlay = false
    }

    func didFailLoading() {
        isLoading = false
        showOfflineOverlay = true
    }

    func reload() {
        showOfflineOverlay = false
        isLoading = true
        webView?.reload()
    }
}
