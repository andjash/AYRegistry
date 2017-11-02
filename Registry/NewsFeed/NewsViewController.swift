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
    
    var presenter: NewsFeedPresenter!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func closeAction(_ sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        print("Deinit \(self)")
    }

}

