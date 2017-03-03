//
//  ViewController.swift
//  iMouseMac
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import Cocoa
import Quartz
import QuartzCore

class ViewController: NSViewController {
    
    
    var mouseManager = iMouseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = NSEvent.mouseLocation()
        print(location)
        
        var newPoint = location
        newPoint.x += 50
        newPoint.y += 150
        mouseMoveAndClick(onPoint: newPoint)
    }
    
    func mouseMoveAndClick(onPoint point: CGPoint) {
        guard let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        guard let downEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseDown, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        guard let upEvent = CGEvent(mouseEventSource: nil, mouseType: .leftMouseUp, mouseCursorPosition: point, mouseButton: .left) else {
            return
        }
        moveEvent.post(tap: CGEventTapLocation.cghidEventTap)
        downEvent.post(tap: CGEventTapLocation.cghidEventTap)
        upEvent.post(tap: CGEventTapLocation.cghidEventTap)
    }
}

