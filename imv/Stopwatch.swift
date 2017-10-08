//
//  Stopwatch.swift
//  imv
//
//  Created by 薄井光生 on 2017/10/08.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Foundation

protocol StopwatchDelegate {
    func timeUpdate(sender: Stopwatch, currentTime: Double)
}

class Stopwatch {
    
    var delegate: StopwatchDelegate?
    
    var timer: Timer?
    var timerStart: Date?
    var lastCurrentTime: Double = 0.0 //sec
    
    init() {}
    func update(_ currentTime: Double) {
        // !!!assume only called when timer is not working.!!!
        if let timer = self.timer {
            assert (0==1,"ERROR: update() is called with stopwatch running")
        }
        
        self.lastCurrentTime=currentTime
    }
    
    func start() {
        timerStart = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.05,
                                     target: self,
                                     selector: #selector(timerAction),
                                     userInfo: nil,
                                     repeats: true);
        timer!.fire()
    }
    
    func stop() {
        if let timer = self.timer {
            timer.invalidate()
        }
        
        let elapsedTime: TimeInterval = -timerStart!.timeIntervalSinceNow;
        self.lastCurrentTime += elapsedTime
        self.timer = nil
        self.timerStart = nil
    }
    
    @objc func timerAction(_ tm : Timer){
        let elapsedTime: TimeInterval = -timerStart!.timeIntervalSinceNow;
        let currentTime = self.lastCurrentTime + elapsedTime
        delegate?.timeUpdate(sender: self, currentTime: currentTime)
    }
}
