//
//  JTDetailVC.swift
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
import Then

class JTDetailVC: UIViewController, JTHudViewable, JTLayoutable {
    
    /// view controller viewModel
    fileprivate let viewModel: JTDetailViewModel
    
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain).then { (tv) in
        tv.backgroundColor = .clear
    }
    
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<JTCommentListModel>(
        configureCell: { ds, tv, idx, item in
        let cell = tv.dequeueReusableCell(withIdentifier: JTDetailCommentCell.identifier, for: idx) as! JTDetailCommentCell
        cell.model = item
        cell.selectionStyle = .none
        return cell
    }, titleForHeaderInSection: { _, _ in
        return "Comment"
    })
    
    init(post: JTPostModel) {
        self.viewModel = JTDetailViewModel(post: post)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.setupBinding()
        self.viewModel.output.requestCommond.onNext(true)
        self.showNullHUD()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        guard let header = self.tableView.tableHeaderView as? JTDetailHedaerView else {
            return
        }
        header.frame = header.calculateFrame()
        header.setupSubviews()
    }
    
}

extension JTDetailVC {
    func initUI() {
        self.navigationItem.title = "Detail"
        self.view.backgroundColor = .systemBackground
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(JTDetailCommentCell.self, forCellReuseIdentifier: JTDetailCommentCell.identifier)
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.view.addSubview(self.tableView)
        
        let header = JTDetailHedaerView(post: self.viewModel.post)
        self.tableView.tableHeaderView = header
    }
    
    func setupBinding() {
        self.viewModel.input = JTDetailInput(path: .getComment)
        self.viewModel.output = self.viewModel.transform()
        self.viewModel.output.sections
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.rx.disposeBag)
        
        self.viewModel.output.errorStatus
            .subscribe(onNext: { [weak self] errStr in
                guard errStr.length > 0 else {
                    self?.dismissHUD()
                    return
                }
                self?.showHUDError(errStr)
            }).disposed(by: self.rx.disposeBag)
    }
    
}

extension JTDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.viewModel.models.value[indexPath.row]
        return JTDetailCommentCell.height(model)
    }
    
}
