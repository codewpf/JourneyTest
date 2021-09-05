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
import MJRefresh
import Then

class JTPostListVC: UIViewController, JTHudViewable, JTSearchableVC, JTSearchFilterable {

    /// view controller viewModel
    fileprivate var viewModel: JTPostListViewModel = JTPostListViewModel()
    
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain).then { (tv) in
        tv.backgroundColor = .clear
    }
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<JTPostListModel>(configureCell: { ds, tv, idx, item in
        let cell = tv.dequeueReusableCell(withIdentifier: JTPostListCell.identifier, for: idx) as! JTPostListCell
        cell.model = item
        if idx.section == 0 && idx.row == 0 {
            cell.accessibilityIdentifier = JTUITestKeys.keys.postNormalFirstCell
        }
        return cell
    })
    
    /// search view controller
    var searchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initUI()
        self.setupBinding()
        self.setupRefresh()
        
        /// begin getting data
        self.tableView.mj_header?.beginRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension JTPostListVC {
    func initUI() {
        self.navigationItem.title = "Posts"
        self.view.backgroundColor = .systemBackground
        
        self.tableView.tableFooterView = UIView()
        self.tableView.register(JTPostListCell.self, forCellReuseIdentifier: JTPostListCell.identifier)
        self.tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.view.addSubview(self.tableView)
        
    }
    
    func addSearchController() {
        guard self.navigationItem.searchController == nil else {
            return
        }
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.delegate = self
        self.searchController?.searchBar.placeholder = "Please input to search post"
        self.navigationItem.searchController = self.searchController
        
        self.navigationController?.navigationBar.backgroundColor = .systemBackground

    }
    
    func setupBinding() {
        
        self.viewModel.input = JTPostInput(path: .getPost)
        self.viewModel.output = self.viewModel.transform()
        self.viewModel.output.sections
            .map{JTFilterBridge<JTPostListModel>(sections: $0, type: JTPostListModel(items: $0.first?.items ?? []))}
            .flatMapLatest(filterResultable)
            .drive(self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.rx.disposeBag)
        
        self.viewModel.output.refreshStatus.asObservable()
            .subscribe(onNext: { [weak self] status in
                switch(status) {
                case .none: break
                case .beginHeaderRefresh:
                    self?.tableView.mj_header?.beginRefreshing()
                case .endHeaderRefresh:
                    self?.addSearchController()
                    self?.tableView.mj_header?.endRefreshing()
                    self?.tableView.mj_footer?.endRefreshing()
                case .beginFooterRefresh:
                    self?.tableView.mj_footer?.beginRefreshing()
                case .endFooterRefresh:
                    self?.tableView.mj_footer?.endRefreshing()
                case .noMoreData:
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            }).disposed(by: self.rx.disposeBag)
        
        self.viewModel.output.errorStatus
            .subscribe(onNext: { [weak self] (errStr) in
                guard errStr.length > 0 else { return }
                self?.showHUDError(errStr)
            }).disposed(by: self.rx.disposeBag)
        
        self.searchController?.searchBar.rx
            .cancelButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.searchController?.searchBar.text = ""
                self?.viewModel.refreshModels()
            }).disposed(by: self.rx.disposeBag)
        
    }
    
    func setupRefresh(isNeed: Bool = true) {
        if isNeed == false {
            self.tableView.mj_header = nil
            self.tableView.mj_footer = nil
        } else {
            let header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
                self?.viewModel.output.requestCommond.onNext(true)
            })
            header.stateLabel?.isHidden = true
            header.lastUpdatedTimeLabel?.isHidden = true
            self.tableView.mj_header = header
            self.tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { [weak self] in
                self?.viewModel.output.requestCommond.onNext(false)
            })
        }
        
    }
    
    
}

//MARK: - View Controller delegates
extension JTPostListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = self.dataSource.sectionModels[indexPath.section].items[indexPath.row]
        let detail = JTDetailVC(post: post)
        self.navigationController?.pushViewController(detail, animated: true)
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JTPostListCell.height
    }

}


extension JTPostListVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.setupRefresh(isNeed: false)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.setupRefresh()
    }
    

}
