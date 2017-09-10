//
//  GridView.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa

class GridView: NSView {
    var width: CGFloat!
    var height: CGFloat!
    
    
    override func draw(_ rect: NSRect) {
        self.width = rect.width
        self.height = rect.height
        
        let path = NSBezierPath(rect:bounds)
        path.lineWidth = 0.5
        path.stroke()
        path.close()
        
        drawVerticleLines(3)
        drawHorizontalLines(1)
    }
    
    func drawVerticleLines(_ lineCount: Int) {
        for i in 0..<lineCount {
            let x = CGFloat(Double(i+1)/Double(lineCount+1)) * self.width
            self.drawLine(
                from: CGPoint(x: x, y: 0),
                to: CGPoint(x: x, y: self.height)
            )
        }
    }
    
    func drawHorizontalLines(_ lineCount: Int) {
        for i in 0..<lineCount {
            let y = CGFloat(Double(i+1)/Double(lineCount+1)) * self.height
            self.drawLine(
                from: CGPoint(x: 0, y: y),
                to: CGPoint(x: self.width, y: y)
            )
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint) {
        let linePath = NSBezierPath()
        
        linePath.move(to: from)
        linePath.line(to: to)
        
        linePath.lineWidth = 0.3
        let color = NSColor.gray
        color.setStroke()
        linePath.stroke()
        linePath.close()
    }
    
}


