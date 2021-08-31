//
//  SceneDelegateEx.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import UIKit

extension SceneDelegate {
    
    func root() -> UIViewController {
        
        let post = JTPostVC()
        let nav = UINavigationController(rootViewController: post)
        return nav
        
    }
    
}
