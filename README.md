# CustomPhotoVideoPicker

<p float="left">
 <img src="https://user-images.githubusercontent.com/29371886/145667507-4fd26399-8abf-492a-93e6-2a00131df508.png" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="200" height="400" />
 
   <img src="https://user-images.githubusercontent.com/29371886/145667597-3b2326bb-4ac2-422b-8900-9a1782b81d69.png" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="200" height="400" />
 
  <img src="https://user-images.githubusercontent.com/29371886/145667641-95d8ea13-ed01-430c-8f28-a1c35a730654.png" data-canonical-src="https://gyazo.com/eb5c5741b6a9a16c692170a41a49c858.png" width="200" height="400" />
 
</p>


### Usage

```
    
    @IBAction func pickMediaAction(_ sender: Any) {
        
        
        Assets.share.supportedMediaTypes = [.image,.video]
        
        let pickerVC = UIStoryboard(name: "Picker", bundle: nil).instantiateViewController(withIdentifier: "PickerViewController") as! PickerViewController
        
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .fullScreen
        let pickerNavVC = UINavigationController(rootViewController: pickerVC)
        pickerNavVC.modalPresentationStyle = .fullScreen
        present(pickerNavVC, animated: true, completion: nil)
    }

```
For picking only image use
```
Assets.share.supportedMediaTypes = [.image]
```
