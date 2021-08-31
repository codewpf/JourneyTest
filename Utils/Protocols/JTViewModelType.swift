//
//  JTViewModelType.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation

protocol JTViewModelType {
    associatedtype Input
    associatedtype Output
    func transform() -> Output
}
