//
//  WebViewController.swift
//  Softgames Test
//
//  Created by Hamza Khan on 19/02/2022.
//

import UIKit
import WebKit
import Foundation

class WebViewController: UIViewController {

    let configuration = WKWebViewConfiguration()
    var webView = WKWebView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    lazy private var viewModel:WebViewModel = WebViewModelImplementation()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}


//MARK -WKNavigationDelegate/Functions
extension WebViewController:WKNavigationDelegate {
    private func setUp() {
        configuration.userContentController.add(self,name: Constant.fullNameMessageHandler)
        configuration.userContentController.add(self,name: Constant.ageMessageHandler)
        configuration.userContentController.add(self,name: Constant.getNotificationMessageHandler)

        let  rect = CGRect(x: 0, y: 0, width:self.view.frame.width, height: self.view.frame.height)
        
        webView =  WKWebView(frame: rect,
                             configuration: configuration)
        self.view.addSubview(webView)
        let url = Bundle.main.url(forResource: "Form",
                                  withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
        let request = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(request)
        setUpActivityIndicator()
    }
    
    private func setUpActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    /*
     Below function is used to trigger local notification
     */
    private func sendNotification(title:String, body:String) {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["value": "Data with local notification"]
        
        let fireDate = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: Date().addingTimeInterval(7))
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: fireDate, repeats: false)
        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)
        center.add(request) { (error) in
            if error != nil {
                print("Error = \(error?.localizedDescription ?? "error local notification")")
            }
        }
    }
    /*
     below function send full  name to webView
     */
    private func sendFullNameToWebView(fName:String,lName:String) {
        let fullName = "\(fName) \(lName)"
        let dic = ["fullName":fullName]
        let jsonString =  viewModel.createJsonForJavaScript(for: dic)
        
        webView.evaluateJavaScript("fillFullName('\(jsonString)')") { (any, error) in
            print("Error: \(String(describing: error))")
        }
    }
    
    /*
     below function send age from date to webView
     */
    private func sendAgeToWebView(DateOfBirthInString:String) {
        let age = viewModel.calcAge(dateOfBirth: DateOfBirthInString)
        let dic = ["age":age]
        let jsonString =  viewModel.createJsonForJavaScript(for: dic)
        
        webView.evaluateJavaScript("fillAge('\(jsonString)')") { (any, error) in
            print("Error : \(String(describing: error))")
        }
    }

}

//MARK -WebView ScriptMessageHandler
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == Constant.fullNameMessageHandler {
            guard let dict = message.body as? [String:AnyObject],
                  let firstName = dict["firstName"] as? String,
                  let lastName = dict["lastName"] as? String else {return}
            print(firstName)
            print(lastName)
            sendFullNameToWebView(fName: firstName, lName: lastName)
        }else if message.name == Constant.ageMessageHandler {
            guard let dict = message.body as? [String:AnyObject],
                  let dateOfBirth = dict["dobirth"] as? String  else {return}
            print(dateOfBirth)
            activityIndicator.startAnimating()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                self.sendAgeToWebView(DateOfBirthInString: dateOfBirth)
                self.activityIndicator.stopAnimating()
                
            }
        }else if message.name == Constant.getNotificationMessageHandler {
            guard let dict = message.body as? [String: AnyObject],
                  let title = dict["title"] as? String,
                  let body = dict["body"] as? String else {return}
            sendNotification(title: title, body: body)
            viewModel.closeApplication()
        }
    }
}
