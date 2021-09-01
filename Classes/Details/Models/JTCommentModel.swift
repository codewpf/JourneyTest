//
//  JTCommentModel.swift
//  JourneyTest
//
//  Created by Alex on 1/09/21.
//

import Foundation
import ObjectMapper
import FMDB
import RxSwift

struct JTCommentModel: Mappable, JTModelResultSetable  {
    
    static let sql = "CREATE TABLE IF NOT EXISTS Comment( \n " +
        "id INTEGER PRIMARY KEY, \n " +
        "postid TEXT NOT NULL, \n " +
        "commentid TEXT NOT NULL, \n " +
        "name TEXT NOT NULL, \n " +
        "email TEXT NOT NULL, \n " +
        "body TEXT NOT NULL \n " +
    "); \n"

    var pid: Int = 0
    var cid: Int = 0
    var name: String  = ""
    var email: String  = ""
    var body: String = ""

    
    init?(map: Map) {
    }
    
    init(res: FMResultSet) {
        self.pid = Int(res.int(forColumn: "postid"))
        self.cid = Int(res.int(forColumn: "commentid"))
        self.name = res.string(forColumn: "name") ?? "Name"
        self.email = res.string(forColumn: "email") ?? "Title"
        self.body = res.string(forColumn: "body") ?? "Body"
    }
    
    mutating func mapping(map: Map) {
        pid      <- map["postId"]
        cid      <- map["id"]
        name     <- map["name"]
        email    <- map["email"]
        body     <- map["body"]
    }
    

}


extension JTCommentModel: JTDataBasable {
    func insertComment() -> Completable {
        let sql = "INSERT OR IGNORE INTO Comment(postid, commentid, name, email, body) VALUES(?,?,?,?,?)"
        let arguments = ["\(self.pid)", "\(self.cid)", self.name, self.email, self.body]
        return self.insertTable(with: sql, arguments: arguments)
    }
    
    static func queryComment(with pid: Int) -> Observable<[JTCommentModel]> {
        let sql = "SELECT * FROM Comment Where postid = \(pid)"
        return self.queryTable(with: sql, model: JTCommentModel.self)
    }
    
}
