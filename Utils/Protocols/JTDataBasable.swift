//
//  JTDataBasable.swift
//  JourneyTest
//
//  Created by Alex on 31/08/21.
//

import Foundation
import RxSwift
import RxCocoa
import FMDB

protocol JTDataBasable {
}
extension JTDataBasable {
    
    static func createTable(with sql: String) -> Completable {
        return Completable.create { (completable) -> Disposable in
            JTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if db.executeUpdate(sql, withArgumentsIn: []){
                    completable(.completed)
                }else{
                    completable(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }
    }
    
    func insertTable(with sql: String, arguments: [String]) ->Completable {
        return Completable.create { (completable) -> Disposable in
            JTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if db.executeUpdate(sql, withArgumentsIn: arguments){
                    completable(.completed)
                }else{
                    completable(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }
    }
    
    static func queryTable<Model: JTModelResultSetable>(with sql: String, model: Model.Type) -> Observable<[Model]> {
        return Observable.create { (observer) -> Disposable in
            JTDataBaseManager.manager.dbQueue?.inDatabase({ (db) in
                if let res = db.executeQuery(sql, withArgumentsIn: []){
                    var results: [Model] = []
                    while res.next() {
                        results.append(Model(res: res))
                    }
                    res.close()
                    observer.on(.next(results))
                    observer.on(.completed)
                }else{
                    observer.on(.error(db.lastError()))
                }
            })
            return Disposables.create()
        }
    }
    
}

