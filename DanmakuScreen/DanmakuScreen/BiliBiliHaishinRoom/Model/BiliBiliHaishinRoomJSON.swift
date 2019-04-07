//
//  BiliBiliHaishinRoomJSON.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Foundation

struct BiliBiliHaishinRoomJSON: Codable {
    struct BiliBiliHaishinRoomData: Codable {
        var room_id: Int
    }
    var data: BiliBiliHaishinRoomData
}
