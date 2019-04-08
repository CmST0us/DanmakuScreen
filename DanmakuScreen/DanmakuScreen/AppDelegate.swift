//
//  AppDelegate.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        NSApplication.shared.windows[0].isOpaque = false
        NSApplication.shared.windows[0].backgroundColor = NSColor.clear
    }

    @IBAction func pinToTop(_ sender: NSMenuItem) {
        if (sender.state == .off) {
            // 打开
            NSApplication.shared.keyWindow?.level = .statusBar
        } else {
            NSApplication.shared.keyWindow?.level = .normal
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func pinToTop() {
        
    }

}

