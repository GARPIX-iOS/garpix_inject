//
//  File.swift
//  
//
//  Created by Danil on 18.01.2022.
//

import Foundation

/// DI - контейнер
public class Dependencies {
    
    static private(set) var shared = Dependencies() // 1
    fileprivate var dependencies = [Dependency]() // 2
    
    public convenience init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
        self.init()
        dependencies().forEach { register($0) }
    }

    public convenience init(@DependencyBuilder _ dependency: () -> Dependency) {
        self.init()
        register(dependency())
    }

    func register(_ dependency: Dependency) {
        // Avoid duplicates
        guard dependencies.firstIndex(where: { $0.name == dependency.name }) == nil else {
            debugPrint("\(String(describing: dependency.name)) already registered, ignoring")
            return
        }
        dependencies.append(dependency)
    }

    public func build() {
        // We assuming that at this point all needed dependencies are registered
        for index in dependencies.startIndex..<dependencies.endIndex {
            dependencies[index].resolve()
        }
        Self.shared = self // 3
    }

    func resolve<T>() -> T {
        guard let dependency = dependencies.first(where: { $0.value is T })?.value as? T else {
            fatalError("Can't resolve \(T.self)")
        }
        return dependency
    }
}
