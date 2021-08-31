//
//  JTRefreshStatus.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation

enum JTRefreshStatus {
    case none
    case beginHeaderRefresh
    case endHeaderRefresh
    
    var refresh: String {
        get {
            switch self {
            case .none: return "None"
            case .beginHeaderRefresh: return "Begin Header Refresh"
            case .endHeaderRefresh: return "End Header Refresh"
            }
        }
    }
    
    
}
