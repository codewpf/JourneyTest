//
//  JTDetailTests.swift
//  JourneyTestTests
//
//  Created by Alex on 1/09/21.
//

import XCTest
@testable import JourneyTest
import ObjectMapper

class JTDetailTests: XCTestCase {

    func testCommontModelMapsData() throws {
        
        let jsonDictionary: [String: Any] = ["postId": 6, "id": 29, "name": "eum distinctio amet dolor", "email": "Jennings_Pouros@erica.biz", "body": "tempora voluptatem est\nmagnam distinctio autem est dolorem\net ipsa molestiae odit rerum itaque corporis nihil nam\neaque rerum error"]
        let comment = Mapper<JTCommentModel>().map(JSON: jsonDictionary)

        XCTAssertEqual(comment?.pid, 6)
        XCTAssertEqual(comment?.cid, 29)
        XCTAssertEqual(comment?.name, "eum distinctio amet dolor")
        XCTAssertEqual(comment?.email, "Jennings_Pouros@erica.biz")
        XCTAssertEqual(comment?.body, "tempora voluptatem est\nmagnam distinctio autem est dolorem\net ipsa molestiae odit rerum itaque corporis nihil nam\neaque rerum error")
        
    }

}
