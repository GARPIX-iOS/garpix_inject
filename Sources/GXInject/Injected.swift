//
//  File.swift
//  
//
//  Created by Danil on 18.01.2022.
//

import Foundation

@propertyWrapper
public struct Injected<Dependency> {

    public var dependency: Dependency! // Resolved dependency
    
    public init() {}

    public var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                let copy: Dependency = Dependencies.shared.resolve()
                self.dependency = copy // Keep copy
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}
