//
//  ViewController.swift
//  BCForward_DSW
//
//  Created by Rave Bizz on 7/28/22.
//

import UIKit

class ViewController: UIViewController {
    
    var reporter = PriceReporter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(reporter.generate())
    }


}

