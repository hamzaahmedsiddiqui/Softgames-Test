//
//  WebViewController.swift
//  Softgames Test
//
//  Created by Hamza Ahmed on 19/02/2022.
//

import UIKit
import WebKit
import Foundation
/*
 TO-DOs:
 Due to lack of time, I haven't handle the errors but would have done it if required.
 */
class WebViewController: UIViewController {
    let configuration = WKWebViewConfiguration()
    var webView:WKWebView!
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    lazy private var viewModel: WebViewModel = WebViewModelImplementation()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}
//MARK -WKNavigationDelegate/Functions
extension WebViewController:WKNavigationDelegate {
    private func setUp() {
        setupConfiguration()
        setupWebView()
        setUpActivityIndicator()
    }
    private func setupConfiguration() {
        configuration.userContentController.add(self,
                                                name: MessageHandler.fullName.rawValue)
        configuration.userContentController.add(self,
                                                name: MessageHandler.age.rawValue)
        configuration.userContentController.add(self,
                                                name:MessageHandler.notification.rawValue)
    }
    private func setupWebView() {
        let  rect = CGRect(x: 0, y: 0, width:self.view.frame.width, height: self.view.frame.height)
        webView =  WKWebView(frame: rect,
                             configuration: configuration)
        self.view.addSubview(webView)
        guard let url = Bundle.main.url(forResource: Constant.htmlFileName, withExtension: Constant.htmlFileType) else { return }
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
    }
    private func setUpActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    /*
     below function send full  name to webView
     */
    private func sendFullNameToWebView(for json: String) {
        webView.evaluateJavaScript("fillFullName('\(json)')") { (any, error) in
            print("Error: \(String(describing: error))")
        }
    }
    /*
     below function send age from date to webView
     */
    private func sendAgeToWebView(for json: String) {
        webView.evaluateJavaScript("fillAge('\(json)')") { (any, error) in
            print("Error : \(String(describing: error))")
        }
    }
}

//MARK -WebView ScriptMessageHandler
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let messageHandler = MessageHandler(rawValue: message.name)
        switch  messageHandler {
        case .fullName:
            sendFullNameToWebView(for: viewModel.fullNameJson(for: message))
        case .age:
            activityIndicator.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.sendAgeToWebView(for: self.viewModel.ageJson(for: message))
                self.activityIndicator.stopAnimating()
            }
        case .notification:
            viewModel.sendNotification(title: Constant.notificationTitle, body: Constant.notificationBody)
            viewModel.minimizeApplication()
        default:
            break
        }
        
    }
}
