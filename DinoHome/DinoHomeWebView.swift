import SwiftUI
import WebKit

struct DinoHomeWebView: UIViewRepresentable {
    @ObservedObject var model: DinoHomeWebModel

    func makeCoordinator() -> Coordinator { Coordinator(model: model) }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.customUserAgent = "DinoHome/1.0"
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

        func webView(_: WKWebView, didFinish _: WKNavigation!) { model.didFinishLoading() }
        func webView(_: WKWebView, didFail _: WKWebView!, withError _: Error) { model.didFailLoading() }

        func webView(
            _: WKWebView,
            didFailProvisionalNavigation _: WKNavigation!,
            withError _: Error
        ) {
            model.didFailLoading()
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
            if DinoHomeLinks.sanitized(url) == url { decisionHandler(.allow) } else { decisionHandler(.cancel) }
        }
    }
}
