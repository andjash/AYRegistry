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
    private var graphWeakStorage = NSMapTable<NSString, AnyObject>(keyOptions: .strongMemory, valueOptions: .weakMemory)
    private var graphs: [String] = []
    private var objectsInitCalls: [String : () -> Any] = [:]
    private var objectsInjectCalls: [String : (Any) -> ()] = [:]
    
    public enum Lifetime {
        case prototype
        case objectGraph
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
        case .objectGraph:
            graphs.append(key)
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
        
        var graphObject = false
        if graphs.contains(key) {
            graphObject = true
            if let res = graphWeakStorage.object(forKey: key as NSString) {
                return res as! ComponentType
            }
        }
        
        guard let result = objectsInitCalls[key]?() as? ComponentType else {
            fatalError("Cannot resolve init call for \(ComponentType.self)")
        }
      
        if graphObject {
            graphWeakStorage.setObject(result as AnyObject, forKey: key as NSString)
        }
        
        objectsInjectCalls[key]?(result)
        return result
    }
}
