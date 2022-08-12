//
//  PhotoDetailViewController.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import UIKit
import PKHUD

let photoDetailViewModel: PhotoDetailViewModel = PhotoDetailViewModel()

class PhotoDetailViewController: UIViewController {
    
    // MARK: - UI create and draw
    private lazy var segmentedCtrl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Normal", "Blur", "Grayscale"])
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(self.segmentedValueChanged(_:)), for: .valueChanged)
        return view
    }()
    
    private lazy var slider: UISlider = {
        let view = UISlider()
        view.minimumValue = 1
        view.maximumValue = 10
        view.isContinuous = false
        view.setValue(1.0, animated: false)
        view.isHidden = true
        view.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        return view
    }()
    
    private lazy var photoView: ImageViewWithURLDownload = {
        let view = ImageViewWithURLDownload()
        return view
    }()
    
    private lazy var detailText: UITextView = {
        let view = UITextView()
        view.textContainer.lineBreakMode = .byWordWrapping
        view.textContainer.maximumNumberOfLines = 0
        view.isUserInteractionEnabled = false
        return view
    }()
    
    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        self.view.addSubview(segmentedCtrl)
        segmentedCtrl.snp.makeConstraints { (make) in
            make.top.equalTo(kTopInset).offset(100)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(60)
        }
        
        self.view.addSubview(slider)
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(segmentedCtrl.snp.bottom).offset(5)
            make.centerX.equalTo(segmentedCtrl)
            make.width.equalTo(segmentedCtrl.snp.width).offset(-40)
            make.height.equalTo(0)
        }
        
        self.view.addSubview(photoView)
        photoView.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp.bottom).offset(10)
            make.left.equalTo(10)
            make.width.equalToSuperview().offset(-20)
            make.height.equalToSuperview().dividedBy(2)
        }
        
        self.view.addSubview(detailText)
        detailText.snp.makeConstraints { (make) in
            make.top.equalTo(photoView.snp.bottom).offset(10)
            make.left.equalTo(photoView.snp.left)
            make.width.equalToSuperview().offset(20)
            make.height.equalToSuperview().offset(-20)
        }
        
        bindPhotoDetailViewModel()
        photoView.downloadWithUrlSession(urlStr: viewModel?.download_urlStr ?? "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unbindPhotoDetailViewModel()
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        var sliderHeight: Int
        
        switch sender.selectedSegmentIndex {
        case 1: // Blur
            sliderHeight = 40
            photoDetailViewModel.getBlurPhoto(Int(round(slider.value)), download_url: viewModel?.download_urlStr ?? "")
        case 2: // Grayscale
            sliderHeight = 0
            photoDetailViewModel.getGrayscalePhoto(download_url: viewModel?.download_urlStr ?? "")
        default: // Normal
            sliderHeight = 0
            photoView.downloadWithUrlSession(urlStr: viewModel?.download_urlStr ?? "")
        }
        
        self.slider.isHidden = sliderHeight == 0
        self.slider.snp.remakeConstraints { (make) in
            make.top.equalTo(segmentedCtrl.snp.bottom).offset(5)
            make.centerX.equalTo(segmentedCtrl)
            make.width.equalTo(segmentedCtrl.snp.width).offset(-40)
            make.height.equalTo(sliderHeight)
        }
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!) {
        let value = Int(round(sender.value))
        
        bindPhotoDetailViewModel()
        photoDetailViewModel.getBlurPhoto(value, download_url: viewModel?.download_urlStr ?? "")
    }
    
    // MARK: - Bind
    var viewModel: PhotoCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        photoView.downloadWithUrlSession(urlStr: viewModel?.download_urlStr ?? "")
        segmentedCtrl.selectedSegmentIndex = 0
        
        let details = """
Author\t: \(viewModel?.authStr ?? "")
Orig Size\t: \(viewModel?.sizeStr ?? "")
URL Link\t: \(viewModel?.urlStr ?? "")
Download\t: \(viewModel?.download_urlStr ?? "")
"""
        detailText.text = details
    }
}

// MARK: - Helpers
extension PhotoDetailViewController {
    
    func bindPhotoDetailViewModel() {
        photoDetailViewModel.photoImg.bindAndFire() { [weak self] _ in
            switch photoDetailViewModel.photoImg.value {
            case .normal(let photoImg):
                self?.photoView.image = photoImg
            case .error(_):
                () // Error handling
            case .empty:
                () // Error handling
            case .none:
                () // Error handling
            }
        }
        
        photoDetailViewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        
        photoDetailViewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
    }
    
    func unbindPhotoDetailViewModel() {
        photoDetailViewModel.photoImg.unbind()
    }
}

// MARK: - SingleButtonDialogPresenter protocol
extension PhotoDetailViewController: SingleButtonDialogPresenter {
    
}
