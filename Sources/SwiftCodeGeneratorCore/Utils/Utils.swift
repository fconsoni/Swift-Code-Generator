//
//  Utils.swift
//  Commandant
//
//  Created by Leandro Linardos on 20/09/2018.
//

import Foundation

func map<A, B>(_ fx: (A) -> B, _ array: [A]) -> [B] {
  return array.map(fx)
}

func identity<T>(_ any: T) -> T {
  return any
}

func curry<A,B,R>(_ f: @escaping (A, B) -> R) -> (A) -> (B) -> (R) {
  return { a in { b in f(a,b) } }
}

func curry<A,B,C,R>(_ f: @escaping (A, B, C) -> R) -> (A) -> (B) -> (C) -> (R) {
  return { a in { b in { c in f(a,b,c) } } }
}

func curry<A,B,C,D,R>(_ f: @escaping (A, B, C, D) -> R) -> (A) -> (B) -> (C) -> (D) -> (R) {
  return { a in { b in { c in { d in f(a,b,c,d) } } } }
}

func curry<A,B,C,D,E,R>(_ f: @escaping (A, B, C, D, E) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (R) {
  return { a in { b in { c in { d in { e in f(a,b,c,d,e) } } } } }
}

func curry<A,B,C,D,E,F,R>(_ fx: @escaping (A, B, C, D, E, F) -> R) -> (A) -> (B) -> (C) -> (D) -> (E) -> (F) -> (R) {
  return { a in { b in { c in { d in { e in { f in fx(a,b,c,d,e,f) } } } } } }
}

func flip<A,B,C>(_ f: @escaping (A, B) -> C) -> (B, A) -> C {
  func mask(_ b: B, _ a: A) -> C {
    return f(a,b)
  }
  return mask
}

precedencegroup CompositionPrecedence {
  associativity: right
  higherThan: BitwiseShiftPrecedence
}

infix operator >> : CompositionPrecedence
func >> <T,U,V>(_ f: @escaping (T) -> U, _ g: @escaping (U) -> V) -> (T) -> V {
  return {g(f($0))}
}

infix operator << : CompositionPrecedence
func << <T,U,V>(_ f: @escaping (U) -> V, _ g: @escaping (T) -> U) -> (T) -> V {
  return { f(g($0)) }
}

infix operator |>
func |> <A, B>(value: A, fx: (A) -> B) -> B {
  return fx(value)
}


precedencegroup ChainPrecedence {
  associativity: left
}
infix operator *> : ChainPrecedence

@discardableResult
func *> <A>(value: A, fx: (A) -> Void) -> A {
  fx(value)
  return value
}

func times<T>(_ times: Int, _ f: ()->(T)) -> [T] {
  return (0..<times).compactMap { _ in return f() }
}

func fst<A,B>(_ tuple: (A,B)) -> A {
  return tuple.0
}

func snd<A,B>(_ tuple: (A,B)) -> B {
  return tuple.1
}

func execute<T>(_ fx: @escaping () -> T) -> T {
  return fx()
}

func nop() {}
func nop<A>(_ a: A) {}
func nop<A, B>(_ a: A, _ b: B) {}
func nop<A, B, C>(_ a: A, _ b: B, _ c:C) {}

func not(_ fx: @escaping () -> Bool) -> () -> Bool { return { return !fx() } }
func not<A>(_ fx: @escaping (A) -> Bool) -> (A) -> Bool { return { (a: A) in !fx(a) } }

infix operator <*
func <* <A>(_ originalFx: @escaping (@escaping (A) -> Void) -> Void, _ fx: @escaping () -> Void) -> Void {
  originalFx(ignoreParams(fx))
}
func <* (_ originalFx: @escaping (@escaping () -> Void) -> Void, _ fx: @escaping () -> Void) -> Void {
  originalFx(fx)
}

func ignoreParams<A>(_ fx: @escaping () -> Void) -> (A) -> Void {
  return { _ in fx() }
}


func fill<A>(_ fx: @escaping (A) -> Void, _ a: A) -> () -> Void {
  return { fx(a) }
}

extension Optional {
  func get() throws -> Wrapped {
    switch self {
    case .none: throw NSError(domain: "No wrapped value", code: 0, userInfo: nil)
    case .some(let some): return some
    }
  }
  
  func filter(_ fx: (Wrapped) -> Bool) -> Optional {
    switch self {
    case .none: return self
    case .some(let some): return fx(some) ? self : .none
    }
  }
  
  func isEmpty() -> Bool {
    switch self {
    case .some(_): return false
    case .none: return true
    }
  }
  
  func fold<U>(_ ifEmpty: U, _ tx : (Wrapped) -> U) -> U {
    switch self {
    case .some(let value): return tx(value)
    case .none: return ifEmpty
    }
  }
  
  func getOrElse(_ ifEmpty: Wrapped) -> Wrapped {
    switch self {
    case .some(let value): return value
    case .none: return ifEmpty
    }
  }
}

public enum Result<T> {
  case success(T)
  case failure(Error)
  
  init(_ f: @autoclosure () throws -> T) {
    do {
      self = .success(try f())
    } catch {
      self = .failure(error)
    }
  }
  
  init(_ error: Error) {
    self = .failure(error)
  }
  
  func get() throws -> T {
    switch self {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }
  
  func isSuccess() -> Bool {
    switch self {
    case .success(_):
      return true
    case _ :
      return false
    }
  }
  
  func map<U>(_ tx: (T) -> U) -> Result<U> {
    switch self {
    case .success(let value):
      return Result<U>.success(tx(value))
    case .failure(let error):
      return Result<U>.failure(error)
    }
  }
  
  public func flatMap<U>(_ transform: (T) -> Result<U>) -> Result<U> {
    switch self {
    case .success(let value): return transform(value)
    case .failure(let error): return .failure(error)
    }
  }
  
  func getOrElse(_ defVal: T) -> T {
    switch self {
    case .success(let value): return value
    case .failure(_): return defVal
    }
  }
  
  func toOptional() -> Optional<T> {
    switch self {
    case .success(let value):
      return Optional(value)
    case .failure:
      return .none
    }
  }
  
  func fold<U>(_ ifError: U, _ tx : (T) -> U) -> U {
    switch self {
    case .success(let value): return tx(value)
    case .failure: return ifError
    }
  }
  
  @discardableResult
  func onError(_ fx: (Error) -> Void) -> Result<T> {
    switch self {
    case .success:
      return self
    case .failure(let error):
      fx(error)
      return self
    }
  }
}

public func ==<T>(lhs: Result<T>, rhs: Result<T>) -> Bool {
  switch (lhs, rhs) {
  case (.success, .success): return true
  case (.failure, .failure): return true
  default: return false
  }
}

//COLLECTION.UTILS

extension Array {
  func appending(_ newElement: Element) -> Array {
    var copy = Array(self)
    copy.append(newElement)
    return copy
  }
  
  func appending(_ newElements: [Element]) -> Array {
    var copy = Array(self)
    copy.append(contentsOf: newElements)
    return copy
  }
  
  mutating func replaceLastWith(_ element: Element) {
    self.removeLast()
    self.append(element)
  }
  
  func removingFirst() -> Array {
    var copy = Array(self)
    copy.remove(at: 0)
    return copy
  }
  
  func removingLast() -> Array {
    if self.isEmpty {
      return []
    }
    var copy = Array(self)
    copy.removeLast()
    return copy
  }
}

extension String {
  func lines() -> [String] {
    return separateBy("\n")
  }
  
  func words() -> [String] {
    return separateBy(" ")
  }
  
  private func separateBy(_ separator: String) -> [String] {
    return self.components(separatedBy: CharacterSet(charactersIn: separator))
  }
  
  func trim() -> String {
    return self.trimmingCharacters(in: CharacterSet.whitespaces)
  }
}

infix operator <+
func <+ <T>(_ array: Array<T>, _ elem: T) -> Array<T> {
  return array.appending(elem)
}

extension Array where Element: Equatable {
  func distinct() -> Array {
    return self.reduce([Element](), {
      return $0.contains($1) ? $0 : $0.appending($1)
    })
  }
}

extension Collection {
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

extension Collection {
  func all(_ condition: (Element) -> Bool) -> Bool {
    return self.filter(condition).count == self.count
  }
}

extension Collection where Element == Int {
  func sum() -> Int {
    return self.reduce(0, {$0 + $1})
  }
}

extension Collection where Element == Float {
  func sum() -> Float {
    return self.reduce(0, {$0 + $1})
  }
}

extension Array {
  func take(_ number: Int) -> [Element] {
    let index = Swift.min(number, self.count)
    return Array(self.prefix(through: index - 1))
  }
  
  func tail() -> [Element] {
    if self.isEmpty {
      return []
    } else {
      return Array(self.suffix(self.count - 1))
    }
  }
  
  func drop(_ number: Int) -> Array {
    return Array(self.dropLast(number))
  }
}

extension Array where Element : BidirectionalCollection {
  func flatten() -> Element {
    return self.joined().compactMap(identity) as! Element
  }
}

struct Zip3Generator<A: IteratorProtocol, B: IteratorProtocol, C: IteratorProtocol>: IteratorProtocol {
  
  private var first: A
  private var second: B
  private var third: C
  
  private var index = 0
  
  init(_ first: A, _ second: B, _ third: C) {
    self.first = first
    self.second = second
    self.third = third
  }
  
  mutating func next() -> (A.Element, B.Element, C.Element)? {
    if let a = first.next(), let b = second.next(), let c = third.next() {
      return (a, b, c)
    }
    return nil
  }
}

func zip3<A: Sequence, B: Sequence, C: Sequence>(_ a: A,_  b: B,_  c: C) -> IteratorSequence<Zip3Generator<A.Iterator, B.Iterator, C.Iterator>> {
  return IteratorSequence(Zip3Generator(a.makeIterator(), b.makeIterator(), c.makeIterator()))
}

infix operator +
func +<A,B>(_ dict1: Dictionary<A, B>, _ dict2: Dictionary<A, B>) -> Dictionary<A, B> {
  return dict1.merging(dict2, uniquingKeysWith: {v1,v2 in v1 })
}



