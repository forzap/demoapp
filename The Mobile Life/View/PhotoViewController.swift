//
//  PhotoViewController.swift
//  The Mobile Life
//
//  Created by Phua Kim Leng on 06/08/2022.
//

import UIKit
import PKHUD

class PhotoViewController: UIViewController {
    
    let reuseIdentifier = "PhotoCell"
    let itemsPerRow: CGFloat = 2
    var currentPage: Int = 1
    
    let viewModel: PhotoCollectionViewViewModel = PhotoCollectionViewViewModel()
    
    // MARK: - UI create and draw
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = .black
        view.showsHorizontalScrollIndicator = false
        view.isPrefetchingEnabled = true
        view.delaysContentTouches = true
        view.canCancelContentTouches = true
        view.isOpaque = true
        view.clearsContextBeforeDrawing = true
        view.clipsToBounds = true
        view.autoresizesSubviews = true
        view.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        return view
    }()
    
    // MARK: - View Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(kTopInset)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        bindViewModel()
        viewModel.getPhotos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        unbindViewModel()
    }
}

// MARK: - Helpers
extension PhotoViewController {
    
    func bindViewModel() {
        viewModel.photoCells.bindAndFire() { [weak self] _ in
            self?.collectionView.reloadData()
        }
        
        viewModel.onShowError = { [weak self] alert in
            self?.presentSingleButtonDialog(alert: alert)
        }
        
        viewModel.showLoadingHud.bind() { [weak self] visible in
            if let `self` = self {
                PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
                visible ? PKHUD.sharedHUD.show(onView: self.view) : PKHUD.sharedHUD.hide()
            }
        }
    }
    
    func unbindViewModel() {
        viewModel.photoCells.unbind()
    }
}

// MARK: - Collection View Data Source and Delegate
extension PhotoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoCells.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == viewModel.photoCells.value.count - 1 {
            currentPage = currentPage + 1
            viewModel.getPhotos(currentPage)
        }
        
        switch viewModel.photoCells.value[indexPath.item] {
        case .normal(let viewModel):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PhotoCollectionViewCell
            
            cell!.cellReused = {
                cell!.helperCancelLoadingImage()
            }
            
            cell!.backgroundColor = .black
            cell!.viewModel = viewModel
            
            return cell!
        case .error(_):
            let cell = UICollectionViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        case .empty:
            let cell = UICollectionViewCell()
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch viewModel.photoCells.value[indexPath.item] {
        case .normal(let viewModel):
            if let navController = self.navigationController {
                let vc = PhotoDetailViewController()
                vc.viewModel = viewModel
                navController.pushViewController(vc, animated: true)
            }
        case .error(_):
            ()
        case .empty:
            ()
        }
    }
}

// MARK: - Collection View Flow Layout Delegate
extension PhotoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dimension = view.frame.width / itemsPerRow
        return CGSize(width: dimension, height: dimension)
    }
}

// MARK: - SingleButtonDialogPresenter protocol
extension PhotoViewController: SingleButtonDialogPresenter {
    
}
