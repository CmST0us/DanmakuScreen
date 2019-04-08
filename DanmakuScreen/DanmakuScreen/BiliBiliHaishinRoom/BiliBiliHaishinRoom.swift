//
//  BiliBiliHaishinRoom.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import AppKit
import Starscream

class BiliBiliHaishinRoom: NSObject {
    
    static let RoomIDAPIBase = "https://api.live.bilibili.com/room/v1/Room/room_init?id="
    static let WebSocketURL = "wss://broadcastlv.chat.bilibili.com:2245/sub"
    /// 直播间URL中的ID
    var urlID: Int
    
    /// 直播间房间ID
    var roomID: Int!
    
    weak var delegate: BiliBiliHaishinRoomDelegate?
    
    //MARK: - Private
    private var heartbeatTimer: Timer!
    
    private var isConnect: Bool = false {
        didSet {
            if (self.isConnect) {
                self.delegate?.roomDidConnect(self)
            } else {
                self.delegate?.roomDidDisconnect(self)
            }
        }
    }
    
    lazy private var socket: WebSocket = {
        let s = WebSocket(url: URL(string: BiliBiliHaishinRoom.WebSocketURL)!)
        s.delegate = self
        return s
    }()
    
    // MARK: - Public
    init(urlID: Int) {
        self.urlID = urlID
    }
    
    func fetchRoomID() -> Bool {
        let url = URL(string: BiliBiliHaishinRoom.RoomIDAPIBase + "\(self.urlID)")!
        let (data, _, _) = URLSession.shared.syncDataTask(request: URLRequest(url: url))
        if (data != nil) {
            let jsonDecoder = JSONDecoder()
            let haishinRoomJSON = try? jsonDecoder.decode(BiliBiliHaishinRoomJSON.self, from: data!)
            if (haishinRoomJSON != nil) {
                self.roomID = haishinRoomJSON!.data.room_id
                return true
            }
        }
        return false
    }
    
    func connect() {
        self.socket.connect()
    }
    
    func doAuth() {
        let authPacket = BiliBiliHaishinAuthPacket()
        authPacket.roomID = self.roomID
        self.socket.write(data: authPacket.encode())
    }
    
}

extension BiliBiliHaishinRoom {
    
    func startHeartbeat() {
        self.heartbeatTimer = Timer(timeInterval: 20, target: self, selector: #selector(heartbeatHandler), userInfo: nil, repeats: true)
        RunLoop.current.add(self.heartbeatTimer, forMode: .common)
        self.heartbeatTimer.fire()
    }
    
    func stopHearbeat() {
        self.heartbeatTimer.invalidate()
        self.heartbeatTimer = nil
    }
    
    @objc func heartbeatHandler() {
        let heartbeatPacket = BiliBiliHaishinHeartBeatPacket()
        self.socket.write(data: heartbeatPacket.encode())
    }
}

// MARK: - WebSocket Delegate
extension BiliBiliHaishinRoom: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        self.isConnect = true
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        BiliBiliHaishinPacketDispatcher.shared.dispatch(data)
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.isConnect = false
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("\(text)")
    }
}
