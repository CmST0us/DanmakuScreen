//
//  BiliBiliHaishinPacketDispatcher.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Foundation

class CommandPacketListener {
    typealias Handler = (_ packet: BiliBiliHaishinCommandPacket) -> Void
    
    weak var sender: NSObject?
    var command: BiliBiliHaishinCommandPacket.Command
    var handler: Handler
    
    init(sender: NSObject, command: BiliBiliHaishinCommandPacket.Command, handler: @escaping Handler) {
        self.sender = sender
        self.command = command
        self.handler = handler
    }
}

class BiliBiliHaishinPacketDispatcher {
    
//    weak var delegate: BiliBiliHaishinPacketDispatcherDelegate?
    
    private var listener: [BiliBiliHaishinCommandPacket.Command: [CommandPacketListener]] = [:]
    
    private init() {
        
    }

    private func createPayloadDictionaryFromData(_ data: Data) -> [String: Any]? {
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }

    private func searchCommandHandler(_ command: BiliBiliHaishinCommandPacket) -> [CommandPacketListener.Handler] {
        if let listeners = self.listener[command.command] {
            return listeners.map { (l) -> CommandPacketListener.Handler in
                return l.handler
            }
        }
        return []
    }
    
    private func dispatchCommandPayload(_ data: Data) {
        let commandPacket = BiliBiliHaishinCommandPacket(data: data)
        if (commandPacket == nil) {
            return
        }
        
        switch commandPacket!.command {
        case .RecvDanmaku:
            let hs = self.searchCommandHandler(commandPacket!)
            if let danmaku = BiliBiliHaishinDanmakuPacket(data: data) {
                for h in hs {
                    h(danmaku)
                }
            }
            
        default:
            let _ = 0
//            print("Command \(commandPacket!.command.rawValue) not support yet")
        }
    }
    
    public static let shared = BiliBiliHaishinPacketDispatcher()
    
    func dispatch(_ data: Data) {
        let array = ByteArray(data: data)
        do {
            let packetSize = try array.readUInt32()
            let headerSize = try array.readUInt16()
            let _ = try array.readUInt16() //version
            let operationCodeRaw = try array.readUInt32()
            let operationCode = BiliBiliHaishinPacketOperationCode(rawValue: operationCodeRaw)
            let _ = try array.readUInt32() //sequence
            
            let payload = try array.readBytes(Int(packetSize) - Int(headerSize))
            
            let jsonDict = self.createPayloadDictionaryFromData(payload)
            if (jsonDict == nil) {
                return
            }
            
            if (operationCode != nil) {
                switch operationCode! {
                case .Command:
                    self.dispatchCommandPayload(payload)
                default:
                    let _ = 0
//                    print("\(operationCode!) Not support yet")
                }
            }
            
        } catch {
            print("Packet Read Error, Skip")
        }
    }
    
    func registerCommandPacketListener(sender: NSObject, command: BiliBiliHaishinCommandPacket.Command, handler: @escaping CommandPacketListener.Handler) {
        let l = CommandPacketListener(sender: sender, command: command, handler: handler)
        if (self.listener[command] == nil) {
            self.listener[command] = []
        }
        self.listener[command]!.append(l)
    }
    
    func removeListener(sender: NSObject) {
        let copyListener = self.listener
        for (key, value) in copyListener {
            var removeIndex: [Int] = []
            value.enumerated().forEach { (i) in
                if (i.element.sender == sender) {
                    removeIndex.append(i.offset)
                }
            }
            removeIndex.forEach { (i) in
                self.listener[key]!.remove(at: i)
            }
        }
    }
    
    func removeListener(sender: NSObject, command: BiliBiliHaishinCommandPacket.Command) {
        if let listeners = self.listener[command] {
            var removeIndex: [Int] = []
            listeners.enumerated().forEach { (i) in
                if (i.element.sender == sender) {
                    removeIndex.append(i.offset)
                }
            }
            removeIndex.forEach { (i) in
                self.listener[command]!.remove(at: i)
            }
        }
    }
}
