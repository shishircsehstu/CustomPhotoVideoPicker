//
//  AlbumModel.swift
//  CustomPicker
//
//  Created by Saddam on 11/19/21.
//

import Foundation
import Photos

class AlbumModel {
    
    let name:String
    let count:Int
    let collection:PHAssetCollection
    let sampleAsset: PHAsset
    
    init(name:String, count:Int, collection:PHAssetCollection, sampleAsset: PHAsset) {
        self.name = name
        self.count = count
        self.collection = collection
        
        self.sampleAsset = sampleAsset
    }
}
