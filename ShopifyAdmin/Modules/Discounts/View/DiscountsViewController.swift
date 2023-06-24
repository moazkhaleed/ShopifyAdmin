//
//  DiscountsViewController.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 19/06/2023.
//

import UIKit
import Lottie

class DiscountsViewController: UIViewController {
    
    @IBOutlet weak var discountCurtain: UIView!
    @IBOutlet weak var discountEditingPanel: UIView!
    @IBOutlet weak var discountTitleEditText: UITextField!
    @IBOutlet weak var discountsTable: UITableView!
    
    var dicountsViewModel = DiscountsViewModel()
    var discountList:[DiscountCode] = []
    var editOrAdd = ""
    var priceRule:PriceRule!
    var discountBeingHandled: DiscountCode!
    var selectedDiscountIndex: Int!
    var networkIndicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNibCell()
        loadIndicator()
        discountEditingPanel.layer.cornerRadius = 16
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllDiscounts()
    }
    
    func setupNibCell(){
        let nib = UINib(nibName: DiscountConstants.cellClassName , bundle: nil)
        discountsTable.register(nib, forCellReuseIdentifier: DiscountConstants.cellName)
    }
    
    func loadIndicator(){
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
        networkIndicator.startAnimating()
    }
    
    func getAllDiscounts(){
        dicountsViewModel.getAllDiscountCoupons(priceRule: priceRule) {[weak self] discountArr in
            self?.discountList = discountArr
            self?.discountsTable.reloadData()
            self?.networkIndicator.stopAnimating()
        }
    }
    
    func hideEditingDiscountPanel(){
        discountEditingPanel.isHidden = true
        discountCurtain.isHidden = true
    }
    
    func showEditingDiscountPanel(){
        discountEditingPanel.isHidden = false
        discountCurtain.isHidden = false
    }

    @IBAction func exitEditDiscountTitlePanel(_ sender: Any) {
        hideEditingDiscountPanel()
        discountTitleEditText.text = ""
        discountsTable.reloadData()
    }
    
    @IBAction func doneEditingDiscount(_ sender: Any) {
        if discountTitleEditText.text != "" {
            discountBeingHandled.code = discountTitleEditText.text
            
            if editOrAdd == "add" {
                dicountsViewModel.addDiscountCode(discountCode: discountBeingHandled, priceRule: priceRule) { [weak self] returnedDiscount in
                    self?.discountList.append(returnedDiscount)
                    self?.discountsTable.reloadData()
                }
            }
            else {
                dicountsViewModel.updateDiscountCode(discountCode: discountBeingHandled, priceRule: priceRule) { [weak self] returnedDiscount in
                    self?.discountList[(self?.selectedDiscountIndex)!] = returnedDiscount
                    self?.discountsTable.reloadData()
                }
            }
            
            hideEditingDiscountPanel()
            discountTitleEditText.text = ""
            
        }
    }
    
    @IBAction func addDiscount(_ sender: Any) {
        editOrAdd = "add"
        discountBeingHandled = DiscountCode(priceRuleId: priceRule.id)
        showEditingDiscountPanel()
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DiscountsViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discountList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DiscountConstants.cellName) as! DiscountsTableViewCell
        cell.setDiscountData(discount: discountList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        editOrAdd = "edit"
        discountBeingHandled = discountList[indexPath.row]
        selectedDiscountIndex = indexPath.row
        showEditingDiscountPanel()
        discountTitleEditText.text = discountList[indexPath.row].code
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: Constants.warning, message: Constants.confirmDeleteProduct, preferredStyle: .alert)
        let actionDelete = UIAlertAction(title: Constants.delete, style: .destructive) { _ in
            self.dicountsViewModel.deleteDiscountCode(discountCode: self.discountList[indexPath.row], priceRule: self.priceRule)
            self.discountList.remove(at: indexPath.row)
            self.discountsTable.reloadData()
        }
        let actionCancel = UIAlertAction(title: Constants.cancel, style: .cancel)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension DiscountsViewController {
    class DiscountConstants {
        static let cellName = "discountCell"
        static let cellClassName = "DiscountsTableViewCell"
    }
}
