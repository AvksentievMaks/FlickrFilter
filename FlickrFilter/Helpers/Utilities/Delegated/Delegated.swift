//
//  Delegated.swift
//  FlickrFilter
//
//  Created by Maksim Avksentiev on 2/18/19.
//  Copyright © 2019 TEXEN. All rights reserved.
//

import Foundation

public struct Delegated<Input, Output> {
    
    private(set) var callback: ((Input) -> Output?)?
    
    public var isDelegateSet: Bool {
        
        return callback != nil
    }
    
    public init() {}
    
    public mutating func delegate<Target : AnyObject>(to target: Target, with callback: @escaping (Target, Input) -> Output) {
        
        self.callback = { [weak target] input in
            
            guard let target = target else {
                return nil
            }
            
            return callback(target, input)
        }
    }
    
    public func call(_ input: Input) -> Output? {
        
        return self.callback?(input)
    }
}

//MARK: - Delegating
extension Delegated {
    
    public mutating func stronglyDelegate<Target : AnyObject>(to target: Target, with callback: @escaping (Target, Input) -> Output) {
        self.callback = { input in
            
            return callback(target, input)
        }
    }
    
    public mutating func manuallyDelegate(with callback: @escaping (Input) -> Output) {
        
        self.callback = callback
    }
    
    public mutating func removeDelegate() {
        
        self.callback = nil
    }
}

//MARK: - (Input == Void)
extension Delegated where Input == Void {
    
    public mutating func delegate<Target : AnyObject>(to target: Target, with callback: @escaping (Target) -> Output) {
        
        self.delegate(to: target, with: { target, voidInput in callback(target) })
    }
    
    public mutating func stronglyDelegate<Target : AnyObject>(to target: Target, with callback: @escaping (Target) -> Output) {
        
        self.stronglyDelegate(to: target, with: { target, voidInput in callback(target) })
    }
    
    public func call() -> Output? {
        
        return self.call(())
    }
}

//MARK: - (Output == Void)
extension Delegated where Output == Void {
    
    public func call(_ input: Input) {
        
        self.callback?(input)
    }
}

//MARK: - (Input == Void and Output == Void)
extension Delegated where Input == Void, Output == Void {
    
    public func call() {
        
        self.call(())
    }
}
