//
//  ItmsCollectionViewCell.swift
//  CustomPicker
//
//  Created by Saddam on 11/18/21.
//

import UIKit
import Photos

class ItmsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var tickImage: UIImageView!
    @IBOutlet weak var durationLbl: UILabel!
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
        durationFormate()
        
    }
    
    func durationFormate(){
        
        durationFormatter.unitsStyle = .positional
        durationFormatter.zeroFormattingBehavior = [.pad]
        durationFormatter.allowedUnits = [.minute, .second]
    }
    
    func setAssetInfo(){
        
        loadImage(for: selectedAsset, in: self)
        
        if selectedAsset.mediaType == .video{
            durationLbl.text = durationFormatter.string(from: selectedAsset.duration)
        }else{
            durationLbl.text = " "
        }
    }
    
    private func loadImage(for asset: PHAsset, in cell: ItmsCollectionViewCell) {
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
