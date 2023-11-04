//
//  StockClass.swift
//  StockApp
//
//  Created by Shengjie Mao on 10/28/23.
//

import Foundation
import RealmSwift

class StockClass: Object {
    @objc dynamic var symbol: String = "" // use the bridging class that makes changes simutaneously
    @objc dynamic var price: Float = 0.0
    @objc dynamic var companyName: String = ""
    @objc dynamic var companyDescription: String = ""
    
    override static func primaryKey() -> String? {
        return "symbol"
    }
}
