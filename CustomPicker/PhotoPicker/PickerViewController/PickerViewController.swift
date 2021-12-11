//
//  PickerViewController.swift
//  CustomPicker
//
//  Created by Saddam on 11/18/21.
//

import UIKit
import Photos
import SwiftProgressView

class PickerViewController: UIViewController {
    
    @IBOutlet weak var albumNameLbl: UILabel!
    @IBOutlet weak var albumView: AlbumView!
    @IBOutlet weak var doneBtnOutlet: UIButton!
    @IBOutlet weak var mediaCollectionView: UICollectionView!
    
    var phAssetArray = PHFetchResult<PHAsset>()
    var cellSpace = CGFloat(2)
    var selectedAssets = [PHAsset]()
    var finalVideoAssets = [PHAsset]()
    var delegate: PickerViewControllerDelegate!
    public var progressView = ProgressPieView()
    var selectImgArray = [selectedImage]()
    
    @IBOutlet weak var progressContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaCollectionView.register(UINib(nibName: "ItmsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ItmsCollectionViewCell")
        
        mediaCollectionView.dataSource = self
        mediaCollectionView.delegate = self
        checkPhotoLibraryPermission()
        doneBtnEnableDisable()
        albumView.isHidden = true
        albumView.delegate = self
        manageProgressView()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        albumView.isHidden = true
        progressContainerView.isHidden = true
        
        selectImgArray.removeAll()
        selectedAssets.removeAll()
        finalVideoAssets.removeAll()
        
        progressView.setProgress(0, animated: false)
        doneBtnEnableDisable()
        mediaCollectionView.reloadData()
    }
    
    func fetchMedia(){
        
        phAssetArray = PickerModel.share.fetchMediaAsset()
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadData()
        }
    }
    
    func initAllInfo(){
        
        selectedAssets.removeAll()
        doneBtnEnableDisable()
        
    }
    func manageProgressView(){
        
        let customProGView = UIView()
        
        let DEVICE_HEIGHT = UIScreen.main.bounds.size.height
        let DEVICE_WIDTH = UIScreen.main.bounds.size.width
        
        progressContainerView.frame = view.bounds
        //  progressContainerView.backgroundColor =
        //NAVBAR_BAR_TINT_COLOR.withAlphaComponent(0.5)
        let progH = 140
        let progW = 240
        
        customProGView.frame = CGRect(x: Int(DEVICE_WIDTH)/2-progW/2, y: Int(DEVICE_HEIGHT)/2-progH/2, width: progW, height: progH)
        
        let frame = CGRect(x: 80, y: 5, width: progW-160, height: progH-40)
        
        progressView = ProgressPieView(frame: frame)
        
        customProGView.backgroundColor = .gray//VIEW_BG_COLOR.withAlphaComponent(0.90)
        customProGView.layer.cornerRadius = 25
        progressView.progressColor = .systemPink
        progressView.circleColor = .white
        
        let lbl = UILabel()
        lbl.frame = CGRect(x: 15, y: progH-40, width: 240, height: 40)
        lbl.text = "Downloading from iCloud.."
        lbl.tintColor =  .white
        lbl.textColor = .white
        
        customProGView.addSubview(lbl)
        customProGView.addSubview(progressView)
        
        progressContainerView.addSubview(customProGView)
        view.addSubview(progressContainerView)
        progressContainerView.bringSubviewToFront(self.view)
        progressContainerView.isHidden = true
        
    }
    
    
    func doneBtnEnableDisable(){
        
        if selectedAssets.count>0{
            doneBtnOutlet.isEnabled = true
            doneBtnOutlet.alpha = 1.0
        }else{
            doneBtnOutlet.isEnabled = false
            doneBtnOutlet.alpha = 0.5
        }
    }
    
    @IBAction func tapToChangeAlbumAction(_ sender: Any) {
        
        DispatchQueue.main.async { [self] in
            albumView.commonInit()
            albumView.isHidden = false
        }
        //  albumView.commonInit()
        // albumView.isHidden = false
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneBtnAction(_ sender: Any){
        
        let totalAsset = selectedAssets.count
        let dispatchGroup = DispatchGroup()
        for i in 0..<totalAsset{
            
            dispatchGroup.enter()
            
            if selectedAssets[i].mediaType == .image{
                
                cloudImageCheck(asset: selectedAssets[i], indx: i) { (img) in
                    if let img = img{
                        
                        self.selectImgArray.append(selectedImage(selectImg: img, selectAsset: self.selectedAssets[i]))
                    }
                    dispatchGroup.leave()
                }
                
            }else{
                cloudVideoCheck(asset: selectedAssets[i]) { [self] (falg) in
                    if falg{
                        finalVideoAssets.append(selectedAssets[i])
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main){
            
            self.goSelectImgVC()
            print("All done")
        }
        
    }
    
    func cloudVideoCheck(asset: PHAsset,completion: @escaping (Bool)->()){
        
        let requestOptions = PHVideoRequestOptions.init()
        requestOptions.version = .current
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .highQualityFormat
        
        requestOptions.progressHandler = {
            progress, error, stop, info in
            print("progress ", progress)
            
            DispatchQueue.main.async {
                self.progressContainerView.isHidden = false
            }
            self.progressView.setProgress(CGFloat(progress), animated: true)
            
            DispatchQueue.main.async {
                if progress>=1{
                    
                    completion(true)
                    
                    // self.finalAssets.append(asset)
                }
            }
        }
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: requestOptions) { (videoAsset, audioMix, info) in
            guard videoAsset != nil else {
                print("Failed to download from iCloud!")
                completion(false)
                self.noInternate()
                return
            }
        }
        
    }
    
    func cloudImageCheck(asset: PHAsset, indx: Int,completion: @escaping (UIImage?)->()){
        
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.resizeMode = .exact
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.deliveryMode = .highQualityFormat;
        
        requestOptions.progressHandler = {
            progress, error, stop, info in
            DispatchQueue.main.async {
                self.progressContainerView.isHidden = false
                
                if progress>=1{
                    self.progressView.setProgress(0, animated: false)
                }else{
                    self.progressView.setProgress(CGFloat(progress), animated: true)
                }
            }
        }
        // Request Image
        PHImageManager.default().requestImageData(for: asset, options: requestOptions, resultHandler: { [self] (data, str, orientation, info) -> Void in
            
            if let data = data{
                let img = UIImage(data: data)
                completion(img)
            }else{
                completion(nil)
                self.noInternate()
            }
        })

    }
    
    func goSelectImgVC(){
        
        DispatchQueue.main.async { [self] in
            let pickerVC = UIStoryboard(name: "SelectedImage", bundle: nil).instantiateViewController(withIdentifier: "SelectedImageViewController") as! SelectedImageViewController
            pickerVC.selectedImgArray = selectImgArray
            pickerVC.selectedVideoAsset = finalVideoAssets
            navigationController?.pushViewController(pickerVC, animated: true)
            
        }
        
    }
}




//MARK: - CollectionView Data Source method

extension PickerViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return phAssetArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = mediaCollectionView.dequeueReusableCell(withReuseIdentifier: "ItmsCollectionViewCell", for: indexPath) as! ItmsCollectionViewCell
        
        cell.selectedAsset = phAssetArray[indexPath.row]
        
        if selectedAssets.contains(phAssetArray[indexPath.row]){
            cell.tickImage.isHidden = false
        }else{
            cell.tickImage.isHidden = true
        }
        
        return cell
        
    }
}


