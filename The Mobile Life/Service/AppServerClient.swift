//
//  AppServerClient.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import Alamofire

class AppServerClient {
    let sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        
        configuration.timeoutIntervalForRequest = 30
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })
        
        return Session(
          configuration: configuration,
          cachedResponseHandler: responseCacher)
    }()

    // MARK: - GetPhotos
    enum GetPhotosFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    typealias GetPhotosResult = Result<[Photo], GetPhotosFailureReason>
    typealias GetPhotosCompletion = (_ result: GetPhotosResult) -> Void

    func getPhotos(_ page: Int = 1, completion: @escaping GetPhotosCompletion) {
        let url = "https://picsum.photos/v2/list?page=\(page)"
        sessionManager.request(url)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    do {
                        guard let data = response.data else {
                            completion(.failure(nil))
                            return
                        }

                        let photos = try JSONDecoder().decode([Photo].self, from: data)
                        completion(.success(payload: photos))
                    } catch {
                        completion(.failure(nil))
                    }
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetPhotosFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK: - GetBlurPhoto
    enum GetBlurPhotoFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    typealias GetBlurPhotoResult = Result<UIImage, GetBlurPhotoFailureReason>
    typealias GetBlurPhotoCompletion = (_ result: GetBlurPhotoResult) -> Void
    
    func getBlurPhoto(_ amount: Int, download_url: String, completion: @escaping GetBlurPhotoCompletion) {
        let url = "\(download_url)?blur=\(amount)"
        sessionManager.request(url)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(nil))
                        return
                    }

                    let img = UIImage(data: data)
                    completion(.success(payload: img ?? UIImage()))
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetBlurPhotoFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
    
    // MARK: - GetGrayscalePhoto
    enum GetGrayscalePhotoFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    typealias GetGrayscalePhotoResult = Result<UIImage, GetGrayscalePhotoFailureReason>
    typealias GetGrayscalePhotoCompletion = (_ result: GetGrayscalePhotoResult) -> Void
    
    func getGrayscalePhoto(download_url: String, completion: @escaping GetGrayscalePhotoCompletion) {
        let url = "\(download_url)?grayscale"
        sessionManager.request(url)
            .validate()
            .responseString { response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        completion(.failure(nil))
                        return
                    }

                    let img = UIImage(data: data)
                    completion(.success(payload: img ?? UIImage()))
                case .failure(_):
                    if let statusCode = response.response?.statusCode,
                        let reason = GetGrayscalePhotoFailureReason(rawValue: statusCode) {
                        completion(.failure(reason))
                    }
                    completion(.failure(nil))
                }
        }
    }
}

// MARK: - Picsum URL with custom image dimension - smaller image loads faster
extension String {
    
    func optimizedPicsumURL(_ width: Int = 200, _ height: Int = 300) -> String {
        var newURL = self
        
        if let urlComponents = URLComponents(string: self), let host = urlComponents.host {
            let pathSplit = urlComponents.path.split(separator: "/")
            guard pathSplit.count > 0 else {
                return newURL
            }
            if pathSplit.first == "id" {
                let id = pathSplit.prefix(2).last
                newURL = "https://\(host)/id/\(id ?? "0")/\(width)/\(height)"
            }
        }
        
        return newURL
    }
}
