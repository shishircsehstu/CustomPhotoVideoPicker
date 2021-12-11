//
//  AlbumView.swift
//  CustomPicker
//
//  Created by Saddam Hossain on 11/19/21.
 // saddam.cse14@gmail.com
//

import Foundation
import UIKit
import Photos

class AlbumView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var albumTableView: UITableView!
    
    
    var albums = [AlbumModel]()
    var delegate: AlbumViewDelegate!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit(){
        
        if albums.count==0{
        albums = PickerModel.share.getAlbumList()
        }
        Bundle.main.loadNibNamed("AlbumView", owner: self, options: nil)
        contentView.fixInView(self)
        
        albumTableView.register(UINib(nibName: "AlbumTableViewCell", bundle: nil), forCellReuseIdentifier: "AlbumTableViewCell")
        
        albumTableView.dataSource = self
        albumTableView.delegate = self
        
    }
    
}

extension AlbumView: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = albumTableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell") as! AlbumTableViewCell
        
        cell.albumName.text = albums[indexPath.row].name
        cell.numOfItemsLbl.text = "\(albums[indexPath.row].count)"
        
        cell.selectedAsset = albums[indexPath.row].sampleAsset
        return cell
    }
    
    
}

extension AlbumView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate.getSelectedCollection(collection: albums[indexPath.row].collection)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

protocol AlbumViewDelegate: AnyObject {
    
    func getSelectedCollection(collection: PHAssetCollection)
}
