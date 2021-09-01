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
    
    fileprivate var header: JTDetailHedaerView?
    fileprivate let tableView: UITableView = UITableView(frame: CGRect.zero, style: .plain).then { (tv) in
        tv.backgroundColor = .clear
    }
    
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<JTCommentListModel>(
        configureCell: { ds, tv, idx, item in
        let cell = tv.dequeueReusableCell(withIdentifier: JTDetailCommentCell.identifier, for: idx) as! JTDetailCommentCell
        cell.model = item
        cell.selectionStyle = .none
        if idx.section == 0 && idx.row == 0 {
            cell.accessibilityIdentifier = JTUITestKeys.keys.detailNormalFirstCell
        }
        return cell
    }, titleForHeaderInSection: { _, _ in
        return "Comment"
    })
    
    /// search view controller
    fileprivate var searchController: UISearchController? = nil
    
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
        self.header = header
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.delegate = self
        self.searchController?.searchBar.placeholder = "Please input to search comment"
        self.navigationItem.searchController = self.searchController
        
        self.navigationController?.navigationBar.backgroundColor = .systemBackground

    }
    
    func setupBinding() {
        self.viewModel.input = JTDetailInput(path: .getComment)
        self.viewModel.output = self.viewModel.transform()
        self.viewModel.output.sections
            .flatMapLatest(filterResult)
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
        
        self.searchController?.searchBar.rx
            .cancelButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (_) in
                self?.searchController?.searchBar.text = ""
                self?.viewModel.refreshModels()
            }).disposed(by: self.rx.disposeBag)

    }
    
    func setupHeader(isNeed: Bool = true) {
        guard let header = self.header else {
            return
        }
        if isNeed == false {
            self.tableView.tableHeaderView = nil
        } else {
            self.tableView.tableHeaderView = header
        }
    }
    
    func filterResult(data: [JTCommentListModel]) -> Driver<[JTCommentListModel]> {
        guard let searchBar = self.searchController?.searchBar else {
            return Driver.just(data)
        }
        return searchBar.rx.text.orEmpty
            .flatMap { query -> Driver<[JTCommentListModel]> in
                if query.isEmpty {
                    return Driver.just(data)
                } else {
                    var newData: [JTCommentListModel] = []
                    for section in data {
                        var sectionItems: [JTCommentModel] = []
                        for item in section.items {
                            if item.allInformation().contains(query.lowercased()) {
                                sectionItems.append(item)
                            }
                        }
                        newData.append(JTCommentListModel(items: sectionItems))
                    }
                    return Driver.just(newData)
                }
            }.asDriver(onErrorJustReturn: [])
    }


}

extension JTDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.viewModel.models.value[indexPath.row]
        return JTDetailCommentCell.height(model)
    }
    
}

extension JTDetailVC: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        self.setupHeader(isNeed: false)
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        self.setupHeader()
    }
}
