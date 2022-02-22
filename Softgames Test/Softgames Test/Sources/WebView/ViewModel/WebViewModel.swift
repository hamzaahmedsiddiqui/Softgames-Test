//
//  WebViewModel.swift
//  Softgames Test
//
//  Created by Hamza Ahmed on 21/02/2022.
//

import Foundation
import UIKit
import WebKit

protocol WebViewModel {
    func minimizeApplication()
    func sendNotification(title:String, body:String)
    func fullNameJson(for message: WKScriptMessage) -> String
    func ageJson(for message: WKScriptMessage) -> String
    func calculateAge(dateOfBirth: String?) -> Int
    func createJsonForJavaScript(for data: [String : Any]) -> String
}

class  WebViewModelImplementation:WebViewModel {
    
    func calculateAge(dateOfBirth: String?) -> Int {
        guard dateOfBirth != "" else {return 0}
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-mm-dd"
        let birthdayDate = dateFormater.date(from: dateOfBirth!)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year,
                                          from: birthdayDate!,
                                          to: now,
                                          options: [])
        guard let age = calcAge.year else {
            return 0
        }
        return age
    }
    func fullNameJson(for message: WKScriptMessage) -> String {
        guard let dict = message.body as? [String:AnyObject],
              let firstName = dict["firstName"] as? String,
              let lastName = dict["lastName"] as? String else {
                  return ""
              }
        let fullName = "\(firstName) \(lastName)"
        let dic = ["fullName": fullName]
        return self.createJsonForJavaScript(for: dic)
    }
    
    func ageJson(for message: WKScriptMessage) -> String {
        guard let dict = message.body as? [String:AnyObject],
              let dob = dict["dobirth"] as? String  else {
                  return ""
              }
        let dic = ["age": self.calculateAge(dateOfBirth: dob)]
        return  self.createJsonForJavaScript(for: dic)
    }
    
    func createJsonForJavaScript(for data: [String : Any]) -> String {
        var jsonString : String?
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data,       options: .prettyPrinted)
            jsonString = String(data: jsonData, encoding: .utf8)!
            jsonString = jsonString?.replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: "\\", with: "")
        }  catch {
            print(error.localizedDescription)
        }
        return jsonString!
    }
    /*
     Below function is used to minimize the app.
     */
    func minimizeApplication() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
    }
    /*
     Below function is used to trigger local notification
     */
    func sendNotification(title:String, body:String) {
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
    
}
