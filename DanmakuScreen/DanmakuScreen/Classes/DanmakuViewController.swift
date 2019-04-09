//
//  DanmakuViewController.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Cocoa

class DanmakuViewController: NSViewController {

    var haishinRoom: BiliBiliHaishinRoom!
    var danmakuBoard: DanmakuBoardView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willConnectRoom(_:)), name: ConnectRoomNotificationName, object: nil)
        
        
        self.danmakuBoard = DanmakuBoardView(frame: NSRect.zero)
        self.view.addSubview(self.danmakuBoard)
        self.danmakuBoard.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
    }
    
    func registerDanmakuHandler() {
        BiliBiliHaishinPacketDispatcher.shared.registerCommandPacketListener(sender: self, command: .RecvDanmaku) { [weak self] (packet) in
            if let danmakuPacket = packet as? BiliBiliHaishinDanmakuPacket {
//                print("\(danmakuPacket.authorNick): \(danmakuPacket.text)")
                DispatchQueue.main.async {
                    let danmaku = DanmakuModel(author: danmakuPacket.authorNick, text: danmakuPacket.text)
                    self?.danmakuBoard.pushDanmaku(danmaku)
                }
            }
        }
    }
    
    @objc func willConnectRoom(_ noti: Notification) {
        BiliBiliHaishinPacketDispatcher.shared.removeListener(sender: self)
        if (self.haishinRoom != nil) {
            self.haishinRoom.stopHearbeat()
        }
        self.registerDanmakuHandler()
        if let roomID = noti.object as? String {
            self.haishinRoom = BiliBiliHaishinRoom(urlID: Int(roomID)!)
            self.haishinRoom.delegate = self
            let _ = self.haishinRoom.fetchRoomID()
            print("Connect Room \(String(self.haishinRoom.roomID))")
            self.haishinRoom.connect()
        }
    }
    
    override func viewDidDisappear() {
        self.haishinRoom.stopHearbeat()
        self.haishinRoom.disconnect()
    }
}


extension DanmakuViewController: BiliBiliHaishinRoomDelegate {
    func roomDidConnect(_ room: BiliBiliHaishinRoom) {
        self.haishinRoom.doAuth()
        self.haishinRoom.startHeartbeat()
    }
    
    func roomDidDisconnect(_ room: BiliBiliHaishinRoom) {
        self.haishinRoom.stopHearbeat()
    }
}
