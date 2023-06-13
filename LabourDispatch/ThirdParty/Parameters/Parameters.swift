//
//  Parameters.swift
//  KamCash
//
//  Created by Apple on 16/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit





// MARK:- LOGIN PARAMS -
struct LoginParam: Encodable {
    let action: String
    let email: String
    let password: String
    let deviceToken: String
    let device: String
}

// MARK:- LOGIN PARAMS -
struct LoginParamViaUsername: Encodable {
    let action: String
    let username: String
    let password: String
    let deviceToken: String
    let device: String
}

// MARK:- USER -
struct ShopNowParam: Encodable {
    let action: String
}

// product details
struct ShopProductDetails: Encodable {
    let action: String
    let categoryId: String
    let keyword: String
}

// address list
struct AddressList: Encodable {
    let action: String
    let userId: String
    
}

// carts
struct CartList: Encodable {
    let action: String
    let userId: String
    
}

// add to cart
 struct AddToCart: Encodable {
    let action: String
    let userId: String
    let quantity: String
    let productId: String
 }

// delete cart
struct DeleteCart: Encodable {
   let action: String
   let userId: String
   let productId: String
}

/*
 action: updatesubscription
 userId:
 subscriptionId:
 amount:
 transactionId:
 */

struct MakeRegistrationForSeller: Encodable {
    let action: String
    let userId: String
    let subscriptionId: String
    let amount: String
    let transactionId: String
}

struct MyProductsList: Encodable {
    let action: String
    let userId: String
    let categoryId: String
    let pageNo: Int
}


// make payment
struct MakePaymentOfOrders: Encodable {
    let action: String
    let userId: String
    let productDetails: String
    let totalAmount: String
    let ShippingName: String
    let ShippingAddress: String
    let ShippingCity: String
    let ShippingState: String
    let ShippingZipcode: String
    let ShippingPhone: String
    let transactionId: String
    let latitude: String
    let longitude: String
    let cardType: String
}

// order history
struct OrderHistory: Encodable {
    let action: String
    let userId: String
    let userType: String
}

// order history details
struct OrderHistoryDetails: Encodable {
   let action: String
   let purcheseId: String
}

// clear all cart
struct DeleteAllCartItems: Encodable {
   let action: String
   let userId: String
}

// clear all cart
struct ForgotPasswordWB: Encodable {
   let action: String
   let email: String
}

// help
struct HelpWB: Encodable {
   let action: String
}

// add new address
struct AddNewAddress: Encodable {
    let action: String
    let userId: String
    let firstName: String
    let lastName: String
    let mobile: String
    let address: String
    let addressLine2: String
    let City: String
    let state: String
    let country: String
    let Zipcode: String
    let deliveryType: String
}

// edit address
struct CountryList: Encodable {
    let action: String
}

// edit address
struct EditAddress: Encodable {
    let action: String
    let userId: String
    let addressId: String
    let firstName: String
    let lastName: String
    let mobile: String
    let address: String
    let addressLine2: String
    let City: String
    let state: String
    let country: String
    let Zipcode: String
    let deliveryType: String
}

// delete this address
struct DeleteThisAddress: Encodable {
    let action: String
    let userId: String
    let addressId: String
}

// edit user without image
struct EditUserWithoutImage: Encodable {
    let action: String
    let userId: String
    let fullName: String
    let contactNumber: String
    let address: String
}

// edit user without image
struct EditUserWithImage: Encodable {
    let action: String
    let userId: String
    let fullName: String
    let contactNumber: String
    let address: String
}

// change password
struct ChangePasswordW: Encodable {
    let action: String
    let userId: String
    let oldPassword: String
    let newPassword: String
}

// locations
struct Locations: Encodable {
    let action: String
}



// upload documen
struct UploadDocumentPhotoId: Encodable {
    let action: String
    let userId: String
}

// DRIVER
struct DriverPuchaseList: Encodable {
    let action: String
    let userId: String
    let userType: String
    let status: String
}

// DRIVER success fully delivered
struct SuccessfullyDelivered: Encodable {
    let action: String
    let driverId: String
    let bookingId: String
    let status: String
    let message: String
}

// DRIVER booking history
struct BookingHistory: Encodable {
    let action: String
    let userId: String
    let userType: String
    let status: String
}

struct FullRegistration: Encodable {
    let action: String
    let username: String
    let email: String
    let password: String
    let contactNumber: String
    let device: String
    let deviceToken: String
    let role: String
    let fullName: String
    let address: String
}


// customer order search
struct CustomerSearch: Encodable {
    let action: String
    let categoryId: String
    let keyword: String
}

// customer order search
struct MembershipSub: Encodable {
    let action: String
}

// customer order search
struct ProfileCheck: Encodable {
    let action: String
    let userId: String
}

// customer order search
struct AddProductCategory: Encodable {
    let action: String
    let pageNo: String
}

// edit address
struct EditRegsitration: Encodable {
    let action: String
    let userId: String
    let country: String
    let NoOfProduct: String
    let StoreTime: String
    let contactNumber: String
}

/*
 [action] => addproduct
     [userId] => 121
     [productName] => one test
     [price] => 500
     [specialPrice] => 490
     [description] => dhfj
     [SKU] => heg
     [quantity] => 5
     [URL] => hdhdh
     [categoryId] => 2
     [subCategoryId] => 5
 */


// make payment
struct SellerAddProductWithoutImage: Encodable {
    let action: String
    let userId: String
    let productName: String
    let price: String
    let specialPrice: String
    let description: String
    let SKU: String
    let quantity: String
    let URL: String
    let categoryId: String
    let subCategoryId: String
    
}


// make payment
struct SellerEditProductWithoutImage: Encodable {
    let action: String
    let userId: String
    let productId: String
    let productName: String
    let price: String
    let specialPrice: String
    let description: String
    let SKU: String
    let quantity: String
    let URL: String
    let categoryId: String
    let subCategoryId: String
    
}

// edit product
struct EditPublishedProduct: Encodable {
    let action: String
    let productId: String
    let status: String
}


// logout
struct LogoutFromApp: Encodable {
    let action: String
    let userId: String
}


class Parameters: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
