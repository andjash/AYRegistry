//
//  CoreRegistry.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry


class CoreRegistry: AYRegistry {
    
    override init() {
        super.init()
        
        register(initCall: { NewsService(parser: self.resolve() as NewsParser) })
        
        register(initCall: { NewsParser() }) { obj in
            obj.feedParser = self.resolve() as FeedParser
        }
        
        register(initCall: { FeedParser() }) { obj in
            obj.newsParser = self.resolve() as NewsParser
        }
    }
    
}
