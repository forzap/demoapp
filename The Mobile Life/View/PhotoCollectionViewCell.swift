//
//  PhotoCollectionViewCell.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell : UICollectionViewCell {
    
    // MARK: - UI create and draw
    private lazy var photoView: ImageViewWithURLDownload = {
        let view = ImageViewWithURLDownload()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.frame.origin.x)
            make.width.equalTo(self.contentView.frame.size.width)
            make.height.equalTo(self.contentView.frame.size.height)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var cellReused: (() -> Void)?
    
    public func helperCancelLoadingImage() {
        photoView.cancelLoadingImage()
    }
        
    override func prepareForReuse() {
        super.prepareForReuse()
        cellReused?()
    }
    
    // MARK: - Bind
    var viewModel: PhotoCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        photoView.downloadWithUrlSession(urlStr: viewModel?.download_urlStr ?? "")
    }
}
