//
//  JTPostViewModel.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class JTPostListViewModel: NSObject {
    
    /// post list vc table view page index
    var pageIdx: Int = 1

    /// post list vc data models
    var models = BehaviorRelay<[JTPostModel]>(value: [])

    var input: JTPostInput!
    var output: JTPostOutput!

}

extension JTPostListViewModel: JTViewModelType {
    typealias Input = JTPostInput
    typealias Output = JTPostOutput
    
    func transform() -> JTPostOutput {
        guard let input = self.input else {
            fatalError("\(Self.self) didn't init input")
        }
        
        let sections = models.asObservable().map{ (models) -> [JTPostListModel] in
            return [JTPostListModel(items: models)]
        }.asDriver(onErrorJustReturn: [])

        let output = JTPostOutput(sections: sections)
        output.requestCommond.subscribe(onNext: { [unowned self] isReloadData in
            self.pageIdx = isReloadData ? 1 : self.pageIdx+1

            JTNetworkManager.rx
                .request(.getPost(path: input.path, pageIdx: self.pageIdx))
                .retry(2)
                .asObservable()
                .mapArray(JTPostModel.self)
                .subscribe { [weak self] (event) in
                    
                    switch event {
                    case let .next(models):
                        
                        self?.models.accept(isReloadData ? models : (self?.models.value ?? []) + models)
                        /// insert data into DB
                        _ = models.map { m in
                            m.insertPost().subscribe().disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        }
                        
                    case let .error(err):
                        
                        JTPostModel.queryPost(with: self?.pageIdx ?? 1)
                            .subscribe({ (event) in
                                switch event {
                                case .next(let models):
                                    self?.models.accept(isReloadData ? models : (self?.models.value ?? []) + models)
                                    output.errorStatus.accept("Network error: \(err.localizedDescription)\nFetch data from local data base")
                                case .error(let error):
                                    output.errorStatus.accept("Network error: \(err.localizedDescription)\nDatabase error: \(error.localizedDescription)")
                                    print("db err = " + error.localizedDescription)
                                default: break
                                }
                                self?.updateRefresStatus(isReloadData)
                            }).disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        print("network err = " + err.localizedDescription)
                    case .completed:
                        self?.updateRefresStatus(isReloadData)
                    }
                    
                    
                }.disposed(by: self.rx.disposeBag)
        
        }).disposed(by: self.rx.disposeBag)

        return output
    }
    
    fileprivate func updateRefresStatus(_ isReloadData: Bool) {
        output.refreshStatus.accept(isReloadData ? .endHeaderRefresh : self.pageIdx >= 3 ? .noMoreData : .endFooterRefresh)
    }
    
    func refreshModels() {
        self.models.accept(self.models.value)
    }

}



struct JTPostInput {
    let path: JTNetworkPath
    init(path: JTNetworkPath) {
        self.path = path
    }
}

struct JTPostOutput {
    
    let sections: Driver<[JTPostListModel]>
    let requestCommond = PublishSubject<Bool>()
    let refreshStatus = BehaviorRelay<JTRefreshStatus>(value: .none)
    let errorStatus = BehaviorRelay<String>(value: "")
    
    init(sections: Driver<[JTPostListModel]>) {
        self.sections = sections
    }
}

