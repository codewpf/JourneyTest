//
//  JTDataBaseTests.swift
//  JourneyTestTests
//
//  Created by Alex on 3/09/21.
//

import XCTest
@testable import JourneyTest
import FMDB
import RxSwift

class JDdbTest: JTDataBasable {
}

struct JTTestModel: JTModelResultSetable {
    let tid: String
    init(res: FMResultSet) {
        self.tid = res.string(forColumn: "testid") ?? ""
    }
    
}

class JTDataBaseTests: XCTestCase {

    let dbTest = JDdbTest()
    var manager = JTDataBaseManager.manager
    
    let tableName: String = "test"
    let tableKey: String = "testid"
    let testId: String = "1001"
        
    func testCreateTable() throws {
        XCTAssertNotNil(manager.dbQueue)
        
        let disposeBag = DisposeBag()
        
        let sql = "CREATE TABLE IF NOT EXISTS \(tableName)( \n " +
            "id INTEGER PRIMARY KEY, \n " +
            "\(tableKey) TEXT NOT NULL \n " +
        "); \n"
        
        let expectation = self.expectation(description: "create table")
        JDdbTest.createTable(with: sql).subscribe {
            expectation.fulfill()
        } onError: { (error) in
            expectation.fulfill()
            XCTFail(error.localizedDescription)
        }.disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 5) { (error) in
            guard let error = error else {
                return
            }
            XCTFail(error.localizedDescription)
        }
        
    }
    
    func testInsertToTable() throws {
        XCTAssertNotNil(manager.dbQueue)
        
        let disposeBag = DisposeBag()
        
        let sql = "INSERT OR IGNORE INTO \(tableName)(\(tableKey) VALUES(?)"
        let arguments = [testId]
        
        let expectation = self.expectation(description: "insert table")
        dbTest.insertTable(with: sql, arguments: arguments).subscribe {
            expectation.fulfill()
        } onError: { (error) in
            expectation.fulfill()
            XCTFail(error.localizedDescription)
        }.disposed(by: disposeBag)

        self.waitForExpectations(timeout: 5) { (error) in
            guard let error = error else {
                return
            }
            XCTFail(error.localizedDescription)
        }
    }
    
    func testQueryFromTable() throws {
        XCTAssertNotNil(manager.dbQueue)
        
        let disposeBag = DisposeBag()
        
        let sql = "SELECT * FROM \(tableName) Where \(tableKey) = \(testId)"
        
        var result: JTTestModel?
        
        let expectation = self.expectation(description: "query table")
        JDdbTest.queryTable(with: sql, model: JTTestModel.self).subscribe { models in
            result = models.first
            expectation.fulfill()
        } onError: { (error) in
            expectation.fulfill()
            XCTFail(error.localizedDescription)
        }.disposed(by: disposeBag)

        self.waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            } else {
                XCTAssertNotNil(result)
                XCTAssertEqual(result!.tid, self.testId)
            }
        }

    }


    
}


