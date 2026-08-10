//
//  AppDelegate.swift
//  FiveFoldGridExample
//
//  Created by Olof Hellman on 8/10/26.
//

import Cocoa
import SinterPixels

@main
class AppDelegate: NSObject, NSApplicationDelegate {
 
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let spScript = SPScript()
        Task {
            await spScript.run()
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

}

