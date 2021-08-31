//
//  JTError.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation

enum JTError: Error {
    var string: String {
        get {
            switch self {
            case .nodata: return "No data"
            case .strErr(let str): return str
            default: return "Unknown error"
            }
        }
    }
    
    case nodata
    case strErr(String)
    case unknown
    
    
}
