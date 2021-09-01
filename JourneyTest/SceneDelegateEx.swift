//
//  SceneDelegateEx.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import UIKit
import SVProgressHUD
import WPFoundation

extension SceneDelegate {
    
    var root: UIViewController {
        get {
            let postList = JTPostListVC()
            let nav = UINavigationController(rootViewController: postList)
            return nav
        }
    }
    
    func initHUDProgress() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setContainerView(self.window)
    }
    
    func initDB() {
        JTPostModel.createTable(with: JTPostModel.sql)
            .subscribe { (event) in
                switch event {
                case let .error(err):
                    WPFLog("create post table success = " + err.localizedDescription)
                default:
                    WPFLog("create post table success")
                }
        }.disposed(by: rx.disposeBag)
        
        
        JTCommentModel.createTable(with: JTCommentModel.sql)
            .subscribe { (event) in
                switch event {
                case let .error(err):
                    WPFLog("create comment table success = " + err.localizedDescription)
                default:
                    WPFLog("create comment table success")
                }
        }.disposed(by: rx.disposeBag)
        
        
        WPFLog(JTDataBaseManager.manager.dbURL)

    }

    
}
