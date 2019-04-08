//
//  BiliBiliHaishinPacket.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Foundation

enum BiliBiliHaishinPacketOperationCode: UInt32 {
    case ClientHeartbeat = 2
    case PopularValue = 3
    case Command = 5
    case Auth = 7
    case ServerHeartbeat = 8
}

// MARK: - Header
class BiliBiliHaishinPacket {
    var packetSize: UInt32 {
        return UInt32(self.headerSize) + UInt32(self.data.count)
    }
    var headerSize: UInt16 = 16
    var version: UInt16 = 1
    var operationCode: BiliBiliHaishinPacketOperationCode {
        return .ClientHeartbeat
    }
    var sequence: UInt32 = 1
    
    var data: Data {
        return Data()
    }
    
    func encode() -> Data {
        let array = ByteArray()
        array.writeUInt32(packetSize)
        array.writeUInt16(headerSize)
        array.writeUInt16(version)
        array.writeUInt32(operationCode.rawValue)
        array.writeUInt32(sequence)
        array.writeBytes(data)
        return array.data
    }
}

// MARK: - Auth Packet
class BiliBiliHaishinAuthPacket: BiliBiliHaishinPacket {
    struct AuthJSON: Codable {
        var uid: Int = 0
        var roomid: Int = 0
        var protover: Int = 1
        var platform: String = "web"
        var clientver: String = "1.4.0"
    }
    
    var roomID: Int = 0
    
    override var operationCode: BiliBiliHaishinPacketOperationCode {
        return .Auth
    }
    
    override var data: Data {
        let jsonEncoder = JSONEncoder()
        var json = AuthJSON()
        json.roomid = self.roomID
        return (try? jsonEncoder.encode(json)) ?? Data()
    }
}

// MARK: - Heartbeat Packet
class BiliBiliHaishinHeartBeatPacket: BiliBiliHaishinPacket {
    override var operationCode: BiliBiliHaishinPacketOperationCode {
        return .ClientHeartbeat
    }
}

// MARK: - Command Packet
class BiliBiliHaishinCommandPacket: BiliBiliHaishinPacket {

    enum Command: String {
        case RecvDanmaku = "DANMU_MSG"
        case SendGift = "SEND_GIFT"
        case Welcome = "WELCOME"
        case WelcomeGuard = "WELCOME_GUARD"
        case SystemMessage = "SYS_MSG"
        case Preparing = "PREPARING"
        case Live = "LIVE"
        case WishBottle = "WISH_BOTTLE"
        
        // Inner Command, Not API
        case Unsupport = "_Unsupport"
    }
    
    override var operationCode: BiliBiliHaishinPacketOperationCode {
        return .Command
    }
    
    var command: Command {
        return Command(rawValue: self.jsonObject["cmd"]! as! String) ?? .Unsupport
    }
    
    var jsonObject: [String: Any]
    
    init?(data: Data) {
        let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any>
        if (jsonObj == nil) {
            return nil
        }
        self.jsonObject = jsonObj!
    }
    
}

class BiliBiliHaishinDanmakuPacket: BiliBiliHaishinCommandPacket {
    
    var info: [Any] {
        return self.jsonObject["info"]! as! [Any]
    }
    
    var text: String {
        return self.info[1] as! String
    }
    
    var authorNick: String {
        let authorArray = self.info[2] as! [Any]
        return authorArray[1] as! String
    }
    
    var authorID: Int {
        let authorArray = self.info[2] as! [Any]
        return authorArray[0] as! Int
    }
    
}
