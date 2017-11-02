//
//  AYRegistry.swift
//  Registry
//
//  Created by Andrey Yashnev on 26/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation

open class AYRegistry {
    
    private final var singletones: [String : Any] = [:]
    private final var graphObjects: [String : AnyObject] = [:]
    private final var graphs: [String] = []
    private final var graphStackDepth = 0
    private final var objectsInitCalls: [String : () -> Any] = [:]
    private final var objectsInjectCalls: [String : (Any) -> ()] = [:]
    
    public init() {}
    
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
    
    public final func unregister<ComponentType>(type: ComponentType.Type) {
        let key = String(describing: Swift.type(of: ComponentType.self))
        if let index = graphs.index(of: key) {
            graphs.remove(at: index)
        }
        singletones[key] = nil
        objectsInitCalls[key] = nil
        objectsInjectCalls[key] = nil
    }
    
    public final func resolve<ComponentType>() -> ComponentType {
        defer {
            if graphStackDepth == 0 {
                graphObjects.removeAll()
            }
        }
        
        
        let key = String(describing: type(of: ComponentType.self))
        
        if let result = singletones[key] as? ComponentType {
            return result
        }
        
        if let result = singletones[key] as? () -> ComponentType {
            let object = result()
            singletones[key] = object
            graphStackDepth += 1
            objectsInjectCalls[key]?(object)
            graphStackDepth -= 1
            return object
        }
        
        var graphObject = false
        if graphs.contains(key) {
            graphObject = true
            if let res = graphObjects[key] {
                return res as! ComponentType
            }
        }
        
        guard let result = objectsInitCalls[key]?() as? ComponentType else {
            fatalError("Cannot resolve init call for \(ComponentType.self)")
        }
        
        if graphObject {
            graphObjects[key] = result as AnyObject
        }
        
        graphStackDepth += 1
        objectsInjectCalls[key]?(result)
        graphStackDepth -= 1
        
        return result
    }
}
