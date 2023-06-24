//
//  ProductsVC.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 06/06/2023.
//
import UIKit
import Kingfisher

class ProductsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var displayProductsViewModel : ProductsVM!
    
    var allProducts :[Product] = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayProductsViewModel = ProductsVM()
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displayProductsViewModel.bindResultToDisplayProducts = { [weak self] in
            DispatchQueue.main.async {
                self?.allProducts = self?.displayProductsViewModel.allProducts.products ?? []
                self?.collectionView.reloadData()
            }
        }
        displayProductsViewModel.getAllProducts()
    }
        
    @IBAction func addNewProduct(_ sender: Any) {
        let productVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        productVC.flagEditAdd = 0
    
        self.navigationController?.pushViewController(productVC, animated: true)
    }
    
}


extension ProductsVC: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allProducts.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productItem", for: indexPath) as! ProductCell
        
        cell.productTitle.text = allProducts[indexPath.row].title
        cell.productPrice.text = "$ \(allProducts[indexPath.row].variants?.first?.price ?? "")"
        cell.productImage.kf.setImage(with: URL(string: allProducts[indexPath.row].image?.src ?? ""),placeholder: UIImage(named: "placeholder"))
        
        cell.editProduct = { [unowned self] in
            // navigate and path data
            let productVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            productVC.flagEditAdd = 1
            
            productVC.product = allProducts[indexPath.row]
        
            self.navigationController?.pushViewController(productVC, animated: true)
        }
        
        cell.deleteProduct = { [unowned self] in
            // remove from collection and array and server
            showAlert(indexPath: indexPath)
            
        }
        
        return cell
    }
    
    func showAlert(indexPath: IndexPath){
        // declare Alert
        let alert = UIAlertController(title: "Delete", message: "Are you sure about deletion?", preferredStyle: .alert)
        
        //AddAction
        alert.addAction(UIAlertAction(title: "OK", style: .default , handler: { [self] action in
           // print("ok clicked")

            //delete from server
            displayProductsViewModel.deleteProduct(productId: allProducts[indexPath.row].id ?? 0)
            //delete from array
            allProducts.remove(at: indexPath.row)
            //delete from table
            collectionView.deleteItems(at: [indexPath])
            
            self.collectionView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel))
        

        //showAlert
        self.present(alert, animated: true) {
        //    print("alert done")
        }
    }
    
}

extension ProductsVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return  CGSize(width: 180, height: 244)
    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 1, left: 2, bottom: 1, right: 2)
//    }
}
