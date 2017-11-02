//
//  ModulesRegistry.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import AYRegistry

class ModulesRegistry: AYRegistry {
    
    public static let shared = ModulesRegistry()
    
    public func activate() {
        register(lifetime: .singleton(lazy: false), initCall: { CoreRegistry() })
        register(lifetime: .singleton(lazy: false), initCall: { NewsFeedStoryRegistry() })
    }
    
}
