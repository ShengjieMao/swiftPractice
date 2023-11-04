//
//  ViewController.swift
//  StockApp
//
//  Created by Shengjie Mao on 10/21/23.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stocksArray: [StockClass] = [StockClass]()
    var stocksArrayShort: [StockQuoteShort] = [StockQuoteShort]()

    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStockValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadStockValues()
    }

    
    func loadStockValues(){
        // read values from Local DB and populate the Table
        do {
            stocksArray = [StockClass]()
            let realm = try Realm()
            let stocks = realm.objects(StockClass.self)
            //print(stocks)
            
            var stockSymbols: [String] = [String]()
            for stock in stocks{
                //stocksArray.append(stock)
                stockSymbols.append(stock.symbol)
                //getAllStockQuotes(symbols: <#T##[String]#>)
            }
            getAllStockQuotes(symbols: stockSymbols)
                .done { stockQuotes in
                    for stockQuote in stockQuotes{
                        print("\(stockQuote.symbol) \(stockQuote.price)")
                    }
                    self.tblView.reloadData()
                }
                
            //tblView.reloadData()
            
        }catch{
            print("error in reading from Realm \(error)")
        }
    }
    
    // *************some stocksArray here need to be changed to stocks stocksArrayShort ******************//
    // *************                                                                     *************    //
    // *************                  in tabelView                                       *************    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stocksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let symbol = stocksArray[indexPath.row].symbol
        let price = String(format: "%.2f", stocksArray[indexPath.row].price)
        cell.textLabel?.text = "\(symbol) : \(price) $"
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteFromRealDB(stocksArray[indexPath.row])
            stocksArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func deleteFromRealDB(_ stock : StockClass){
        do{
            let realm = try Realm()
            try realm.write{
                realm.delete(stock)
            }
        }catch{
            print("Error in deleting \(error)")
        }
    }
}

