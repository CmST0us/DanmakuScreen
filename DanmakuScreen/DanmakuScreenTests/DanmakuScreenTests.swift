//
//  DanmakuScreenTests.swift
//  DanmakuScreenTests
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import XCTest
class DanmakuScreenTests: XCTestCase {
    var haishinRoom: BiliBiliHaishinRoom!
    let roomID = 5050
    override func setUp() {
        self.haishinRoom = BiliBiliHaishinRoom(urlID: 5050)
        self.haishinRoom.delegate = self
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchRoomID() {
        XCTAssertTrue(self.haishinRoom.fetchRoomID(), "无法获取房间号")
        print("获取房间号: \(String(self.haishinRoom.roomID))")
    }

    func testAuthPacket() {
        let p = BiliBiliHaishinAuthPacket()
        p.roomID = self.roomID
        let data = p.encode()
        data
    }
    
    func testAuth() {
        self.haishinRoom.fetchRoomID()
        print("Connect Room ID: \(String(self.haishinRoom.roomID))")
        self.haishinRoom.connect()
        RunLoop.current.run()
    }
    
    func testDanmaku() {
        self.haishinRoom.fetchRoomID()
                print("Connect Room ID: \(String(self.haishinRoom.roomID))")
        self.haishinRoom.connect()
        
        BiliBiliHaishinPacketDispatcher.shared.registerCommandPacketListener(sender: self, command: .RecvDanmaku) { (packet) in
            let danmaku = packet as! BiliBiliHaishinDanmakuPacket
            print("\(danmaku.authorNick): \(danmaku.text)")
        }
        RunLoop.current.run()
    }
    
    func testGZip() {
        let s = "Hello World"
        let d = s.data(using: .utf8)!
        let zlibData = d.compress(withAlgorithm: .zlib)
        let dd = zlibData?.decompress(withAlgorithm: .zlib)
        print("\(String(data: dd!, encoding: .utf8)!)")
    }
}

extension DanmakuScreenTests: BiliBiliHaishinRoomDelegate {

    func roomDidConnect(_ room: BiliBiliHaishinRoom) {
        self.haishinRoom.doAuth()
        self.haishinRoom.startHeartbeat()
    }
    
    func roomDidDisconnect(_ room: BiliBiliHaishinRoom) {
        print("Did Disconnect")
        self.haishinRoom.stopHearbeat()
    }
}
