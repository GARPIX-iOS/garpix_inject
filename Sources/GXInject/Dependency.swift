//
//  File.swift
//  
//
//  Created by Danil on 18.01.2022.
//

import Foundation

/// Структура для хранения зависимости
public struct Dependency {
    typealias ResolveBlock<T> = () -> T

    /// Actual value will be assigned after resolve() call
    private(set) var value: Any!
    private let resolveBlock: ResolveBlock<Any>
    let name: String

    init<T>(_ block: @escaping ResolveBlock<T>) {
        /// Save block for future
        resolveBlock = block
        name = String(describing: T.self)
    }
    mutating func resolve() {
        value = resolveBlock()
    }
}

/// DSL билдер для регистрации зависимостей
@resultBuilder struct DependencyBuilder {
    static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
    static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    static func buildBlock(_ dependencies: [Dependency]...) -> [Dependency] { dependencies.reduce([], { $0 + $1 }) }
}
