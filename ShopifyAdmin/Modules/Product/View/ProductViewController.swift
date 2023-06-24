//
//  ProductViewController.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//

import UIKit

class ProductViewController: UIViewController {
    
    var productViewModel : ProductViewModel!
    var displayCollectionsViewModel : CollectionsViewModel!
    
    @IBOutlet weak var productTitleTF: UITextField!
    @IBOutlet weak var productDetailsTF: UITextField!

    @IBOutlet weak var productVendorMenu: UIButton!
    @IBOutlet weak var productmenu: UIButton!
    @IBOutlet weak var productCustomCellectionMenu: UIButton!
//    @IBOutlet weak var productImgSrc: UITextField!
//    @IBOutlet weak var imgLabel: UILabel!
    @IBOutlet weak var collectionLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
//    @IBOutlet weak var imagesStack: UIStackView!
    
//    @IBOutlet weak var addImageBtn: UIButton!
    
    var lastTextFiledFrame: CGFloat = CGFloat.zero
    
    var productTypeRes: String = "ACCESSORIES"
    var productVendorRes: String = "ADIDAS"
    var productCustomCellectionRes: Int = 0
    
    var productId: Int?
    var product: Product!
    var optionArr = [Options(name: Constants.size, position: 1, values: []),Options(name: Constants.color, position: 2, values: [])]
    
    var flagEditAdd: Int? // 0 if add, 1 if edit
    
    var customCollections : [NewCustomCollection] = []{
        didSet{
            productCustomCellectionMenu.menu = getCustomCellectionMenu()
        }
    }
    
    var smartCollections : [SmartCollection] = []{
        didSet{
            productVendorMenu.menu = getVendorsMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height + 100)

//        productImgSrc.delegate = self
        productTitleTF.delegate = self
        productDetailsTF.delegate = self

        productViewModel = ProductViewModel()
        displayCollectionsViewModel = CollectionsViewModel()
        
        
        //get all smart collections
        displayCollectionsViewModel.bindResultToDisplayBrands = { [weak self] in
            guard let self = self else { return }
            self.smartCollections = self.displayCollectionsViewModel.allBrands.smart_collections

        }
        displayCollectionsViewModel.getAllBrands()
        
//        get all custom collection
        displayCollectionsViewModel.bindCustomCollection = { [weak self] in
            guard let self = self else { return }
            self.customCollections = self.displayCollectionsViewModel.allCustomCollection.custom_collections

        }
        displayCollectionsViewModel.getAllCustomCollection()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        //Edit
        if flagEditAdd == 1{

            collectionLabel.isHidden = true
            productCustomCellectionMenu.isHidden = true
//            addImageBtn.isHidden = true
            
            productId = product.id ?? 0
            productTitleTF.text = product.title
            productDetailsTF.text = product.bodyHtml
//            productImgSrc.text = product.image?.src
            productTypeRes = product.productType!
            productVendorRes = product.vendor!
            
            product.options = optionArr
            
        }else{
            product = Product( id: nil, title: "", bodyHtml: "", vendor: "", productType: "", createdAt: nil, handle: nil, updatedAt: nil, publishedAt: nil, status: nil, publishedScope: nil, tags: nil, adminGraphqlApiId: nil, variants: [], options: optionArr, images: [], image: nil)
        }
        
        productTypeMenu()
        initializeVendorMenu()
        initializeCustomCellectionMenu()
        
    }
    
