//
//  PlotView.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa

class PlotView: NSView {
    var width: CGFloat = CGFloat(0.0)
    var height: CGFloat = CGFloat(0.0)
    var data: [Double] = []

    let yMax: Double = 20.0
    let yMin: Double = -20.0
    let fps: Double = 20.0
    let windowSec: Double = 10.0 //total seconds displayed
    
    var currentIndex: Int = 0

    func readFile(_ fileURL: URL){
        var myarray_str: [String]
        do {
            let text = try String( contentsOf: fileURL, encoding: String.Encoding.utf8 )
            myarray_str = text.components(separatedBy: .newlines)
            
        } catch let error as NSError{
            print(error.localizedDescription)
            return
        }
        
        var data: [Double] = []
        for val in myarray_str {
            if let d = Double(val) {
                data.append(d)
            }
        }
        self.data = data
        self.setNeedsDisplay(self.bounds)
    }
    
    func updateDraw(time: Double) {
        self.currentIndex = Int(time * fps)
        self.setNeedsDisplay(self.bounds)
    }
    
    override func draw(_ rect: NSRect) {
        width = rect.width
        height = rect.height

        if self.data.count>0 {
            drawWave(rect)
        }
        self.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    func drawWave(_ rect: NSRect) {
        let path = NSBezierPath()
        let origin = CGPoint(x: 0, y: height * 0.5)
        path.move(to: origin)
        
        let first = self.currentIndex - Int((self.windowSec / 2.0) * self.fps)
        let last = self.currentIndex + Int((self.windowSec / 2.0) * self.fps)
        let windowPoints: Int = Int(self.windowSec * self.fps) + 1
        
        for i in first...last {
            let x = origin.x + CGFloat(Double(i-first)/Double(windowPoints - 1)) * width
            var y = origin.y
            if i>=0 && i<self.data.count {
                y += CGFloat(self.data[i]/yMax*Double(height)*0.5)
            }
            path.line(to: CGPoint(x: x, y: y))
        }
        
        path.lineWidth = 0.6
        NSColor.black.setStroke()
        path.stroke()
        path.close()
    }
}

