//
//  DestinationView.swift
//  imv
//
//  Created by 薄井光生 on 2017/09/10.
//  Copyright © 2017年 Mitsuki. All rights reserved.
//

import Cocoa
import AVFoundation

protocol DestinationViewDelegate {
    func processURLs(sender: DestinationView, urls: [URL])
}

class DestinationView: NSView {
    
    var delegate: DestinationViewDelegate?
    
    enum Appearance {
        static let lineWidth: CGFloat = 10.0
    }
    
    override func awakeFromNib() {
        setup()
    }
    
    var acceptableTypes: Set<String> { return [NSURLPboardType] }
    func setup() {
        register(forDraggedTypes: Array(acceptableTypes))
    }
    
    
    var filteringOptions = [NSPasteboardURLReadingContentsConformToTypesKey:["public.text"]] //Default
    
    func shouldAllowDrag(_ draggingInfo: NSDraggingInfo) -> Bool {
        var canAccept = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        //let type = pasteBoard.types
        if pasteBoard.canReadObject(forClasses: [NSURL.self], options: filteringOptions) {
            canAccept = true
        }
        return canAccept
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        if isReceivingDrag {
            NSColor.selectedControlColor.set()
            
            let path = NSBezierPath(rect:bounds)
            path.lineWidth = Appearance.lineWidth
            path.stroke()
        }
    }
    
    //we override hitTest so that this view which sits at the top of the view hierachy
    //appears transparent to mouse clicks
    override func hitTest(_ aPoint: NSPoint) -> NSView? {
        return nil
    }
    
    var isReceivingDrag = false {
        didSet {
            needsDisplay = true
        }
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let allow = shouldAllowDrag(sender)
        isReceivingDrag = allow
        return allow ? .copy : NSDragOperation()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDrag = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        let allow = shouldAllowDrag(sender)
        return allow
    }
    
    override func performDragOperation(_ draggingInfo: NSDraggingInfo) -> Bool {
        isReceivingDrag = false
        let pasteBoard = draggingInfo.draggingPasteboard()
        if let urls = pasteBoard.readObjects(forClasses: [NSURL.self], options:filteringOptions) as? [URL], urls.count > 0 {
            delegate?.processURLs(sender: self, urls: urls)
            return true
        }
        return false
    }
}

