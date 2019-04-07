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
    let roomID = 14917277
    override func setUp() {
        self.haishinRoom = BiliBiliHaishinRoom(urlID: 14917277)
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
        self.haishinRoom.connect()
        RunLoop.current.run()
    }

}

extension DanmakuScreenTests: BiliBiliHaishinRoomDelegate {
    func roomDidAuth(_ room: BiliBiliHaishinRoom) {
        print("Did Auth")
    }
    
    func roomDidConnect(_ room: BiliBiliHaishinRoom) {
        self.haishinRoom.doAuth()
    }
    
    func roomDidDisconnect(_ room: BiliBiliHaishinRoom) {
        print("Did Disconnect")
    }
}
