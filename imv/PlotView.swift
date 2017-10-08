//
//  PlotView.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa

class PlotView: NSView {
    var isConfigured: Bool = false
    
    //configuration. Declared in parseConfiguration()
    var title: String!
    var fps: Double!
    var yMax: Double!
    var yMin: Double!
    var windowSec: Double!

    //data to plot
    var data: [Double] = []
    var currentIndex: Int = 0
    var padSec: Double = 0

    func readFile(_ fileURL: URL){
        //1.get lines
        var lines: [String]
        do {
            let text = try String( contentsOf: fileURL, encoding: String.Encoding.utf8 )
            lines = text.components(separatedBy: .newlines)
        } catch let error as NSError{
            print(error.localizedDescription)
            return
        }
        
        //2.parse header config
        let header = lines[0]
        parseConfiguration(header)
        
        //3. load data
        var data: [Double] = []
        for val in lines[1...] {
            if let d = Double(val) {
                data.append(d)
            }
        }
        self.data = data
        
        self.isConfigured = true
        self.setNeedsDisplay(self.bounds)
    }
    
    func parseConfiguration(_ header: String) {
        assert (header[header.startIndex]=="#", "ERROR: no configuration header found")
        
        var config: [String: String] = [:]
        let splitedHeader=header.suffix(header.count-1).components(separatedBy: ";")
        for substr in splitedHeader {
            let arr = substr.components(separatedBy: "=")
            if (arr.count==2) {
                config[arr[0]] = arr[1]
            }else{
                print("WARN: bad configuration, " + substr)
            }
        }
        
        if let title = config["title"] { self.title = title } else { self.title = "DEFAULT_TITLE"}
        if let fps_str = config["fps"], let fps_d = Double(fps_str){ self.fps = fps_d } else { self.fps = 20 }
        if let yMax_str = config["yMax"], let yMax_d = Double(yMax_str){ self.yMax = yMax_d } else { self.yMax = 10.0 }
        if let yMin_str = config["yMin"], let yMin_d = Double(yMin_str){ self.yMin = yMin_d } else { self.yMin = -10.0 }
        if let windowSec_str = config["windowSec"], let windowSec_d = Double(windowSec_str){ self.windowSec = windowSec_d } else { self.windowSec = 10.0}
        
        assert (self.yMax > self.yMin, "ERROR: yMax should be larger than yMin, yMax="+String(yMax)+", yMin="+String(yMin))
        assert (self.fps > 0, "ERROR: fps should be a positive value, fps="+String(fps))
        assert (self.windowSec > 0, "ERROR: windowSec should be a positive value fps="+String(self.windowSec))
    }
    
    func updateDraw(time: Double) {
        if isConfigured {
            self.currentIndex = Int((time - self.padSec) * self.fps)
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    override func draw(_ rect: NSRect) {
        if self.data.count>0 {
            drawWave(rect)
        }
        self.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    func drawWave(_ rect: NSRect) {
        let path = NSBezierPath()
        let origin = CGPoint(x: 0, y: 0)
        path.move(to: origin)

        let first = self.currentIndex - Int((self.windowSec / 2.0) * self.fps)
        let last = self.currentIndex + Int((self.windowSec / 2.0) * self.fps)
        let windowPoints: Int = Int(self.windowSec * self.fps) + 1
        
        for i in first...last {
            let x = origin.x + CGFloat(Double(i-first)/Double(windowPoints - 1)) * self.bounds.width
            var y = origin.y
            if i>=0 && i<self.data.count {
                y += CGFloat( (self.data[i] - self.yMin) / (self.yMax - self.yMin) * Double(self.bounds.height) )
            }
            path.line(to: CGPoint(x: x, y: y))
        }
        
        path.lineWidth = 0.6
        NSColor.black.setStroke()
        path.stroke()
        path.close()
    }
}


