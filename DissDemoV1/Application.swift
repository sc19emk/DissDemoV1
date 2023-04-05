//
//  DissDemoV1App.swift
//  DissDemoV1
//
//  Created by Emily Kerkhof on 01/02/2023.
//

import SwiftUI
import Firebase // for database access
import UserNotifications // to alert users when they get a message


@main
struct Application: App {
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()

    }
    
    var body: some Scene {
        WindowGroup {
            SignInView().environmentObject(DataManager())
        }
    }

}

// Code used to implement messaging functionality that had to be removed due to not having a paid apple developer account


////
////  AppDelegate.swift
////  DissDemoV1
////
////  Created by Emily Kerkhof on 05/04/2023.
////
//
//import Foundation
//import UIKit
//import Firebase
//import FirebaseMessaging
//
//class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
//    let gcmMessageIDKey = "gcm.message_id"
//
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        Messaging.messaging().apnsToken = deviceToken
//    }
//
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register for remote notifications: \(error.localizedDescription)")
//    }
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        print(userInfo)
//        completionHandler(UIBackgroundFetchResult.newData)
//    }
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//            print("Firebase registration token: \(String(describing: fcmToken))")
//            // Save the token or send it to your server to send notifications to this device.
//    }
//}

//
//func registerForPushNotifications() {
//    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
//        print("Notification permission granted: \(granted)")
//        guard granted else { return }
//        DispatchQueue.main.async {
//            UIApplication.shared.registerForRemoteNotifications()
//        }
//    }
//}
