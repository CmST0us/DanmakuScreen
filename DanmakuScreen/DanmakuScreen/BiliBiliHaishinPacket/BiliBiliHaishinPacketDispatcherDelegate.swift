//
//  BiliBiliHaishinPacketDispatcherDelegate.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Foundation

protocol BiliBiliHaishinPacketDispatcherDelegate: NSObjectProtocol {
    func dispatcherDidRecvServerHeartbeat(_ dispatcher: BiliBiliHaishinPacketDispatcher)
}
