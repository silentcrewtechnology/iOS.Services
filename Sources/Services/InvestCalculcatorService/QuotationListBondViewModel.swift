//
//  QuotationListBondViewModel.swift
//  
//
//  Created by user on 25.04.2024.
//

import Foundation

struct QuotationListBondViewModel {
    var instrumentId: Int
    var name: String
    var price: Decimal
    var currency: String
    var imageUrl: URL?
    var yieldToMaturity: Decimal
    var priceInPercent: Decimal
    var isin: String
    var maturityDate: String
    var couponRate: Decimal
    var nextCouponDate: String
}
