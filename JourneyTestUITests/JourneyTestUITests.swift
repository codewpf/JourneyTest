//
//  JourneyTestUITests.swift
//  JourneyTestUITests
//
//  Created by Alex on 31/08/21.
//

import XCTest

class JourneyTestUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPostDetail() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        sleep(2)

        /// click the first cell
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element(boundBy: 0).tap()
        
        sleep(1)

        /// check the first comment of the post
        let detailcell = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let name = detailcell.staticTexts[JTUITestKeys.keys.detailCellNameLabel]
        XCTAssert(name.label.contains("labore"))

    }
    
    func testDetailSearching() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        sleep(2)

        /// click the first cell
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element(boundBy: 0).tap()
        
        sleep(1)

        /// check the first comment of the post
        let detailcell = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        
        /// swipe down and input search text
        detailcell.swipeDown()

        /// tap the detail search bar
        let detailNavigationBar = app.navigationBars["Detail"]
        let detailSearchSearchField = detailNavigationBar.searchFields["Please input to search detail"]
        detailSearchSearchField.tap()
        
        /// input search text
        detailSearchSearchField.typeText("natus")

        let detailcell2 = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let name2 = detailcell2.staticTexts[JTUITestKeys.keys.detailCellNameLabel]
        XCTAssert(name2.label.contains("vero"))

    }
    
    func testPostSearching() throws {
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        sleep(2)
        
        /// swipe down and input search text
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element.swipeDown()

        /// tap the search bar
        let postsNavigationBar = app.navigationBars["Posts"]
        let searchSearchField = postsNavigationBar.searchFields["Please input to search post"]
        searchSearchField.tap()
        
        /// input search text
        searchSearchField.typeText("eum et")
        
        /// click the first cell after searching
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element(boundBy: 0).tap()

        sleep(1)
        
        /// check the first comment of the post after searching
        let detailcell = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let body = detailcell.staticTexts[JTUITestKeys.keys.detailCellBodyLabel]
        XCTAssert(body.label.contains("aliquid"))

    }
    
    

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        let tablesQuery = app.tables
        
        sleep(2)

        /// click the first cell
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element(boundBy: 0).tap()
        
        sleep(1)

        /// check the first comment of the post
        let detailcell = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let name1 = detailcell.staticTexts[JTUITestKeys.keys.detailCellNameLabel]
        XCTAssert(name1.label.contains("labore"))
        
        
        /// swipe down and input search text
        detailcell.swipeDown()

        /// tap the detail search bar
        let detailNavigationBar = app.navigationBars["Detail"]
        let detailSearchSearchField = detailNavigationBar.searchFields["Please input to search detail"]
        detailSearchSearchField.tap()
        
        /// input search text
        detailSearchSearchField.typeText("natus")

        let detailcell2 = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let name2 = detailcell2.staticTexts[JTUITestKeys.keys.detailCellNameLabel]
        XCTAssert(name2.label.contains("vero"))

        /// cancel searching
        detailNavigationBar.buttons["Cancel"].tap()
        
        /// return to post list vc
        let postsButton = app.navigationBars["Detail"].buttons["Posts"]
        postsButton.tap()
        
        /// swipe down and input search text
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element.swipeDown()

        /// tap the search bar
        let postsNavigationBar = app.navigationBars["Posts"]
        let searchSearchField = postsNavigationBar.searchFields["Please input to search post"]
        searchSearchField.tap()
        
        /// input search text
        searchSearchField.typeText("eum et")
        
        /// click the first cell after searching
        tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.postNormalFirstCell).element(boundBy: 0).tap()

        sleep(1)
        
        /// check the first comment of the post after searching
        let detailcell3 = tablesQuery.cells.containing(.cell, identifier: JTUITestKeys.keys.detailNormalFirstCell).element(boundBy: 0)
        let body = detailcell3.staticTexts[JTUITestKeys.keys.detailCellBodyLabel]
        XCTAssert(body.label.contains("aliquid"))
        
        /// return to post list vc
        postsButton.tap()
        
        /// cancel searching
        postsNavigationBar.buttons["Cancel"].tap()
                
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
