//
//  Push_To_DoApp.swift
//  Push To-Do
//
//  Created by Sahil Lavingia on 4/22/23.
//

import SwiftUI
import AVFoundation
import Alamofire
import NotionSwift
import UIKit


@main
struct Push_To_DoApp: App {
    @StateObject private var audioRecorder = AudioRecorder()
    @StateObject private var whisperNotionManager = WhisperNotionManager()
    @State private var showSettingsAlert = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioRecorder)
                .environmentObject(whisperNotionManager)
                .alert(isPresented: $showSettingsAlert) {
                    Alert(
                        title: Text("Configuration Required"),
                        message: Text("Please set the pageId and databaseId in the Settings app."),
                        primaryButton: .default(Text("Go to Settings"), action: redirectToSettingsApp),
                        secondaryButton: .cancel()
                    )
                }
                .onAppear(perform: checkConfig)
        }
    }
    
    func getInternalIntegrationToken() -> String? {
        return UserDefaults.standard.string(forKey: "internalIntegrationToken")
    }

    func getAddToDatabase() -> Bool {
        return UserDefaults.standard.bool(forKey: "addToDatabase")
    }
    
    func getPageId() -> String? {
        return UserDefaults.standard.string(forKey: "pageId")
    }

    func getDatabaseId() -> String? {
        return UserDefaults.standard.string(forKey: "databaseId")
    }

    func checkConfig() {
        if getPageId() == nil && !getAddToDatabase() ||
            getDatabaseId() == nil && getAddToDatabase() ||
            getInternalIntegrationToken() == nil {
            showSettingsAlert = true
        }
    }

    func redirectToSettingsApp() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
    }
}