//MARK: - Collection View delegate method

extension PickerViewController: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let asset = phAssetArray[indexPath.row]
        if selectedAssets.contains(asset){
            let indx = selectedAssets.firstIndex(of: asset)
            selectedAssets.remove(at: indx!)
        }else{
            selectedAssets.append(asset)
        }
        DispatchQueue.main.async {
            self.mediaCollectionView.reloadItems(at: [indexPath])
        }
        
        doneBtnEnableDisable()
        
    }
}


//MARK: - CollectionView Flow Layout

extension PickerViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = Int(mediaCollectionView.frame.size.width/3)-Int(cellSpace)
        
        return CGSize(width: width, height: width)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 0)
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpace
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpace
    }
}


//MARK: - Photo permission method

extension PickerViewController{
    
    func givePermissionForVideoLibrary(){
        
        OperationQueue.main.addOperation() {
            
            let alert = UIAlertController(title: "Permission Required", message: "This app requires access to your video library. Please allow it on settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func noInternate(){
        
        OperationQueue.main.addOperation() {
            
            let alert = UIAlertController(title: "No Internate", message: "Internate required for iCloud Data fetch", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
                
                self.goSelectImgVC()
                
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func permissionLimitedForVideoLibrary(){
        
        OperationQueue.main.addOperation() {
            
            let alert = UIAlertController(title: "Limited Permission", message: "This app requires access to your all photos for better user experience. Please allow it on settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(ACTION) in
                // self.presentPicker()
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            self.present(alert,animated: true, completion: nil)
        }
    }
    
    func checkPhotoLibraryPermission() {
        
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                switch status {
                case .authorized:
                    self.fetchMedia()
                    break
                case .limited:
                    self.fetchMedia()
                    self.permissionLimitedForVideoLibrary()
                    print("limited access granted")
                    break
                case .denied, .restricted:
                    self.givePermissionForVideoLibrary()
                    break
                default:
                    print("Unknown")
                    
                }
            }
        } else {
            
            // Fallback on earlier versions
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                
                case .authorized:
                    self.fetchMedia()
                    break
                case .limited:
                    self.fetchMedia()
                    self.permissionLimitedForVideoLibrary()
                    break
                case .denied, .notDetermined, .restricted:
                    self.givePermissionForVideoLibrary()
                    break
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
}


extension PickerViewController: AlbumViewDelegate{
    func getSelectedCollection(collection: PHAssetCollection) {
        
        DispatchQueue.main.async {
            
            self.initAllInfo()
            self.albumView.isHidden = true
            self.phAssetArray = PickerModel.share.getAssetsFromAlbum(fromCollection: collection)
            self.mediaCollectionView.reloadData()
            
            self.albumNameLbl.text = collection.localizedTitle!
            
        }
    }
    
}

protocol PickerViewControllerDelegate: AnyObject {
    
    func getSelectedAssets(selectedAssets: [PHAsset])
}
