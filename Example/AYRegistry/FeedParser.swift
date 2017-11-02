//
//  FeedParser.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation


class FeedParser {
    
    var newsParser: NewsParser?
    
    init() {
        print("Feed parser init \(self)")
    }
    
    deinit {
        print("Deinit \(self)")
    }

}
