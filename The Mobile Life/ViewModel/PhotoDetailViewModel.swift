//
//  PhotoDetailViewModel.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import PKHUD

class PhotoDetailViewModel {
    
    enum PhotoDetailViewType {
        case normal(photoImg: UIImage)
        case error(message: String)
        case empty
        
        init?() {
            self = .empty
        }
    }

    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    var photoImg = Bindable(PhotoDetailViewType())
    let appServerClient: AppServerClient

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }
    
    // MARK: - API methods
    
    func getBlurPhoto(_ amount: Int, download_url: String) {
        self.showLoadingHud.value = true
        appServerClient.getBlurPhoto(amount, download_url: download_url, completion: { [weak self] result in
            switch result {
            case .success(let img):
                self?.photoImg.value = .normal(photoImg: img)
            case .failure(let error):
                self?.photoImg.value = .error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")
            }
            self?.showLoadingHud.value = false
        })
    }
    
    func getGrayscalePhoto(download_url: String) {
        self.showLoadingHud.value = true
        appServerClient.getGrayscalePhoto(download_url: download_url, completion: { [weak self] result in
            switch result {
            case .success(let img):
                self?.photoImg.value = .normal(photoImg: img)
            case .failure(let error):
                self?.photoImg.value = .error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")
            }
            self?.showLoadingHud.value = false
        })
    }
}

// MARK: - AppServerClient.GetBlurPhotoFailureReason
fileprivate extension AppServerClient.GetBlurPhotoFailureReason {
    
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "No access permission."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}

fileprivate extension AppServerClient.GetGrayscalePhotoFailureReason {
    
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "No access permission."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}
