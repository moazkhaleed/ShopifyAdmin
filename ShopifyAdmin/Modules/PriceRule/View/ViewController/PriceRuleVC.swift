//
//  PriceRuleVC.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 19/06/2023.
//

import UIKit

class PriceRuleVC: UIViewController {

    @IBOutlet weak var titleTextFileld: UITextField!
    @IBOutlet weak var usageLimitTextField: UITextField!
    @IBOutlet weak var disountAmountTextField: UITextField!
    @IBOutlet weak var typeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var startDatePicler: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!

    var networkIndicator : UIActivityIndicatorView!
    
    var priceRuleViewModel: PriceRuleViewModel!
    var selectedRule: PriceRule!
    var editOrAdd: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareEditingPanel()
        loadIndicator()
        // Do any additional setup after loading the view.
    }
    
    func loadIndicator(){
        networkIndicator = UIActivityIndicatorView(style: .large)
        networkIndicator.center = self.view.center
        self.view.addSubview(networkIndicator)
    }
    
    func prepareEditingPanel(){
        startDatePicler.minimumDate = Date()
        endDatePicker.minimumDate = Date()
        titleTextFileld.text = ""
        disountAmountTextField.text = ""
        
        if editOrAdd == "edit"{
            titleTextFileld.text = selectedRule.title
            startDatePicler.date = prepareDate(dateString: selectedRule.startsAt!)
            endDatePicker.date = prepareDate(dateString: selectedRule.endsAt!)
            disountAmountTextField.text = selectedRule.value
            if selectedRule.valueType == "fixed_amount" {
                typeSegmentedControl.selectedSegmentIndex = 1
            }else{
                typeSegmentedControl.selectedSegmentIndex = 0
            }
            usageLimitTextField.text = String(selectedRule.usageLimit ?? 0)
        }
    }
    
    @IBAction func DoneEditing(_ sender: Any) {
        if checkFieldsAreNotEmpty() {
            if checkDatesAreInTheRightOrder(){
                if usageLimitIsInt(){
                    if segmentedControlMatchesAmount(){
                        setRuleData()
                        saveRuleToCloud()
                    }
                }
            }
        }
    }
    
    func checkFieldsAreNotEmpty() -> Bool {
        if titleTextFileld.text == "" || disountAmountTextField.text == "" || usageLimitTextField.text == ""{
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.emptyFields)
            return false
        }else{
            return true
        }
    }
    
    func checkDatesAreInTheRightOrder() -> Bool {
        if startDatePicler.date >= endDatePicker.date {
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.wrongDateOrder)
            return false
        }else{
            return true
        }
    }
    
    func usageLimitIsInt() -> Bool {
        if Int(usageLimitTextField.text!) != nil {
            return true
        }else{
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.wrongUsageLimitNumber)
            return false
        }
    }
    
    func segmentedControlMatchesAmount() -> Bool {
        if Double(disountAmountTextField.text!) == nil {
            CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.wrongAmountNumber)
            return false
        }
        
        if typeSegmentedControl.selectedSegmentIndex == 0{
            if Double(disountAmountTextField.text!)! > 100 {
                CustomAlerts.presentAlert(vc: self, title: Constants.error, message: Constants.wrongPercentage)
                return false
            }
            else{
                return true
            }
        }else{
            return true
        }
    }
    
    func setRuleData(){
        selectedRule.title = titleTextFileld.text
        selectedRule.usageLimit = Int(usageLimitTextField.text!)
        if Double(disountAmountTextField.text!)! <= 0 {
            selectedRule.value = disountAmountTextField.text
        }else{
            selectedRule.value = String(Double(disountAmountTextField.text!)! * -1)
        }
        selectedRule.startsAt = startDatePicler.date.iso8601
        selectedRule.endsAt = endDatePicker.date.iso8601
        if typeSegmentedControl.selectedSegmentIndex == 0{
            selectedRule.valueType = "percentage"
        }else{
            selectedRule.valueType = "fixed_amount"
        }
    }
    
    func saveRuleToCloud(){
        networkIndicator.startAnimating()
        if editOrAdd == "add" {
            priceRuleViewModel.addPriceRule(priceRule: selectedRule) { [weak self] rule in
                self?.selectedRule = rule
                self?.networkIndicator.stopAnimating()
                self?.navigationController?.popViewController(animated: true)
            }
        }
        else{
            priceRuleViewModel.updatePriceRule(priceRule: selectedRule) { [weak self] rule in
                self?.selectedRule = rule
                self?.networkIndicator.stopAnimating()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func prepareDate(dateString: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:dateString)!
        return date
    }
}
