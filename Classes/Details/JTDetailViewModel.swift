//
//  JTDetailViewModel.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx

class JTDetailViewModel: NSObject {
    
    /// comment detail vc data models
    var models = BehaviorRelay<[JTCommentModel]>(value: [])

    var input: JTDetailInput!
    var output: JTDetailOutput!

    
    let post: JTPostModel
    init(post: JTPostModel) {
        self.post = post
    }
    
}

extension JTDetailViewModel: JTViewModelType {

    typealias Input = JTDetailInput
    typealias Output = JTDetailOutput
    
    func transform() -> JTDetailOutput {
        guard let input = self.input else {
            fatalError("\(Self.self) didn't init input")
        }

        let sections = models.asObservable().map{ (models) -> [JTCommentListModel] in
            return [JTCommentListModel(items: models)]
        }.asDriver(onErrorJustReturn: [])

        
        let output = JTDetailOutput(sections: sections)
        output.requestCommond.subscribe(onNext: { [unowned self] isReloadData in
            
            JTNetworkManager.rx
                .request(.getComment(path: input.path, id: "\(self.post.pid)"))
                .retry(2)
                .asObservable()
                .mapArray(JTCommentModel.self)
                .subscribe { [weak self] (event) in

                    switch event {
                    case let .next(models):

                        self?.models.accept(models)
                        /// insert data into DB
                        _ = models.map { m in
                            m.insertComment().subscribe().disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        }

                    case let .error(err):
                        JTCommentModel.queryComment(with: self?.post.pid ?? 0)
                            .subscribe({ (event) in
                                switch event {
                                case .next(let models):
                                    if models.count > 0 {
                                        self?.models.accept(models)
                                        output.errorStatus.accept("Network error: \(err.localizedDescription)\n but fetch data from local data base successfully")
                                    } else {
                                        output.errorStatus.accept("Network error: \(err.localizedDescription)\nDatabase error: local does not have vlaues")
                                    }
                                case .error(let error):
                                    output.errorStatus.accept("Network error: \(err.localizedDescription)\nDatabase error: \(error.localizedDescription)")
                                    print("db err = " + error.localizedDescription)
                                default: break
                                }
                            }).disposed(by: self?.rx.disposeBag ?? DisposeBag())
                        print("network err = " + err.localizedDescription)
                    case .completed:
                        output.errorStatus.accept("")
                    }


                }.disposed(by: self.rx.disposeBag)
        
        }).disposed(by: self.rx.disposeBag)

        return output
        
    }
    
}



struct JTDetailInput {
    let path: JTNetworkPath
    init(path: JTNetworkPath) {
        self.path = path
    }
}

struct JTDetailOutput {
    
    let sections: Driver<[JTCommentListModel]>
    let requestCommond = PublishSubject<Bool>()
    let errorStatus = BehaviorRelay<String>(value: "")
    
    init(sections: Driver<[JTCommentListModel]>) {
        self.sections = sections
    }
}
