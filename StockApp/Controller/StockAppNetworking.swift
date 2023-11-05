//
//  StockAppNetworking.swift
//  StockApp
//
//  Created by Shengjie Mao on 10/28/23.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

func getAllStockQuotes(symbols: [String]) -> Promise<[StockClass]> {
    
    var promises: [Promise<StockClass>] = []
    for i in 0 ... symbols.count - 1 {
        promises.append(getStockInfoShort(symbol: symbols[i]))
    }
    return when(fulfilled: promises)
}

func getStockInfoShort(symbol: String) -> Promise<StockClass>{
    return Promise<StockClass> { seal -> Void in
        let url = "\(baseURL)/\(symbol)?apikey=\(apiKey)"
        AF.request(url).responseJSON { response in
            if(response.error != nil){
                seal.reject(response.error!)
            }
            // We have valid data here
            guard let rawData = response.data else {return}
            guard let jsonArray = JSON(rawData).array else {return}
            guard let stock = jsonArray.first else {return}
            let symbol = stock["symbol"].stringValue
            let price = stock["price"].floatValue
            let change = stock["change"].floatValue
            
            let stockQuoteShort = StockClass()
            stockQuoteShort.symbol = symbol
            stockQuoteShort.price = price
            stockQuoteShort.change = change

            seal.fulfill(stockQuoteShort)
        }
    }
}

func getStockInfo(symbol : String) -> Promise<StockClass> {
    
    return Promise<StockClass> {seal -> Void in
        let url = "\(baseURL)profile/\(symbol)?apikey=\(apiKey)"
        AF.request(url).responseJSON { response in
            
            if(response.error != nil){
                seal.reject(response.error!)
            }
            
            // We have valid data here
            guard let rawData = response.data else {return}
            guard let jsonArray = JSON(rawData).array else {return}
            guard let stock = jsonArray.first else {return}
            
            let symbol = stock["symbol"].stringValue
            let price = stock["price"].floatValue
            let companyName = stock["companyName"].stringValue
            let description = stock["description"].stringValue
            let change = stock["change"].floatValue
            
            let stockClass = StockClass()
            stockClass.symbol = symbol
            stockClass.price = price
            stockClass.companyName = companyName
            stockClass.companyDescription = description
            stockClass.change = change
            
            seal.fulfill(stockClass)
        }
    }
}
