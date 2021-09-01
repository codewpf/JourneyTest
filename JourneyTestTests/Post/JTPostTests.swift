//
//  JTPostTests.swift
//  JourneyTestTests
//
//  Created by Alex on 1/09/21.
//

import XCTest
@testable import JourneyTest
import ObjectMapper

class JTPostTests: XCTestCase {

    func testPostModelMapsData() throws {
        
        let jsonDictionary: [String: Any] = ["userId": 3, "id": 22, "title": "asperiores ea ipsam voluptatibus modi minima quia sint", "body": "repellat aliquid praesentium dolorem quo\nsed totam minus non itaque\nnihil labore molestiae sunt dolor eveniet hic recusandae veniam\ntempora et tenetur expedita sunt"]
        let post = Mapper<JTPostModel>().map(JSON: jsonDictionary)

        XCTAssertEqual(post?.uid, 3)
        XCTAssertEqual(post?.pid, 22)
        XCTAssertEqual(post?.title, "asperiores ea ipsam voluptatibus modi minima quia sint")
        XCTAssertEqual(post?.body, "repellat aliquid praesentium dolorem quo\nsed totam minus non itaque\nnihil labore molestiae sunt dolor eveniet hic recusandae veniam\ntempora et tenetur expedita sunt")
        
    }
    
    
    
}
