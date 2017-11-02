//
//  AYRegistry+Storyboard.swift
//  Registry
//
//  Created by Andrey Yashnev on 27/03/2017.
//  Copyright © 2017 Andrey Yashnev. All rights reserved.
//

import Foundation
import UIKit

public extension AYRegistry {
    
    public static func enable() {
        let _ = Holder.shared
    }
    
    fileprivate class Holder: NSObject {
        static var shared = Holder()
        
        var storyboardInjections: [String : (Any) -> ()] = [:]
        
        override init() {
            super.init()
            swizzleInstantiateViewControllerWithId()
        }
        
        private func swizzleInstantiateViewControllerWithId() {
            let originalSelector = #selector(UIStoryboard.instantiateViewController(withIdentifier:))
            let swizzledSelector = #selector(UIStoryboard.ay_swizzledInstantiateViewController(withId:))
            
            let originalMethod = class_getInstanceMethod(UIStoryboard.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(UIStoryboard.self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
        
        
    }
    
    public final func registerStoryboardInjection<ComponentType>(_ type: ComponentType.Type,storyboardId: String, injection: @escaping (ComponentType) -> ()) {
        Holder.shared.storyboardInjections[storyboardId] = { [weak self] controller in
            self?.register(lifetime: .objectGraph, initCall: { return controller as! ComponentType })
            injection(controller as! ComponentType)
            self?.unregister(type: type)
        }
    }
    
}


extension UIStoryboard {
    
    @objc func ay_swizzledInstantiateViewController(withId id: String) -> UIViewController {
        let controller = self.ay_swizzledInstantiateViewController(withId: id)
        injectionFor(controller, withId: id)
        for child in controller.childViewControllers {
            injectionFor(child, withId: id)
        }
        return controller
    }
    
    
    private func injectionFor(_ controller: UIViewController, withId: String? = nil) {
        if let id = withId, let injection = AYRegistry.Holder.shared.storyboardInjections[id] {
            injection(controller)
            return
        }
        
        if let storyboardId = controller.value(forKeyPath: "storyboardIdentifier") as? String,
            let injection = AYRegistry.Holder.shared.storyboardInjections[storyboardId] {
            injection(controller)
            return
        } else if let restorationId = controller.restorationIdentifier,
            let injection = AYRegistry.Holder.shared.storyboardInjections[restorationId]{
            injection(controller)
            return
        }
        
        let className = String(describing: type(of: controller))
        if let injection = AYRegistry.Holder.shared.storyboardInjections[className] {
            injection(controller)
            return
        }
    }
}

