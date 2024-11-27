import Flutter
import UIKit
import GoogleMaps // Google Maps SDK'yı içe aktar

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps API anahtarını burada sağlayın
    GMSServices.provideAPIKey("AIzaSyBavy6w9zoY4SPDyRWEOBwqsYhFQ2USI6s") // API anahtarınızı buraya yazın

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
