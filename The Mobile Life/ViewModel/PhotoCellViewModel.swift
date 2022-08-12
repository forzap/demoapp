//
//  PhotoCellViewModel.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

protocol PhotoCellViewModel {
    var photoItem: Photo { get }
    var authStr: String { get }
    var sizeStr: String { get }
    var urlStr: String { get }
    var download_urlStr: String { get }
}

extension Photo: PhotoCellViewModel {
    
    var photoItem: Photo {
        return self
    }
    
    var authStr: String {
        return author
    }
    
    var sizeStr: String {
        return "\(width) x \(height)"
    }
    
    var urlStr: String {
        return url
    }
    
    var download_urlStr: String {
        return download_url.optimizedPicsumURL()
    }
}
