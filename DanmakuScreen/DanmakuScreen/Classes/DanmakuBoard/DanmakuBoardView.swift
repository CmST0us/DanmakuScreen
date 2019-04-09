//
//  DanmakuBoardView.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Cocoa

class DanmakuBoardView: NSView {
    
    var danmakuViews: [DanmakuView] = []
    var maxDanmakuCount: Int = 20
    var danmakuHeight = 20
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    func adjuestDanmakuView() {
        let heidht = self.danmakuHeight
        let width = self.bounds.size.width
        let x = 0
        var y = self.bounds.size.height - CGFloat(self.danmakuHeight)
        
        for view in self.danmakuViews {
            let rect = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(width), height: CGFloat(heidht))
            view.frame = rect
            y -= CGFloat(self.danmakuHeight)
        }
        
    }
    
    func popDanmaku() {
        let v = self.danmakuViews.removeFirst()
        v.removeFromSuperview()
    }
    
    func pushDanmaku(_ danmaku: DanmakuModel) {
        let danmakuView = DanmakuView(frame: NSRect.zero)
        self.addSubview(danmakuView)
        danmakuView.danmakuModel = danmaku
        self.danmakuViews.append(danmakuView)
        if (self.danmakuViews.count > self.maxDanmakuCount) {
            self.popDanmaku()
        }
        self.adjuestDanmakuView()
    }
    
}
