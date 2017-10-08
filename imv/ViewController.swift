//
//  ViewController.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class ViewController: NSViewController {
    @IBOutlet weak var plotView1: PlotView!
    @IBOutlet weak var destView1: DestinationView!
    @IBOutlet weak var plotView2: PlotView!
    @IBOutlet weak var destView2: DestinationView!
    @IBOutlet weak var plotView3: PlotView!
    @IBOutlet weak var destView3: DestinationView!
    @IBOutlet weak var movieView: AVPlayerView!
    @IBOutlet weak var destViewMovie: DestinationView!
    
    @IBOutlet weak var playPauseButton: NSButton!
    @IBOutlet weak var timeSlider: NSSlider!
    @IBOutlet weak var currentLabel: NSTextField!
    @IBOutlet weak var durationLabel: NSTextField!
    
    @IBOutlet weak var titleLabel1: NSTextField!
    @IBOutlet weak var titleLabel2: NSTextField!
    @IBOutlet weak var titleLabel3: NSTextField!
    @IBOutlet weak var yMaxLabel1: NSTextField!
    @IBOutlet weak var yMinLabel1: NSTextField!
    @IBOutlet weak var yMaxLabel2: NSTextField!
    @IBOutlet weak var yMinLabel2: NSTextField!
    @IBOutlet weak var yMaxLabel3: NSTextField!
    @IBOutlet weak var yMinLabel3: NSTextField!
    
    @IBOutlet weak var padField: NSTextField!
    
    
    var timer: Timer!
    var timerStart: Date!
    var lastCurrentTime: Double = 0.0 //sec
    
    var currentTime: Double = 0.0 { //sec
        didSet {
            self.currentLabel.stringValue = createTimeString(time: self.currentTime)
            plotView1.updateDraw(time: self.currentTime)
            plotView2.updateDraw(time: self.currentTime)
            plotView3.updateDraw(time: self.currentTime)
            if let player = movieView.player { // seek only when currentTime is set by timeSlider
                if player.rate==0.0 {
                    let newTime = CMTimeMakeWithSeconds(self.currentTime, 1)
                    movieView.player!.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                }
            }
        }
    }
    
    var rate: Double = 0.0 {
        willSet {
            if newValue == 0.0 {
                if let player = movieView.player {
                    let newTime = CMTimeMakeWithSeconds(self.currentTime, 1)
                    movieView.player!.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    player.pause()
                }
                
                self.timerStart = nil
                if let timer = self.timer {
                    timer.invalidate()
                }
                self.timer = nil
            }
            else {
                if let player = movieView.player {
                    let newTime = CMTimeMakeWithSeconds(self.currentTime, 1)
                    movieView.player!.seek(to: newTime, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
                    player.play()
                }
                self.lastCurrentTime = self.currentTime
                timerStart = Date()
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
        destViewMovie.delegate=self
        destViewMovie.filteringOptions = [NSPasteboardURLReadingContentsConformToTypesKey:[AVFileTypeMPEG4]]
        
        let buttonImage = NSImage(named: "PlayButton")
        playPauseButton.image = buttonImage
        timeSlider.minValue = 0.0
        timeSlider.doubleValue = 0.0
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
    
    @IBAction func padFieldChanged(_ sender: Any) {
        if let d = Double(padField.stringValue) {
            if rate != 0.0 { //automatically stop
                rate = 0.0
            }
            plotView1.padSec = d
            plotView1.updateDraw(time: currentTime)
            plotView2.padSec = d
            plotView2.updateDraw(time: currentTime)
            plotView3.padSec = d
            plotView3.updateDraw(time: currentTime)
        }
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
            
            titleLabel1.stringValue = plotView1.title
            yMaxLabel1.stringValue = String(plotView1.yMax)
            yMinLabel1.stringValue = String(plotView1.yMin)
        }
        else if sender == destView2 {
            let gridView = GridView.init(frame: destView2.frame)
            destView2.addSubview(gridView)
            plotView2.readFile(urls[0])
            
            titleLabel2.stringValue = plotView2.title
            yMaxLabel2.stringValue = String(plotView2.yMax)
            yMinLabel2.stringValue = String(plotView2.yMin)
        }
        else if sender == destView3 {
            let gridView = GridView.init(frame: destView3.frame)
            destView3.addSubview(gridView)
            plotView3.readFile(urls[0])
            
            titleLabel3.stringValue = plotView3.title
            yMaxLabel3.stringValue = String(plotView3.yMax)
            yMinLabel3.stringValue = String(plotView3.yMin)
        }
        else if sender == destViewMovie {
            let avAsset = AVURLAsset(url: urls[0], options: nil)
            let playerItem = AVPlayerItem(asset: avAsset)
            let player = AVPlayer(playerItem: playerItem)
            movieView.player = player
            timeSlider.maxValue = CMTimeGetSeconds(player.currentItem!.asset.duration)
            durationLabel.stringValue = self.createTimeString(time: timeSlider.maxValue)
        }
        else {
            print("ERROR DestinationViewDelegate not properly called.")
        }
    }
}

extension ViewController {
    func timerAction(_ tm : Timer){
        let elapsedTime: TimeInterval = -timerStart!.timeIntervalSinceNow;
        self.currentTime = self.lastCurrentTime + elapsedTime
        self.timeSlider.doubleValue=self.currentTime
        self.currentLabel.stringValue = self.createTimeString(time: self.currentTime)
    }
}

