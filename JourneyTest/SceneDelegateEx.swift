//
//  SceneDelegateEx.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import UIKit

extension SceneDelegate {
    
    var root: UIViewController {
        get {
            let post = JTPostListVC()
            let nav = UINavigationController(rootViewController: post)
            return nav
        }
    }
    
}
