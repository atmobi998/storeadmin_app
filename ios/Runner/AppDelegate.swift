import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // [GMSServices provideAPIKey:@"AIzaSyANl_ls6j7deHwGanYB5cnkTiwt8m5krwY"];
    GMSServices.provideAPIKey("AIzaSyANl_ls6j7deHwGanYB5cnkTiwt8m5krwY")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
