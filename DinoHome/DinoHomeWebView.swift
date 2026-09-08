import SwiftUI
import WebKit

struct DinoHomeWebView: UIViewRepresentable {
    @ObservedObject var model: DinoHomeWebModel

    func makeCoordinator() -> Coordinator { Coordinator(model: model) }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        configuration.applicationNameForUserAgent = "DinoHome/\(version)"
        configuration.userContentController.addUserScript(
            WKUserScript(
                source: "window.__DINO_NATIVE_IOS__ = true;",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        model.attach(webView)
        return webView
    }

    func updateUIView(_: WKWebView, context _: Context) {}

    final class Coordinator: NSObject, WKNavigationDelegate {
        private let model: DinoHomeWebModel
        init(model: DinoHomeWebModel) { self.model = model }

        func webView(_ webView: WKWebView, didCommit _: WKNavigation!) {
            guard let url = webView.url, DinoHomeLinks.sanitized(url) == url else { return }
            model.didFinishLoading()
        }

        func webView(_: WKWebView, didFinish _: WKNavigation!) {
            model.didFinishLoading()
        }

        func webView(_: WKWebView, didFail _: WKNavigation!, withError error: Error) {
            model.didFailLoading(error: error)
        }

        func webView(
            _: WKWebView,
            didFailProvisionalNavigation _: WKNavigation!,
            withError error: Error
        ) {
            model.didFailLoading(error: error)
        }

        func webView(
            _: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else { decisionHandler(.cancel); return }
            let scheme = url.scheme?.lowercased() ?? ""
            if ["blob", "data", "about", "file"].contains(scheme) {
                decisionHandler(.allow)
                return
            }
            if DinoHomeLinks.sanitized(url) == url {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.cancel)
            if navigationAction.targetFrame?.isMainFrame != false {
                model.open(DinoHomeLinks.homeURL)
            }
        }
    }
}
