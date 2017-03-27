//
//  ViewController.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    public var parser: NewsParser?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Didload \(parser)")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

