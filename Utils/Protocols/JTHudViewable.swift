//
//  JTHudViewable.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import SVProgressHUD
import UIKit

protocol JTHudViewable {
    
}

extension JTHudViewable {
    func showNullHUD() {
        SVProgressHUD.show()
    }
    
    func showHUD(_ status: String = "Please hold on") {
        SVProgressHUD.show(withStatus: status)
    }
    
    func dismissHUD(_ ti: TimeInterval = 0.0, _ completion: @escaping SVProgressHUDDismissCompletion = {}) {
        SVProgressHUD.dismiss(withDelay: ti, completion: completion)
    }
    
    func showHUDSuccess(_ status: String, _ completion: @escaping SVProgressHUDDismissCompletion = {}) {
        SVProgressHUD.showSuccess(withStatus: status)
        let duration: TimeInterval = self.hudDurationTime(status)
        self.dismissHUD(duration) {
            completion()
        }
    }
    
    func showHUDError(_ status: String, _ completion: @escaping SVProgressHUDDismissCompletion = {}) {
        SVProgressHUD.showError(withStatus: status)
        let duration: TimeInterval = self.hudDurationTime(status)
        self.dismissHUD(duration) {
            completion()
        }
    }
    
    func showHUDInfo(_ status: String, _ completion: @escaping SVProgressHUDDismissCompletion = {}) {
        SVProgressHUD.showInfo(withStatus: status)
        let duration: TimeInterval = self.hudDurationTime(status)
        self.dismissHUD(duration) {
            completion()
        }
        
    }
    
    func showHUDProgress(_ progress: Float, _ status: String? = nil) {
        SVProgressHUD.showProgress(progress, status: status)
    }
    
    
    fileprivate func hudDurationTime(_ str: String) -> TimeInterval {
        let time = max( SVProgressHUD.displayDuration(for: str), 1 )
        return time
    }


}
