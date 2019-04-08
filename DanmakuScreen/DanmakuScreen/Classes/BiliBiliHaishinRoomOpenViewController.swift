//
//  BiliBiliHaishinRoomOpenViewController.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Cocoa

let ConnectRoomNotificationName = NSNotification.Name("ConnectRoom")

class BiliBiliHaishinRoomOpenViewController: NSViewController {

    @IBOutlet weak var roomIDTextField: NSTextField!
    
    @IBAction func connectRoom(_ sender: Any) {
        NotificationCenter.default.post(name: ConnectRoomNotificationName, object: roomIDTextField.stringValue)
        NSApplication.shared.keyWindow!.close()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
