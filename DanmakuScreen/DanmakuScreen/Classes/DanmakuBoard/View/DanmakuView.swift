//
//  DanmakuView.swift
//  DanmakuScreen
//
//  Created by CmST0us on 2019/4/8.
//  Copyright © 2019 eric3u. All rights reserved.
//

import Cocoa
import SnapKit
class DanmakuView: NSView {
    
    var label: NSTextField
    var danmakuModel: DanmakuModel! {
        didSet {
            self.label.stringValue = "\(self.danmakuModel.author): \(self.danmakuModel.text)"
        }
    }
    
    override init(frame frameRect: NSRect) {
        
        
        self.label = NSTextField.init(labelWithString: "")
        self.label.maximumNumberOfLines = 5
        self.label.textColor = NSColor.white
        self.label.font = NSFont.systemFont(ofSize: 14)
        self.label.sizeToFit()
        
        super.init(frame: frameRect)
        self.addSubview(self.label)
        
        self.label.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(4)
            make.right.equalToSuperview().offset(-4)
            
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
