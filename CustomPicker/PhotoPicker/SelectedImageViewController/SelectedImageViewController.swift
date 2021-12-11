//
//  SelectedImageViewController.swift
//  CustomPicker
//
//  Created by Saddam on 11/25/21.
//

import UIKit
import Photos

struct selectedImage {
    
    var selectImg: UIImage?
    var selectAsset: PHAsset?
    
    init(selectImg: UIImage?, selectAsset: PHAsset?){
        self.selectImg = selectImg
        self.selectAsset = selectAsset
    }
}


class SelectedImageViewController: UIViewController {
    
    @IBOutlet weak var selectedImageCollectionView: UICollectionView!
    let cellSpace = 2
    var selectedImgArray = [selectedImage]()
    var selectedVideoAsset = [PHAsset]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cellRegister()
        
        print("Num of selected img",selectedImgArray.count)
        print("Num of selected video",selectedVideoAsset.count)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    func cellRegister(){
        
        selectedImageCollectionView.dataSource = self
        selectedImageCollectionView.delegate = self
        selectedImageCollectionView.register(UINib(nibName: "ItmsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItmsCollectionViewCell")
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - DataSource & Delegate method

extension SelectedImageViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.item)
    }
}

extension SelectedImageViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selectedImgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = selectedImageCollectionView.dequeueReusableCell(withReuseIdentifier: "ItmsCollectionViewCell", for: indexPath) as! ItmsCollectionViewCell
        
        cell.thumbImage.image = selectedImgArray[indexPath.row].selectImg
        cell.tickImage.isHidden = true
        return cell
    }
    
    
}

//MARK: - CollectionView Flow Layout

extension SelectedImageViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = Int(selectedImageCollectionView.frame.size.width/3)-Int(cellSpace)
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpace)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(cellSpace)
    }
}
