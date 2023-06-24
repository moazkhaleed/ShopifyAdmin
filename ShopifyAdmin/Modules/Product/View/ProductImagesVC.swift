//
//  ProductImagesVC.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 20/06/2023.
//

import UIKit

class ProductImagesVC: UIViewController {
    
    var product :Product!
    var collectionId :Int!
    var flagEditAdd :Int!
    var currentIndex = 0

    @IBOutlet weak var addImageUrlTextField: UITextView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var imageNavigationStack: UIStackView!
    
    @IBOutlet var deleteImageBtn: UIView!
    
    @IBAction func nextImage(_ sender: UIButton) {
        
        if product.images != nil && !(product.images!.isEmpty){
            if currentIndex < product.images!.count-1{
                currentIndex += 1
            }else{
                currentIndex = 0
            }
                    
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            pageControl.currentPage = currentIndex
            
            if product.images!.count > 1{
                pageControl.isHidden = false
            }
        }
    }
    
    @IBAction func previousImage(_ sender: UIButton) {
        if product.images != nil && !(product.images!.isEmpty){
            if currentIndex > 0{
                currentIndex -= 1
            }else{
                currentIndex = product.images!.count-1
            }
                    
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            pageControl.currentPage = currentIndex
            
            if product.images!.count < 2{
                pageControl.isHidden = true
            }
            
        }
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        if product.images != nil && currentIndex < product.images!.count{
            deleteImageAlert()
        }
    }
    
    @IBAction func addImage(_ sender: Any) {
        if saveProductImage(){
            addImageUrlTextField.text = ""
            collectionView.reloadData()
            if product.images!.count > 1{
                imageNavigationStack.isHidden = false
            }
            if product.images!.count > 0{
                deleteImageBtn.isHidden = false
            }
            
            pageControl.numberOfPages = product.images!.count
        }
    }
    
    @IBAction func moveToVariantsVC(_ sender: Any) {
        checkAndMoveToVariantPage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = product.images?.count ?? 0
        
        if product.images!.count < 2{
            imageNavigationStack.isHidden = true
        }
        if product.images!.count == 0{
            deleteImageBtn.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    // second page logic
    
    func setSecondPageUI(){
        addImageUrlTextField.giveShadowAndRadius(shadowRadius: 0, cornerRadius: 20)
        addImageUrlTextField.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func deleteImageAlert(){
        // declare Alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure about deletion?", preferredStyle: .alert)
        
        //AddAction
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { [self] action in
            
            
            product.images?.remove(at: currentIndex)
            if product.images!.count < 2{
                imageNavigationStack.isHidden = true
            }
            if product.images!.count == 0{
                deleteImageBtn.isHidden = true
            }
            
            currentIndex -= 1
            pageControl.numberOfPages = product.images!.count
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        
        //showAlert
        self.present(alert, animated: true) {
        //    print("alert done")
        }
    }
    
    func saveProductImage() -> Bool{
        if addImageUrlTextField.text != ""{
            var duplicatedImage = false
            if !product.images!.isEmpty {
                for image in product.images! {
                    if image.src == addImageUrlTextField.text {
                        duplicatedImage = true
                        break
                    }
                }
            }
            if duplicatedImage {
                CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.duplicatedImage)
                return false
            }else{
                product.images?.append(Image(src: addImageUrlTextField.text))
                return true
            }
        }else{
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.enterImageURL)
            return false
        }
    }
    
    func checkAndMoveToVariantPage(){
        if addImageUrlTextField.text == "" {
            if product.images!.isEmpty {
                CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.atLeastOneImage)
            }else {
                moveToVariantPage()
            }
        }else{
            var duplicatedImage = false
            for image in product.images! {
                if image.src == addImageUrlTextField.text {
                    duplicatedImage = true
                    break
                }
            }
            if duplicatedImage {
                moveToVariantPage()
            }else{
                showImageHandlingAlert()
            }
        }
    }
    
    func showImageHandlingAlert(){
        let alert = UIAlertController(title: Constants.warning, message: Constants.imageHandlingQuery, preferredStyle: .alert)
        let actionSaveAndContinue = UIAlertAction(title: Constants.save, style: .default) { _ in
            self.product.images?.append(Image(src: self.addImageUrlTextField.text))
            self.moveToVariantPage()
        }
        let actionDiscardAndContinue = UIAlertAction(title: Constants.discard, style: .destructive) { _ in
            self.moveToVariantPage()
        }
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        alert.addAction(actionSaveAndContinue)
        alert.addAction(actionDiscardAndContinue)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func moveToVariantPage(){
//        self.currentPage += 1
//        self.ImageInputView.isHidden = true
//        self.variantInputView.isHidden = false
//        self.nextButton.setImage(UIImage(systemName: Constants.checkMarkSeal), for:.normal)
        // navigate and path data

        self.addImageUrlTextField.text = ""
        
        let productVariantsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductVariantsVC") as! ProductVariantsVC

        productVariantsVC.product = product
        productVariantsVC.collectionId = collectionId
        productVariantsVC.flagEditAdd = flagEditAdd
        
        self.navigationController?.pushViewController(productVariantsVC, animated: true)
    }
    

}


extension ProductImagesVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
                        IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productImageCell",
                                                      for: indexPath) as! ProductImageCell
        let url = URL(string: (product.images?[indexPath.row].src)!)
        cell.imgProductPhoto.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"))
        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: collectionView.frame.width, height:  collectionView.frame.height)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

