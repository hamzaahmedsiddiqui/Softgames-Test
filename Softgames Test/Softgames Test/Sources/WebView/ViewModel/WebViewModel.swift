//
//  WebViewModel.swift
//  Softgames Test
//
//  Created by Hamza Khan on 21/02/2022.
//

import Foundation
import UIKit

protocol WebViewModel{
    func calcAge(dateOfBirth: String) -> Int
    func createJsonForJavaScript(for data: [String : Any]) -> String
    func closeApplication()
}

class  WebViewModelImplementation:WebViewModel{
    
    func calcAge(dateOfBirth: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-mm-dd"
        let birthdayDate = dateFormater.date(from: dateOfBirth)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year,
                                          from: birthdayDate!,
                                          to: now,
                                          options: [])
        let age = calcAge.year
        return age!
    }
    
     func createJsonForJavaScript(for data: [String : Any]) -> String {
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
    
    func closeApplication() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
        }
    }
    
}
