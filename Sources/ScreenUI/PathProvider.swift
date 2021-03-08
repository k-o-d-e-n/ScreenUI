//
//  PathProvider.swift
//  Pods
//
//  Created by Denis Koryttsev on 06.03.2021.
//

import Foundation

public protocol UnknownPathProvider {
    subscript<U,T>(next path: KeyPath<U, T>) -> T { get }
    func index<U>(of keyPath: PartialKeyPath<U>) -> Int
    func keyPath<U>(at index: Int) -> PartialKeyPath<U>
}
extension UnknownPathProvider {
    public func index<U>(of keyPath: PartialKeyPath<U>) -> Int { fatalError("unimplemented") }
    public func keyPath<U>(at index: Int) -> PartialKeyPath<U> { fatalError("unimplemented") }
}
public protocol PathProvider {
    associatedtype PathFrom
    subscript<T>(next path: KeyPath<PathFrom, T>) -> T { get }
    func index(of keyPath: PartialKeyPath<PathFrom>) -> Int
    func keyPath(at index: Int) -> PartialKeyPath<PathFrom>
}
extension PathProvider {
    public func index(of keyPath: PartialKeyPath<PathFrom>) -> Int { fatalError("unimplemented") }
    public func keyPath(at index: Int) -> PartialKeyPath<PathFrom> { fatalError("unimplemented") }
}
extension PathProvider where PathFrom == Self {
    public subscript<T>(next path: KeyPath<Self, T>) -> T { self[keyPath: path] }
}
extension UnknownPathProvider where Self: PathProvider {
    public subscript<U,T>(next path: KeyPath<U, T>) -> T {
        self[next: path as! KeyPath<PathFrom, T>]
    }
    public func index<U>(of keyPath: PartialKeyPath<U>) -> Int { index(of: keyPath as! PartialKeyPath<PathFrom>) }
    public func keyPath<U>(at index: Int) -> PartialKeyPath<U> { keyPath(at: index) as! PartialKeyPath<U> }
}

/// -----------

class _PathFrom<From>: PathProvider {
    subscript<T>(next path: KeyPath<From, T>) -> T { fatalError("unimplemented") }
    func index(of keyPath: PartialKeyPath<From>) -> Int { fatalError("unimplemented") }
    func keyPath(at index: Int) -> PartialKeyPath<From> { fatalError("unimplemented") }
}
final class __PathFrom<Base>: _PathFrom<Base.PathFrom> where Base: PathProvider {
    let base: Base
    init(base: Base) { self.base = base }
    override subscript<T>(next path: KeyPath<Base.PathFrom, T>) -> T {
        base[next: path]
    }
    override func index(of keyPath: PartialKeyPath<Base.PathFrom>) -> Int { base.index(of: keyPath) }
    override func keyPath(at index: Int) -> PartialKeyPath<Base.PathFrom> { base.keyPath(at: index) }
}
