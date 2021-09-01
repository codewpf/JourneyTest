//
//  JTPostModel.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import Foundation
import ObjectMapper
import FMDB
import RxSwift

struct JTPostModel: Mappable, JTModelResultSetable  {
    
    static let sql = "CREATE TABLE IF NOT EXISTS Post( \n " +
        "id INTEGER PRIMARY KEY, \n " +
        "userid TEXT NOT NULL, \n " +
        "postid TEXT NOT NULL, \n " +
        "title TEXT NOT NULL, \n " +
        "body TEXT NOT NULL, \n " +
    "); \n"

    var uid: String = ""
    var pid: String  = ""
    var title: String  = ""
    var body: String = ""

    
    init?(map: Map) {
    }
    
    init(res: FMResultSet) {
        self.uid = res.string(forColumn: "userid") ?? "User ID"
        self.pid = res.string(forColumn: "postid") ?? "Post ID"
        self.title = res.string(forColumn: "title") ?? "Title"
        self.body = res.string(forColumn: "body") ?? "Body"
    }
    
    mutating func mapping(map: Map) {
        uid      <- map["userId"]
        pid          <- map["id"]
        title       <- map["title"]
        body        <- map["body"]
    }
    

}


extension JTPostModel: JTDataBasable {
    func insertPost() -> Completable {
        let sql = "INSERT OR IGNORE INTO Person(userid, postid, title, body) VALUES(?,?,?,?)"
        let arguments = [self.uid, self.pid, self.title, self.body]
        return self.insertTable(with: sql, arguments: arguments)
    }
    
    static func queryPost(with pageIdx: Int) -> Observable<[JTPostModel]> {
        let sql = "SELECT * FROM Post Where userid = \(pageIdx)"
        return self.queryTable(with: sql, model: JTPostModel.self)
    }
    
}
