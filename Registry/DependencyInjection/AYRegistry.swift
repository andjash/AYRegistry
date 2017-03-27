//
//  AYRegistry.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

public class AYRegistry {
    
    private var singletones: [String : Any] = [:]
    private var objectsInitCalls: [String : () -> Any] = [:]
    private var objectsInjectCalls: [String : (Any) -> ()] = [:]
    
    public enum Lifetime {
        case prototype
        case singletone(lazy: Bool)
    }
    
    public final func register<ComponentType>(lifetime: Lifetime = .singletone(lazy: true),
                               initCall: @escaping () -> ComponentType,
                               injectCall: ((ComponentType) -> ())? = nil) {
        let key = String(describing: type(of: ComponentType.self))
        
        switch lifetime {
        case .prototype:
            objectsInitCalls[key] = initCall
            objectsInjectCalls[key] = { injectCall?($0 as! ComponentType) }
        case .singletone(lazy: true):
            singletones[key] = initCall
            objectsInjectCalls[key] = { injectCall?($0 as! ComponentType) }
        case .singletone(lazy: false):
            let object = initCall()
            singletones[key] = object
            injectCall?(object)
        }
    }
    
    public final func resolve<ComponentType>() -> ComponentType {
        let key = String(describing: type(of: ComponentType.self))
        
        if let result = singletones[key] as? ComponentType {
            return result
        }
        
        if let result = singletones[key] as? () -> ComponentType {
            let object = result()
            singletones[key] = object
            objectsInjectCalls[key]?(object)
            return object
        }
        
        guard let result = objectsInitCalls[key]?() as? ComponentType else {
            fatalError("Cannot resolve init call for \(ComponentType.self)")
        }
      
        objectsInjectCalls[key]?(result)
        return result
    }
}
