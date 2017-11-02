//
//  NewsFeedInteractor.swift
//  Registry
//
//  Created by Andrey Yashnev on 28/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

class NewsFeedInteractor {
    
    weak var preseneter: NewsFeedPresenter!
    
    init() {
        print("Init \(self)")
    }
    
    deinit {
        print("Deinit \(self)")
    }
}
