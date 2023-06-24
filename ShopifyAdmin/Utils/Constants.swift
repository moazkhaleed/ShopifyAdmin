//
//  Constants.swift
//  ShopifyAdmin
//
//  Created by Moaz Khaled on 09/06/2023.
//

import Foundation


class Constants{
    
    static let location = 84874953013
    
    static let productTypes = ["ACCESSORIES","Shoes","T-SHIRTS"]
    
    
    
    static let error = "Error"
    static let warning = "Warning"
    static let ok = "OK"
    static let delete = "Delete"
    static let cancel = "Cancel"
    static let notice = "Notice"
    static let discard = "Discard"
    static let save = "Save"

    static let emptyFields = "Please fill all fields"

    static let wrongDateOrder = "Start date can't come after the end date"
    static let wrongUsageLimitNumber = "Please enter proper limit number"
    static let wrongAmountNumber = "Please enter proper discount amount number"
    static let wrongMinimumSubtotalNumber = "Please enter proper subtotal amount number"
    static let wrongPercentage = "Percentage can't be above 100"
    static let wrongDiscountToSubtotal = "Discount amount can't be more than the subtotal amount"
    
    
    static let confirmDeleteProduct = "Are you sure you want to delete this product?"
    static let confirmDeleteRule = "Are you sure you want to delete this price rule?"

    
    static let pencilEditImage = "pencil.line"
    static let trashEditImage = "trash"
    
    static let enterImageURL = "Please enter image URL"
    static let duplicatedImage = "This image is already available"
    static let atLeastOneImage = "Please add at least one image"
    static let atLeastOneVariant = "Please enter at least one variant"
    static let wrongPriceOrQuantity = "Wrong input for price or quantity"
    
    static let imageHandlingQuery = "This image hasn't been saved yet \n click Discard to discard image and continue \n click save image to save the image and continue \n click cancel to cancel"
    
    
    static let size = "Size"
    static let color = "Color"
    
    static let duplicatedVariant = "This variant is already available"
    static let enterValidPrice = "Please enter a valid price"
    static let enterValidQuantity = "Please enter a valid quantity number"
    static let validPrice = "Please enter valid Price"
    static let variantHandlingQuery = "This variant hasn't been saved yet \n click Discard to discard variant and continue \n click save to save the variant and continue \n click cancel to cancel"
    
}
