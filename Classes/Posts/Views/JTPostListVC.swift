//
//  JTPostListVC.swift
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

class JTPostListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
    }
    
}

extension JTPostListVC {
    func initUI() {
        self.navigationItem.title = "Posts"
    }
}
