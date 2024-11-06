import UIKit
import Flutter
import GoogleMaps  // If using Google Maps, import this

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GMSServices.provideAPIKey("AIzaSyBzHQWn9DQ9ipSJRLAETup1MVBRVTkq-7s")  // If using Google Maps, add this
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
