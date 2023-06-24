//
//  ProductVariantsVC.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 21/06/2023.
//

import UIKit

class ProductVariantsVC: UIViewController {
    
    var product:Product!
    var collectionId :Int!
    var flagEditAdd :Int!
    var currentIndex = 0{
        didSet{
            collectionView.reloadData()
        }
    }
    
    var isNew = true{
        didSet{
            prepareVariantFields()
            deleteVariantBtn.isHidden = isNew
        }
    }

    var productViewModel : ProductViewModel!

    @IBOutlet weak var sizeTextField: UITextField!
    
    @IBOutlet weak var colorTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var variantNavigationStack: UIStackView!
    
    @IBOutlet var deleteVariantBtn: UIView!
    
    @IBOutlet weak var noVariantLabel: UILabel!
    
    @IBAction func nextVariant(_ sender: UIButton) {
        
        if product.variants != nil && !(product.variants!.isEmpty){
            if currentIndex < product.variants!.count-1{
                currentIndex += 1
            }else{
                currentIndex = 0
            }
                    
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            pageControl.currentPage = currentIndex
            
            if product.variants!.count > 1{
                variantNavigationStack.isHidden = false
                pageControl.isHidden = false
            }
            
            if !isNew {
                prepareVariantFields()
            }
        }
    }
    
    @IBAction func previousVariant(_ sender: UIButton) {
        if product.variants != nil && !(product.variants!.isEmpty){
            if currentIndex > 0{
                currentIndex -= 1
            }else{
                currentIndex = product.variants!.count-1
            }
                    
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
            
            pageControl.currentPage = currentIndex
            
            if product.variants!.count < 2{
                variantNavigationStack.isHidden = true
                pageControl.isHidden = true
            }
            if !isNew {
                prepareVariantFields()
            }
        }
    }
    
    @IBAction func deleteVariant(_ sender: Any) {
        if product.variants != nil && currentIndex < product.variants!.count{
            deleteVariantAlert()
        }
    }

    @IBAction func switchDidChanged(_ sender: UISwitch) {
        isNew = sender.isOn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pageControl.numberOfPages = product.variants?.count ?? 0
        deleteVariantBtn.isHidden = isNew
        
        if product.variants!.count < 2{
            variantNavigationStack.isHidden = true
            pageControl.isHidden = true
        }
        
        if product.variants!.count == 0{
            noVariantLabel.isHidden = false
        }
        
        if flagEditAdd == 0{
            collectionView.isHidden = true
            noVariantLabel.isHidden = false
        }
        
        productViewModel = ProductViewModel()
        // Do any additional setup after loading the view.
    }
        
    func prepareVariantFields(){
        if isNew {
            sizeTextField.text = ""
            colorTextField.text = ""
            priceTextField.text = ""
            quantityTextField.text = ""
        }else{
            if product.variants!.count > 0{
                sizeTextField.text = product.variants![currentIndex].option1
                colorTextField.text = product.variants![currentIndex].option2
                priceTextField.text = product.variants![currentIndex].price
                quantityTextField.text = "\(Int(product.variants![currentIndex].inventoryQuantity!))"
            }
        }
    }
    

    // third page logic
    
