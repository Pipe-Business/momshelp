import Flutter
import UIKit
import workmanager

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

      // In AppDelegate.application method
      WorkmanagerPlugin.registerBGProcessingTask(withIdentifier: "task-identifier")

      // Register a periodic task in iOS 13+
      WorkmanagerPlugin.registerPeriodicTask(withIdentifier: "be.tramckrijte.workmanagerExample.iOSBackgroundAppRefresh", frequency: NSNumber(value: 20 * 60))

    GeneratedPluginRegistrant.register(with: self)
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
      // Register a periodic task in iOS 13+
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(60*15))
      

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
