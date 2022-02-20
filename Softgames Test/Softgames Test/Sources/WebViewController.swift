//
//  WebViewController.swift
//  Softgames Test
//
//  Created by Hamza Khan on 19/02/2022.
//

import UIKit
import WebKit
import Foundation

class WebViewController: UIViewController{
    
    let fullNameMessageHandler = "fullNameMessageHandler"
    let ageMessageHandler = "ageMessageHandler"
    let configuration = WKWebViewConfiguration()
    var webView = WKWebView()
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
}

//Mark -WKNavigationDelegate
extension WebViewController:WKNavigationDelegate{
    private func setUp(){
        configuration.userContentController.add(self,name: fullNameMessageHandler)
        configuration.userContentController.add(self,name: ageMessageHandler)
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
}

//Mark -WebView ScriptMessageHandler
extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == fullNameMessageHandler {
            guard let dict = message.body as? [String:AnyObject],
                  let firstName = dict["firstName"] as? String,
            let lastName = dict["lastName"] as? String else {return}
            print(firstName)
            print(lastName)
            sendFullNameToWebView(fName: firstName, lName: lastName)
        }else if message.name == ageMessageHandler{
            guard let dict = message.body as? [String:AnyObject],
                  let dateOfBirth = dict["dobirth"] as? String  else {return}
            print(dateOfBirth)
            activityIndicator.startAnimating()

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                
                self.sendAgeToWebView(DateOfBirthInString: dateOfBirth)
                self.activityIndicator.stopAnimating()

            }
           
        }
    }
 
    
    private func sendFullNameToWebView(fName:String,lName:String) {
        let fullName = "\(fName) \(lName)"
        let dic = ["fullName":fullName]
        let jsonString =  createJsonForJavaScript(for: dic)
        
        webView.evaluateJavaScript("fillFullName('\(jsonString)')") { (any, error) in
            print("Error: \(String(describing: error))")
        }
    }
    
    private func sendAgeToWebView(DateOfBirthInString:String){
        let age = calcAge(dateOfBirth: DateOfBirthInString)
        let dic = ["age":age]
        let jsonString =  createJsonForJavaScript(for: dic)
        
        webView.evaluateJavaScript("fillAge('\(jsonString)')") { (any, error) in
            print("Error : \(String(describing: error))")
        }
    }
    
    private func calcAge(dateOfBirth: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-mm-dd"
        let birthdayDate = dateFormater.date(from: dateOfBirth)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
    
    private func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data,       options: .prettyPrinted)
            // here "jsonData" is the dictionary encoded in JSON data .
            jsonString = String(data: jsonData, encoding: .utf8)!
            
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
        }  catch {
            print(error.localizedDescription)
        }
        print(jsonString!)
        return jsonString!
    }
}
