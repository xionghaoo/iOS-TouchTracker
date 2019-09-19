//
//  DrawView.swift
//  TouchTracker
//
//  Created by xionghao on 2019/9/4.
//  Copyright © 2019 xionghao. All rights reserved.
//

import UIKit

class DrawView: UIView {
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    func stroke(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.move(to: line.begain)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // 已经完成的线使用黑色线表示
//        UIColor.black.setStroke()
        finishedLineColor.setStroke()
        for line in finishedLines {
            stroke(line: line)
        }
        
        // 当前正在画的线用红色表示
//        UIColor.red.setStroke()
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            stroke(line: line)
        }
//        if let line = currentLine {
//            UIColor.red.setStroke()
//            stroke(line: line)
//        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        currentLine = Line(begain: location, end: location)
        print(#function)
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begain: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        // 通知系统从新绘制
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//
//            finishedLines.append(line)
//        }
//
//        currentLine = nil
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 如果系统中断应用，清除正在绘制的线条
        print(#function)
        currentLines.removeAll()
        setNeedsDisplay()
    }
}
