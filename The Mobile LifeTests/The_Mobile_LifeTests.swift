//
//  The Mobile Life_AppTests.swift
//  The Mobile LifeTests
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import XCTest
@testable import The_Mobile_Life

class The_Mobile_Life_AppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

// MARK: - Mock Photo
extension Photo {
    
    static func with(id: String = "1",
                     author: String = "Alejandro Escamilla",
                     width: Int = 5616,
                     height: Int = 3744,
                     url: String = "https://unsplash.com/photos/yC-Yzbqy7PY",
                     download_url: String = "https://picsum.photos/id/0/5616/3744" ) -> Photo
    {
        return Photo(id: id,
                     author: author,
                     width: width,
                     height: height,
                     url: url,
                     download_url: download_url)
    }
}