    func deleteVariantAlert(){
        // declare Alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure about deletion?", preferredStyle: .alert)
        
        //AddAction
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { [self] action in
            
            
            product.variants?.remove(at: currentIndex)
            
            if product.variants!.count < 2{
                variantNavigationStack.isHidden = true
            }
            if product.variants!.count == 0{
                deleteVariantBtn.isHidden = true
                noVariantLabel.isHidden = false
            }
            
//            currentIndex -= 1
            
            if currentIndex > 0{
                currentIndex -= 1
            }
            prepareVariantFields()
            
            pageControl.numberOfPages = product.variants!.count
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        
        //showAlert
        self.present(alert, animated: true) {
        //    print("alert done")
        }
    }

    
    @IBAction func saveVariant(_ sender: Any) {
        if saveVariantData(){
            collectionView.isHidden = false
            noVariantLabel.isHidden = true
            if(isNew){
                priceTextField.text = ""
                quantityTextField.text = ""
                sizeTextField.text = ""
                colorTextField.text = ""
            }
            
        }
    }
    
    @IBAction func saveProduct(_ sender: Any) {
        if flagEditAdd == 1{ //edit

            editProduct()
            
//            self.navigationController?.popViewController(animated: true)
            
        }else{ //add
            addProductInfo()
        }
        
    }
    
    
    func saveVariantData() -> Bool{
        if checkVariantFieldsAreFilled() {
            if checkPriceValidity(){
                if checkQuantityValidity(){
                    if checkVariantIsGenuine(){
                        if isNew || product.variants!.isEmpty{
                            let variant = Variants(title: "\(sizeTextField.text!) / \(colorTextField.text!)",price:priceTextField.text!,inventoryManagement: "shopify", option1: sizeTextField.text!, option2: colorTextField.text!, inventoryQuantity: Int(quantityTextField.text!), oldInventoryQuantity: Int(quantityTextField.text!))
                            
                            product.variants?.append(variant)
                            self.view.showToastMessage(message: "Added Successfully", color: .systemGreen)
                            collectionView.reloadData()
                        }else{
                            product.variants![currentIndex].title = "\(sizeTextField.text!) / \(colorTextField.text!)"
                            product.variants![currentIndex].option1 = sizeTextField.text
                            product.variants![currentIndex].option2 = colorTextField.text
                            product.variants![currentIndex].price = priceTextField.text
                            product.variants![currentIndex].inventoryQuantity = Int(quantityTextField.text!)
                            product.variants![currentIndex].oldInventoryQuantity = Int(quantityTextField.text!)
                            self.view.showToastMessage(message: "Saved Successfully", color: .green)
                            collectionView.reloadData()
                        }
                        if product.variants!.count > 1{
                            variantNavigationStack.isHidden = false
                            pageControl.isHidden = false
                        }
                        checkAndAddOptions()
                        
                        return true
                    }else{
                        CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.duplicatedVariant)
                        return false
                    }
                }else{
                    CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.enterValidQuantity)
                    return false
                }
            }else{
                CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.validPrice)
                return false
            }
        }else{
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.emptyFields)
            return false
        }
    }
    
    func checkVariantFieldsAreFilled() -> Bool{
        if priceTextField.text == "" || quantityTextField.text == "" || sizeTextField.text == "" || colorTextField.text == "" {
            return false
        }
        return true
    }
    
    func checkPriceValidity() -> Bool {
        if Double(priceTextField.text!) != nil {
            return true
        }else{
            return false
        }
    }
    
    func checkQuantityValidity() -> Bool {
        if Int(quantityTextField.text!) != nil {
            return true
        }else{
            return false
        }
    }
    
    func checkVariantIsGenuine() -> Bool {
        for variant in product.variants! {
            if(isNew){
                if variant.title == "\(sizeTextField.text!) / \(colorTextField.text!)" {
                    return false
                }
            }
        }
        return true
    }
    
    func showVariantHandlingAlert(){
        let alert = UIAlertController(title: Constants.warning, message: Constants.variantHandlingQuery, preferredStyle: .alert)
        let actionSaveAndContinue = UIAlertAction(title: Constants.save, style: .default) { _ in
            if self.saveVariantData(){
//                self.navigateToDetails()
                self.view.showToastMessage(message: "actionSaveAndContinue", color: .green)
            }
        }
        let actionDiscardAndContinue = UIAlertAction(title: Constants.discard, style: .destructive) { _ in
//            self.navigateToDetails()
            self.view.showToastMessage(message: "actionDiscardAndContinue", color: .red)
        }
        let cancelAction = UIAlertAction(title: Constants.cancel, style: .cancel)
        alert.addAction(actionSaveAndContinue)
        alert.addAction(actionDiscardAndContinue)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func checkAndAddOptions(){
        if !(product.options![0].values!.contains(sizeTextField.text!)) {
            product.options![0].values?.append(sizeTextField.text!)
        }
        if !(product.options![1].values!.contains(colorTextField.text!)) {
            product.options![1].values?.append(colorTextField.text!)
        }
    }

}


extension ProductVariantsVC{
    
    //add product title, vender(smart collection), variant(price), productType(floaty button filter)
    func addProductInfo(){
        
        product.status = "active"
        
        
        productViewModel.bindResultToProduct = {[weak self] in
            print((self?.productViewModel.newProduct.product?.id) ?? 0)
            let productId = (self?.productViewModel.newProduct.product?.id) ?? 0
            
//            self?.addProductImg(productId: productId, imgSrc: (self?.product.image?.src)!)
            
            self?.addProductToCustomCollection(productId: productId, collectionId: (self?.collectionId)!)
            
//            self?.editProductState(productId: productId)
            
            DispatchQueue.main.async {
//                self?.navigationController?.popViewController(animated: true)
                self?.navigationController?.popToViewController(ofClass: ProductsVC.self)
            }
        }
        productViewModel.createProduct(product: product)
    }
    
    // add product image
    func addProductImg(productId: Int, imgSrc: String){
        let params: [String : Any] = [
            "image":[
                "product_id": productId,
                "src": imgSrc
            ] as [String : Any]
        ]
        
        productViewModel.createProductImg(params: params, id: productId)
    }
    
    //add product to custom collection
    func addProductToCustomCollection(productId: Int, collectionId: Int){
        let params: [String : Any] = [
            "collect":[
                "product_id": productId,
                "collection_id": collectionId
            ]
        ]
        productViewModel.addProdoctCustomCollection(params: params)
    }
    
    // edit product state
    func editProduct(){
        
        productViewModel.bindResultToProduct = {[weak self] in
            print((self?.productViewModel.newProduct.product?.id) ?? 0)
            let productId = (self?.productViewModel.newProduct.product?.id) ?? 0
            
//            self?.addProductImg(productId: productId, imgSrc: (self?.product.image?.src)!)
            
//            self?.addProductToCustomCollection(productId: productId, collectionId: (self?.collectionId)!)
            
//            self?.editProductState(productId: productId)
            
            DispatchQueue.main.async {
//                self?.navigationController?.popViewController(animated: true)
                self?.navigationController?.popToViewController(ofClass: ProductsVC.self)
            }
        }
        
        productViewModel.editProduct(product: product)
    }
    
//    func editProductState(productId: Int){
//        let params: [String: Any] = [
//            "product":[
//                "status": "active",
////                "published": true
//            ]
//        ]
//        product.status = "active"
//        productViewModel.editProduct(params: params, id: productId)
////        productViewModel.editProduct(params: params, id: productId)
//    }
    
    
}


extension ProductVariantsVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product.variants?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
                        IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productVariantCell",
                                                      for: indexPath) as! ProductVariantCell
        cell.size.text = (product.variants?[currentIndex].option1)
        cell.color.text = (product.variants?[currentIndex].option2)
        let price : String = (product.variants?[currentIndex].price)!
        cell.price.text = "\(price)"
        let quantity : Int = (product.variants?[currentIndex].inventoryQuantity)!
        cell.quantity.text = "\(quantity)"
        
        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: collectionView.frame.width - 16, height:  collectionView.frame.height)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
}
