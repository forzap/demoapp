//
//  PhotoCollectionViewViewModel.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

class PhotoCollectionViewViewModel {

    enum PhotoCollectionViewCellType {
        case normal(cellViewModel: PhotoCellViewModel)
        case error(message: String)
        case empty
    }

    var onShowError: ((_ alert: SingleButtonAlert) -> Void)?
    let showLoadingHud: Bindable = Bindable(false)

    let photoCells = Bindable([PhotoCollectionViewCellType]())
    let appServerClient: AppServerClient

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }

    // MARK: - API methods
    func getPhotos(_ page: Int = 1) {
        showLoadingHud.value = true
        appServerClient.getPhotos(page, completion: { [weak self] result in
            self?.showLoadingHud.value = false
            switch result {
            case .success(let photos):
                guard photos.count > 0 else {
                    self?.photoCells.value = [.empty]
                    return
                }
                if page == 1 {
                    self?.photoCells.value = photos.compactMap { .normal(cellViewModel: $0 as PhotoCellViewModel)}
                } else {
                    self?.photoCells.value.append(contentsOf: photos.compactMap { .normal(cellViewModel: $0 as PhotoCellViewModel)})
                }
            case .failure(let error):
                self?.photoCells.value = [.error(message: error?.getErrorMessage() ?? "Loading failed, check network connection")]
            }
        })
    }
}

// MARK: - AppServerClient.GetPhotosFailureReason
fileprivate extension AppServerClient.GetPhotosFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "No access permission."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}
