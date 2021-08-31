//
//  JTPostVC.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx
import SnapKit
import Kingfisher
import MJRefresh
import Then

class JTPostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }
    
}

extension JTPostVC {
    func initUI() {
        self.navigationItem.title = "Posts"
    }
}
