//
//  ViewController.swift
//  iMouse
//
//  Created by Michal Niemiec on 03/03/2017.
//  Copyright © 2017 Hybris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func moveMouse(_ sender: Any) {
        manager.sentInfo()
    }
    var manager = iMouseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    

}

