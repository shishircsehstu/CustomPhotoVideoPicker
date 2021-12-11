//
//  PickerModel.swift
//  CustomPicker
//
//  Created by Saddam on 11/18/21.
//

import Foundation
import Photos
import UIKit


public class Assets : NSObject {
    
    
    static var share = Assets()
    public enum MediaTypes {
        case image
        case video
        
        fileprivate var assetMediaType: PHAssetMediaType {
            switch self {
            case .image:
                return .image
            case .video:
                return .video
            }
        }
    }
    public lazy var supportedMediaTypes: Set<MediaTypes> = [.image]
    
    public lazy var options: PHFetchOptions = {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let rawMediaTypes = supportedMediaTypes.map { $0.assetMediaType.rawValue }
        let predicate = NSPredicate(format: "mediaType IN %@", rawMediaTypes)
        fetchOptions.predicate = predicate
        
        return fetchOptions
    }()
}




class PickerModel{
    
    static var share = PickerModel()
    let option = Assets.share.options
    var delegate: PickerModelDelegate!
    
    var album:[AlbumModel] = [AlbumModel]()
    
    func fetchMediaAsset()-> PHFetchResult<PHAsset>{
        
        let assets = PHAsset.fetchAssets(with: option)
        return assets
        
        
    }
    
    
    func getAlbumList()->[AlbumModel]{
        
        album.removeAll()
        
        let albumList = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        
        for i in 0..<albumList.count{
            let name = albumList[i]
            print(name.localizedTitle!)
            let assets = getAssetsFromAlbum(fromCollection: name)
            if assets.count>0{
                
                let newAlbum = AlbumModel(name: name.localizedTitle!, count:assets.count, collection:name, sampleAsset: assets[0])
                album.append(newAlbum)
            }
        }
        
        return album
    }
    
    func getAssetsFromAlbum(fromCollection collection: PHAssetCollection) -> PHFetchResult<PHAsset> {
        
        return PHAsset.fetchAssets(in: collection, options: option)
    }
    
    
    func givePermissionForVideoLibrary(){
        
        OperationQueue.main.addOperation() {
            
            let alert = UIAlertController(title: "Permission Required", message: "This app requires access to your contact. Please allow it on settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: {(ACTION) in alert.dismiss(animated: true, completion: nil)
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
            
            self.delegate.presentAlert(alert: alert)
        }
    }
}

protocol  PickerModelDelegate: AnyObject{
    func presentAlert(alert: UIAlertController)
}


