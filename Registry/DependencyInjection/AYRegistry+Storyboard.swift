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
            swizzle1()
            swizzle2()
        }
        
        func swizzle1() {
            let originalSelector = #selector(UIStoryboard.instantiateViewController(withIdentifier:))
            let swizzledSelector = #selector(UIStoryboard.ay_swizzledInstantiateViewController(withId:))
            
            let originalMethod = class_getInstanceMethod(UIStoryboard.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(UIStoryboard.self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        func swizzle2() {
            let originalSelector = #selector(UIStoryboard.instantiateInitialViewController)
            let swizzledSelector = #selector(UIStoryboard.ay_swizzledInstantiateInitial)
            
            let originalMethod = class_getInstanceMethod(UIStoryboard.self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(UIStoryboard.self, swizzledSelector)
            
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        

    }
    
    public final func registerStoryboardInjection<ComponentType>(storyboardId: String, injection: @escaping (ComponentType) -> ()) {
        Holder.shared.storyboardInjections[storyboardId] = { injection($0 as! ComponentType) }
    }
    
}


extension UIStoryboard {
    
    func ay_swizzledInstantiateViewController(withId id: String) -> UIViewController {
        let controller = self.ay_swizzledInstantiateViewController(withId: id)
        AYRegistry.Holder.shared.storyboardInjections[id]?(controller)
        return controller
    }
    
    func ay_swizzledInstantiateInitial() -> UIViewController {
        let controller = self.ay_swizzledInstantiateInitial()
        if let storyboardId = controller.value(forKeyPath: "storyboardIdentifier") as? String {
            AYRegistry.Holder.shared.storyboardInjections[storyboardId]?(controller)
        } else if let restorationId = controller.restorationIdentifier {
            AYRegistry.Holder.shared.storyboardInjections[restorationId]?(controller)
        }
        return controller
    }
    
    
}
