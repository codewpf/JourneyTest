//
//  JTReuseIdentifier.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation

protocol JTReuseIdentifier {}
extension JTReuseIdentifier {
    static var identifier: String {
        get {  return "\(Self.self)_identifier" }
    }
}
