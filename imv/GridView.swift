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
            var color: NSColor
            var lineWidth: Double
            if (i==1){ //TODO 1 is on center only when lineCount==3. Fixit!
                color=NSColor.red
                lineWidth=1
            }else{
                color=NSColor.gray
                lineWidth=0.3
            }
            
            self.drawLine(
                from: CGPoint(x: x, y: 0),
                to: CGPoint(x: x, y: self.height),
                color: color,
                lineWidth: lineWidth
            )
        }
    }
    
    func drawHorizontalLines(_ lineCount: Int) {
        for i in 0..<lineCount {
            let y = CGFloat(Double(i+1)/Double(lineCount+1)) * self.height
            self.drawLine(
                from: CGPoint(x: 0, y: y),
                to: CGPoint(x: self.width, y: y),
                color: NSColor.gray,
                lineWidth: 0.3
            )
        }
    }
    
    func drawLine(from: CGPoint, to: CGPoint, color: NSColor, lineWidth: Double) {
        let linePath = NSBezierPath()
        
        linePath.move(to: from)
        linePath.line(to: to)
        
        linePath.lineWidth = CGFloat(lineWidth)
        color.setStroke()
        linePath.stroke()
        linePath.close()
    }
    
}


