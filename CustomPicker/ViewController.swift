//
//  ViewController.swift
//  CustomPicker
//
//  Created by Saddam on 11/18/21.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func pickMediaAction(_ sender: Any) {
        
        
        Assets.share.supportedMediaTypes = [.image,.video]
        
        let pickerVC = UIStoryboard(name: "Picker", bundle: nil).instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .fullScreen
        let pickerNavVC = UINavigationController(rootViewController: pickerVC)
        pickerNavVC.modalPresentationStyle = .fullScreen
        present(pickerNavVC, animated: true, completion: nil)
    }
}

extension ViewController: PickerViewControllerDelegate{
    
    func getSelectedAssets(selectedAssets: [PHAsset]) {
        print("Total Selected asset ", selectedAssets.count)
    }
}

