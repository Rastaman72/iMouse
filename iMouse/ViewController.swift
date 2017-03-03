//
//  ViewController.swift
//  iMouse
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var newPoint : CGPoint?
    var manager = iMouseManager()

    @IBAction func gestureRecognize(_ sender: UIPanGestureRecognizer) {
        newPoint = CGPoint(x: sender.translation(in: view).x, y: sender.translation(in: view).y)
        manager.sentNewPoint(point: newPoint!)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



