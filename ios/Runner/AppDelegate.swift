import Flutter
import UIKit
import FirebaseMessaging
import NotificationCenter


@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     Messaging.messaging().apnsToken = deviceToken
     super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
   }

  override func applicationDidBecomeActive(_ application: UIApplication) {
          application.applicationIconBadgeNumber = 0
  }
}
