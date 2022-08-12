//
//  PhotoTests.swift
//  The Mobile LifeTests
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import XCTest
@testable import The_Mobile_Life

class PhotoTest: XCTestCase {
    
    func testSuccessfulInit() {
        let testSuccessfulJSON: JSON = ["id": "1",
                                    "author": "Alejandro Escamilla",
                                    "width": 5616,
                                    "height": 3744,
                                    "url": "https://unsplash.com/photos/yC-Yzbqy7PY", 
                                    "download_url": "https://picsum.photos/id/0/5616/3744"]

        XCTAssertNotNil(Photo(json: testSuccessfulJSON))
    }

}

private extension Photo {
    
    init?(json: JSON) {
        guard let id = json["id"] as? String,
            let author = json["author"] as? String,
            let width = json["width"] as? Int,
            let height = json["height"] as? Int,
            let url = json["url"] as? String,
            let download_url = json["download_url"] as? String else {
                return nil
        }
        self.init(id: id, author: author, width: width, height: height, url: url, download_url: download_url)
    }
}
