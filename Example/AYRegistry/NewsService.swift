//
//  NewsService.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

class NewsService {
    
    let parser: NewsParser
    
    init(parser: NewsParser) {
        self.parser = parser
        print("News service init")
    }
    
}
