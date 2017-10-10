//
//  CategoryView.swift
//  imv
//
//  Created by 薄井光生 on 2017/10/08.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa

class CategoryView: NSView {
    var isConfigured: Bool = false
    
    //configuration. Declared in parseConfiguration()
    var fps: Double!
    var windowSec: Double!
    
    var data: [String] = []
    var colorDct: [String: NSColor] = [:]
    var currentIndex: Int = 0
    var padSec: Double = 0

    func readFile(_ fileURL: URL){
        //1.get lines
        var lines: [String]
        do {
            let text = try String( contentsOf: fileURL, encoding: String.Encoding.utf8 )
            lines = text.components(separatedBy: .newlines)
        } catch let error as NSError{
            Swift.print(error.localizedDescription)
            return
        }
        
        //2.parse header config
        parseConfiguration(lines[0])
        parseColorConfiguration(lines[1])
        
        //3. load data
        var data: [String] = []
        for val in lines[2...] {
            data.append(val)
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
                Swift.print("WARN: bad configuration, " + substr)
            }
        }

        if let fps_str = config["fps"], let fps_d = Double(fps_str){ self.fps = fps_d } else { self.fps = 20 }
        if let windowSec_str = config["windowSec"], let windowSec_d = Double(windowSec_str){ self.windowSec = windowSec_d } else { self.windowSec = 10.0}

        assert (self.fps > 0, "ERROR: fps should be a positive value, fps="+String(fps))
        assert (self.windowSec > 0, "ERROR: windowSec should be a positive value fps="+String(self.windowSec))
    }
    
    func parseColorConfiguration(_ header: String) {
        assert ((header[header.startIndex]=="#") && (header[header.index(header.startIndex, offsetBy:1)]=="#"), "ERROR: no color configuration header found")
        
        let splitedHeader=header.suffix(header.count-2).components(separatedBy: ";")
        for substr in splitedHeader {
            let arr = substr.components(separatedBy: "=")
            if (arr.count==2) && (arr[1].count == 6) {
                colorDct[arr[0]] = NSColor(hex: arr[1], alpha: 0.2)
            }else{
                Swift.print("WARN: bad configuration, " + substr)
            }
        }
    }
    
    func updateDraw(time: Double) {
        if isConfigured {
            self.currentIndex = Int((time - self.padSec) * self.fps)
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    override func draw(_ rect: NSRect) {
        if self.data.count>0 {
            drawRectangle(rect)
        }
        self.layer?.backgroundColor = NSColor.white.cgColor
    }
    
    func drawRectangle(_ rect: NSRect) {
        let width = rect.width
        let height = rect.height
        
        let first = self.currentIndex - Int((self.windowSec / 2.0) * self.fps)
        let last = self.currentIndex + Int((self.windowSec / 2.0) * self.fps)
        let windowPoints: Int = Int(self.windowSec * self.fps) + 1

        var x: Double=0
        let y: Double=0
        var prevCtg: String? = nil
        var count: Int=0

        for i in first...last {
            var ctg: String
            if i>=0 && i<self.data.count {
                ctg = data[i]
            } else {
                ctg = "DEFAULT"
            }
            
            if let pctg = prevCtg {
                if ctg != pctg {
                    let rectWidth = Double(width) * Double(count) / Double(windowPoints)
                    let rectHeight = Double(height)
                    let rectangle = NSBezierPath(rect: CGRect(x: x,y: y, width: rectWidth, height: rectHeight))
                    
                    if let color = colorDct[pctg]{
                        color.setFill()
                        rectangle.fill()
                    }
                    rectangle.stroke()
                    
                    x += rectWidth
                    count = 1
                    prevCtg = ctg
                } else {
                    count+=1
                }
            } else {
                prevCtg = ctg
                count = 1
            }
        }
        let rectWidth = Double(width) * Double(count) / Double(windowPoints)
        let rectHeight = Double(height)
        let rectangle = NSBezierPath(rect: CGRect(x: x,y: y, width: rectWidth, height: rectHeight))
        
        if let color = colorDct[prevCtg!]{
            color.setFill()
            rectangle.fill()
        }
        rectangle.stroke()
    }
}


extension NSColor {
    
    //hexは6桁の16進数文字列（例：FF001A）、alphaは透明度0〜1
    convenience init(hex: String, alpha: CGFloat) {
        
        //文字列を2桁ずつに分ける処理
        //文字列を区切るインデックスを設定
        let r = hex.startIndex;
        let g = hex.index(r, offsetBy: 2);
        let b = hex.index(g, offsetBy: 2);
        let e = hex.index(b, offsetBy: 2);
        
        //R,G,B用に文字列を2桁ずつ3つに分解
        let hexR:String = hex.substring(with: r ..< g);
        let hexG:String = hex.substring(with: g ..< b);
        let hexB:String = hex.substring(with: b ..< e);
        
        //RGB値は0〜255なので、変換する
        let R255:CGFloat = CGFloat(Int(hexR, radix: 16) ?? 0)/255;
        let G255:CGFloat = CGFloat(Int(hexG, radix: 16) ?? 0)/255;
        let B255:CGFloat = CGFloat(Int(hexB, radix: 16) ?? 0)/255;
        
        //UIColorをRGBで指定するinitを呼ぶ
        self.init(red: R255, green: G255, blue: B255, alpha: alpha);
    }
    
    //alphaを指定しないとき(不透明度100%)
    convenience init(hex: String) {
        
        //alphaを1にして上のinitを呼ぶ
        self.init(hex: hex, alpha: 1.0);
    }
}

