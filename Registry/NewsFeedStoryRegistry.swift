//
//  NewsFeedStoryRegistry.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

class NewsFeedStoryRegistry: AYRegistry {
    
    override init() {
        super.init()
        
        let coreRegistry = ModulesRegistry.shared.resolve() as CoreRegistry
        registerStoryboardInjection(storyboardId: "NewsViewController") { (controller: NewsViewController) in
            controller.parser = coreRegistry.resolve() as NewsParser
        }
        
    }
    
}
