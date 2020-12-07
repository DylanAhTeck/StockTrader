//
//  WebView.swift
//  Stock Trader
//
//  Created by Dylan Ah Teck on 12/4/20.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @Binding var title: String
    var url: URL
    var loadStatusChanged: ((Bool, Error?) -> Void)? = nil
    var ticker: String
    
    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self, ticker: ticker)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
//        view.evaluateJavaScript("getChart('aapl')")
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
        //uiView.evaluateJavaScript("getChart('\(ticker)')")
        print(ticker)
        print("getAjaxChart('\(ticker)')")
//        uiView.evaluateJavaScript("getAjaxChart('\(ticker)');")
        uiView.evaluateJavaScript("getChart('\(ticker)');", completionHandler: {_,_ in print("Started")})

    }

    func onLoadStatusChanged(perform: ((Bool, Error?) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView
        let ticker: String
        init(_ parent: WebView, ticker: String) {
            self.parent = parent
            self.ticker = ticker
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            webView.evaluateJavaScript("getChart('\(ticker)')")

            parent.loadStatusChanged?(true, nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.title = webView.title ?? ""
            parent.loadStatusChanged?(false, nil)
            webView.evaluateJavaScript("getChart('\(ticker)')")
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.loadStatusChanged?(false, error)
        }
    }
}

struct Display: View {
    @State var title: String = "AMZN"
    @State var error: Error? = nil
    var ticker: String
    
    func returnURL() -> URL{
        let url = Bundle.main.url(forResource: "highchart", withExtension: "html", subdirectory: "Highchart")!
        
        return url
    }
    
    var body: some View {
      
            WebView(title: $title, url: returnURL(), ticker: ticker)
                .onLoadStatusChanged { loading, error in
                    if loading {

                        self.title = "Loading…"
                    }
                    else {

                        if let error = error {
                            self.error = error
                            if self.title.isEmpty {
                                self.title = "Error"
                            }
                        }
                        else if self.title.isEmpty {
                            self.title = "Some Place"
                        }

                    }
            }
                .clipped()
                
    }
}

struct WebView_Previews: PreviewProvider {
    static var previews: some View {
        Display(ticker: "Amazon")
    }
}
