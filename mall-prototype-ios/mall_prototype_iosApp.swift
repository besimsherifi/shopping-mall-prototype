//
//  mall_prototype_iosApp.swift
//  mall-prototype-ios
//
//  Created by besim@shortcut on 21.5.25.
//

import SwiftUI
import UIKit
import Unicorn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Unicorn.configure(APIKeys.unicornAPIKey)
        return true
    }
}

@main
struct mall_prototype_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var permissionsManager = PermissionsManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if permissionsManager.hasRequestedPermissions {
                    ContentView()
                } else {
                    PermissionsView {
                        // This closure is called when permissions flow is complete
                    }
                }
            }
            .preferredColorScheme(.light)
            .onAppear {
                permissionsManager.refreshPermissionStatuses()
            }
        }
    }
}