    @IBAction func moveToImages(_ sender: Any) {
        let title = productTitleTF.text ?? ""
        let details = productDetailsTF.text ?? ""
        let vendor = productVendorRes
        let productType = productTypeRes
        
//        let imgSrc = productImgSrc.text ?? "https://eg.jumia.is/unsafe/fit-in/680x680/filters:fill(white)/product/73/834963/1.jpg?9525"
        
        let collectionId = productCustomCellectionRes
        
        if(title.isEmpty || details.isEmpty
//           || imgSrc.isEmpty
        ){
//            print("\(title.isEmpty):\(details.isEmpty):\(details.isEmpty):\(imgSrc.isEmpty)")
            print("\(title.isEmpty):\(details.isEmpty):\(details.isEmpty)")
            self.showAlert(title: "⚠️ WARNING", message: "Fields can't be empty!!")
        }else{
            
            product.title = title
            product.bodyHtml = details
            product.productType = productType
            product.vendor = vendor
//            product.image = Image(src:imgSrc)
            
    
            let productImagesVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductImagesVC") as! ProductImagesVC
    
            productImagesVC.product = product
            productImagesVC.collectionId = collectionId
            productImagesVC.flagEditAdd = flagEditAdd
            
            self.navigationController?.pushViewController(productImagesVC, animated: true)
            
        }
        
    }
    
    func productTypeMenu(){
        
        let menuActions : [UIAction] = [
            UIAction(title: "ACCESSORIES",handler: { [weak self] action in
                self?.productTypeRes = "ACCESSORIES"
            }),
            UIAction(title: "T-SHIRTS", handler: { [weak self] action in
                self?.productTypeRes = "T-SHIRTS"
            }),
            UIAction(title: "SHOES",handler: { [weak self] action in
                self?.productTypeRes = "SHOES"
            })
        ]
        
        menuActions.first(where: {$0.title == productTypeRes})?.state = .on
        
        productmenu.menu = UIMenu(title: "Product Type", options: .singleSelection, children: menuActions)
        
        productmenu.showsMenuAsPrimaryAction = true
        productmenu.changesSelectionAsPrimaryAction = true
    }
    
    private func getVendorsMenu() -> UIMenu {
        
        var menuActions = [UIAction]()

        if(smartCollections.isEmpty){
            menuActions.append(
                UIAction(
                    title: "ADIDAS",
                    handler: { [weak self] action in
                        self?.productVendorRes = "ADIDAS"
                    }
                )
            )
        }
        
        smartCollections.indices.forEach({ index in
            let item = UIAction(title: smartCollections[index].title,handler: { [weak self] action in
                guard let self = self else { return }
                self.productVendorRes = self.smartCollections[index].title
            })

            menuActions.append(item)
        })
        
//        menuActions.first?.state = .on
        menuActions.first(where: {$0.title == productVendorRes})?.state = .on

        return UIMenu(
            title: "Product Vendor",
            options: .singleSelection,
            children: menuActions
        )
    }
    
    func initializeVendorMenu(){
        productVendorMenu.menu = getVendorsMenu()
        productVendorMenu.showsMenuAsPrimaryAction = true
        productVendorMenu.changesSelectionAsPrimaryAction = true
    }
    
    private func getCustomCellectionMenu() -> UIMenu {
        
        var menuActions = [UIAction]()

        if(customCollections.isEmpty){
            menuActions.append(
                UIAction(
                    title: "Home page",
                    handler: { [weak self] action in
                        self?.productCustomCellectionRes = 448185696565
                    }
                )
           )
        }
        
        customCollections.indices.forEach({ index in
            if(index == 0){

            }
            let item = UIAction(
                title: customCollections[index].title,
                handler: { [weak self] action in
                    guard let self = self else { return }
                    self.productCustomCellectionRes = self.customCollections[index].id
                }
            )

            menuActions.append(item)
        })

//        menuActions.first?.state = .on
        
        return UIMenu(
            title: "Product Custom Collection",
            options: .singleSelection,
            children: menuActions
        )
    }
    
    func initializeCustomCellectionMenu(){
        
        productCustomCellectionMenu.menu = getCustomCellectionMenu()
        
        productCustomCellectionMenu.showsMenuAsPrimaryAction = true
        productCustomCellectionMenu.changesSelectionAsPrimaryAction = true
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default))
        self.present(alert, animated: true)
        
    }
  
}

extension ProductViewController : UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches,
                           with: event)
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
