//
//  AppDelegateEx.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import Foundation
import SVProgressHUD

extension AppDelegate {
    
    func initHUDProgress() {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
    }
    
}
