//
//  PhotoCollectionViewViewModel.swift
//  The Mobile LifeTests
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import XCTest
@testable import The_Mobile_Life

class PhotoCollectionViewViewModelTests: XCTestCase {

    func testNormalPhotoCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getPhotosResult = .success(payload: [Photo.with()])

        let viewModel = PhotoCollectionViewViewModel(appServerClient: appServerClient)
        viewModel.getPhotos()

        guard case .some(.normal(_)) = viewModel.photoCells.value.first else {
            XCTFail()
            return
        }
    }
    
    func testEmptyPhotoCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getPhotosResult = .success(payload: [])

        let viewModel = PhotoCollectionViewViewModel(appServerClient: appServerClient)
        viewModel.getPhotos()

        guard case .some(.empty) = viewModel.photoCells.value.first else {
            XCTFail()
            return
        }
    }
    
    func testErrorPhotoCells() {
        let appServerClient = MockAppServerClient()
        appServerClient.getPhotosResult = .failure(AppServerClient.GetPhotosFailureReason.notFound)

        let viewModel = PhotoCollectionViewViewModel(appServerClient: appServerClient)
        viewModel.getPhotos()

        guard case .some(.error(_)) = viewModel.photoCells.value.first else {
            XCTFail()
            return
        }
    }

}

private final class MockAppServerClient: AppServerClient {
    
    var getPhotosResult: AppServerClient.GetPhotosResult?
    
    override func getPhotos(_ page: Int = 1, completion: @escaping AppServerClient.GetPhotosCompletion) {
        completion(getPhotosResult!)
    }
}
