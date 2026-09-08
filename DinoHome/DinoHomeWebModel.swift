import Foundation
import SwiftUI
import WebKit

enum DinoHomeLoading {
    static let timeoutSeconds: TimeInterval = 12

    static func shouldIgnore(_ error: Error?) -> Bool {
        guard let error else { return false }
        return (error as? URLError)?.code == .cancelled || (error as NSError).code == NSURLErrorCancelled
    }
}

@MainActor
final class DinoHomeWebModel: ObservableObject {
    @Published var isLoading = true
    @Published var showOfflineOverlay = false
    weak var webView: WKWebView?
    private var pendingURL: URL?
    private var loadingTimeout: Task<Void, Never>?

    func attach(_ webView: WKWebView) {
        self.webView = webView
        load(pendingURL ?? DinoHomeLinks.homeURL)
        pendingURL = nil
    }

    func open(_ url: URL) {
        let safeURL = DinoHomeLinks.sanitized(url)
        guard webView != nil else { pendingURL = safeURL; return }
        load(safeURL)
    }

    func didFinishLoading() {
        finishLoading(offline: false)
    }

    func didFailLoading(error: Error? = nil) {
        if DinoHomeLoading.shouldIgnore(error) { return }
        finishLoading(offline: true)
    }

    func reload() {
        load(webView?.url.map(DinoHomeLinks.sanitized) ?? DinoHomeLinks.homeURL)
    }

    private func load(_ url: URL) {
        showOfflineOverlay = false
        isLoading = true
        startLoadingTimeout()
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.timeoutInterval = DinoHomeLoading.timeoutSeconds
        webView?.load(request)
    }

    private func startLoadingTimeout() {
        loadingTimeout?.cancel()
        loadingTimeout = Task { [weak self] in
            let nanoseconds = UInt64(DinoHomeLoading.timeoutSeconds * 1_000_000_000)
            try? await Task.sleep(nanoseconds: nanoseconds)
            guard !Task.isCancelled else { return }
            self?.didFailLoading()
        }
    }

    private func finishLoading(offline: Bool) {
        loadingTimeout?.cancel()
        loadingTimeout = nil
        isLoading = false
        showOfflineOverlay = offline
    }
}
