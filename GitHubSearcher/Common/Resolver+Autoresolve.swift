//
//  Resolver+Autoresolve.swift
// AlarmClock
//

import Swinject

public extension Resolver {
    
    func autoresolve<T>() -> T! { resolve(T.self) }
}
