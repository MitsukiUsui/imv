//
//  ViewController.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet weak var plotView1: PlotView!
    @IBOutlet weak var destView1: DestinationView!
    @IBOutlet weak var plotView2: PlotView!
    @IBOutlet weak var destView2: DestinationView!
    @IBOutlet weak var plotView3: PlotView!
    @IBOutlet weak var destView3: DestinationView!

    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var timeSlider: NSSlider!
    @IBOutlet weak var currentLabel: NSTextField!
    @IBOutlet weak var durationLabel: NSTextField!
    
    
    var timer: Timer!
    var startTime: Date!
    
    var lastCurrentTime: Double = 0.0 //sec
    
    var currentTime: Double = 0.0 { //sec
        didSet {
            self.currentLabel.stringValue = createTimeString(time: self.currentTime)
            plotView1.updateDraw(time: self.currentTime)
            plotView2.updateDraw(time: self.currentTime)
            plotView3.updateDraw(time: self.currentTime)
        }
    }
    
    var rate: Double = 0.0 {
        willSet {
            if newValue == 0.0 {
                self.startTime = nil
                if let timer = self.timer {
                    timer.invalidate()
                }
                self.timer = nil
            }
            else {
                self.lastCurrentTime = self.currentTime
                startTime = Date()
                timer = Timer.scheduledTimer(timeInterval: 0.05,
                                             target: self,
                                             selector: #selector(timerAction),
                                             userInfo: nil,
                                             repeats: true);
                timer.fire()
            }
            let buttonImageName = newValue == 0.0 ? "PlayButton" : "PauseButton"
            let buttonImage = NSImage(named: buttonImageName)
            playPauseButton.image = buttonImage
        }
    }
    
    let timeRemainingFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        destView1.delegate=self
        destView2.delegate=self
        destView3.delegate=self
        
        let buttonImage = NSImage(named: "PlayButton")
        playPauseButton.image = buttonImage
        timeSlider.minValue = 0.0
        timeSlider.maxValue = 60.0
        timeSlider.doubleValue = 0.0
        durationLabel.stringValue = self.createTimeString(time: timeSlider.maxValue)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func playPauseButtonWasPressed(_ sender: Any) {
        if rate == 0.0 {
            rate = 1.0
        }
        else {
            rate = 0.0
        }
    }
    

    @IBAction func timeSliderDidChanged(_ sender: Any) {
        if rate != 0.0 { //automatically stop
            rate = 0.0
        }
        self.currentTime = self.timeSlider.doubleValue
    }
    
    func createTimeString(time: Double) -> String {
        let components = NSDateComponents()
        components.second = Int(max(0.0, time))
        
        return timeRemainingFormatter.string(from: components as DateComponents)!
    }
}

extension ViewController: DestinationViewDelegate {
    func processURLs(sender: DestinationView, urls: [URL]) {
        if sender==destView1 {
            let gridView = GridView.init(frame: destView1.frame) //ToDo add gridView only when needed
            destView1.addSubview(gridView)
            plotView1.readFile(urls[0])
        }
        else if sender == destView2 {
            let gridView = GridView.init(frame: destView2.frame)
            destView2.addSubview(gridView)
            plotView2.readFile(urls[0])
        }
        else if sender == destView3 {
            let gridView = GridView.init(frame: destView3.frame)
            destView3.addSubview(gridView)
            plotView3.readFile(urls[0])
        }
        else {
            print("ERROR DestinationViewDelegate not properly called.")
        }
    }
}

extension ViewController {
    func timerAction(_ tm : Timer){
        let elapsedTime: TimeInterval = -startTime!.timeIntervalSinceNow;
        self.currentTime = self.lastCurrentTime + elapsedTime
        self.timeSlider.doubleValue=self.currentTime
        self.currentLabel.stringValue = self.createTimeString(time: self.currentTime)
    }
}

