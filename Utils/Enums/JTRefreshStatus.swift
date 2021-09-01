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
    case beginFooterRefresh
    case endFooterRefresh
    case noMoreData
    
    var refresh: String {
        get {
            switch self {
            case .none:                 return "None"
            case .beginHeaderRefresh:   return "Begin Header Refresh"
            case .endHeaderRefresh:     return "End Header Refresh"
            case .beginFooterRefresh:   return "Begin Footer Refresh"
            case .endFooterRefresh:     return "End Footer Refresh"
            case .noMoreData:           return "No More Data"
            }
        }
    }
    
    
}
