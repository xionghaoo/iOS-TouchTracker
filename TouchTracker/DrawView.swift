//
//  DrawView.swift
//  TouchTracker
//
//  Created by xionghao on 2019/9/4.
//  Copyright © 2019 xionghao. All rights reserved.
//

import UIKit

class DrawView: UIView {
    var currentLine: Line?
    var finishedLines = [Line]()
    
    func stroke(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = .round
        path.move(to: line.begain)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // 已经完成的线使用黑色线表示
        UIColor.black.setStroke()
        for line in finishedLines {
            stroke(line: line)
        }
        
        // 当前正在画的线用红色表示
        if let line = currentLine {
            UIColor.red.setStroke()
            stroke(line: line)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        currentLine = Line(begain: location, end: location)
        
        // 通知系统从新绘制
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        
        currentLine?.end = location
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if var line = currentLine {
            let touch = touches.first!
            let location = touch.location(in: self)
            line.end = location
            
            finishedLines.append(line)
        }
        
        currentLine = nil
        setNeedsDisplay()
    }
}
