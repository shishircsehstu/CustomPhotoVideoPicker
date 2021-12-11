//
//  AlbumTableViewCell.swift
//  CustomPicker
//
//  Created by Saddam on 11/19/21.
//

import UIKit
import Photos

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var numOfItemsLbl: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    private let imageManager = PHCachingImageManager()
    private let contentModee: PHImageContentMode = .aspectFill
    private let durationFormatter = DateComponentsFormatter()
    
    var selectedAsset: PHAsset!{
        didSet{
            setAssetInfo()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setAssetInfo(){
        
        loadImage(for: selectedAsset, in: self)

    }
    
    
    private func loadImage(for asset: PHAsset, in cell: AlbumTableViewCell) {
        // Cancel any pending image requests
        if cell.tag != 0 {
            imageManager.cancelImageRequest(PHImageRequestID(cell.tag))
        }
        
        // Request image
        cell.tag = Int(imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: contentModee, options: nil) { (image, _) in
            guard let image = image else { return }
            
            cell.thumbImage.image = image
            
        })
    }
    
    
}
