//
//  ViewController.swift
//  AlarmProject
//
//  Created by Wei Zhang on 2018-03-09.
//  Copyright © 2018 Wei Zhang. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBAction func NotificationTest(_ sender: Any) {
        let targetDate = AlarmPicker.date
        let time = getTimeUntilAlarmInSeconds(dateEnd: targetDate)!
        
        if time > 0.0 {
            timedNotification(inSeconds: time) { (success) in
                if success {
                    print("Notification Success in func Notification Test")
                }
            }
        } else {
            print("Time interval must be greater than zero")
        }
        
    }
    
    @IBOutlet weak var AlarmPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {(success, error) in
            if error != nil {
                print("Notifications Auth Error")
            } else {
                print("Notifications Auth Success")
            }
        }
    }
    
    func getTimeUntilAlarmInSeconds(dateEnd: Date) -> (Double?) {
        
        var totalSeconds = 0
        let dateStart = Date()
        print("Curren Date " + dateStart.description)
        print("Target Date " + dateEnd.description)
        let componentsLeftTime = Calendar.current.dateComponents([.minute , .hour , .day,.month, .weekOfMonth,.year], from: dateStart, to: dateEnd)
        let years = componentsLeftTime.year ?? 0
        let months = componentsLeftTime.month ?? 0
        let weeks = componentsLeftTime.weekOfMonth ?? 0
        let days = componentsLeftTime.day ?? 0
        let hours = componentsLeftTime.hour ?? 0
        let minutes = componentsLeftTime.minute ?? 0
        let seconds = componentsLeftTime.second ?? 0
        if years > 0 {
            totalSeconds += years * 365 * 24 * 60 * 60
            totalSeconds += months * 30 * 24 * 60 * 60 //Account months with different amount of days later
            totalSeconds += weeks * 7 * 24 * 60 * 60
            totalSeconds += days * 24 * 60 * 60
            totalSeconds += hours * 60 * 60
            totalSeconds += minutes * 60
            totalSeconds += seconds
        }
        print("Seconds from func getTimeUntilAlarmInSeconds " + totalSeconds.description)
        return Double(totalSeconds)
    }
    
    func timedNotification(inSeconds: TimeInterval, completion: @escaping (_ Success: Bool) ->()){
        print("reached timednotification func")
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: inSeconds, repeats: false)
        
        let content = UNMutableNotificationContent()
        
        content.title = "Wakey Wakey"
        content.subtitle = "Time to get up!"
        content.body = "blah blah blah"
        
        let request = UNNotificationRequest(identifier: "customNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) {(error) in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}

