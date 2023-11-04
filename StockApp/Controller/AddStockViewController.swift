//
//  AddStockViewController.swift
//  StockApp
//
//  Created by Shengjie Mao on 10/21/23.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class AddStockViewController: UIViewController {

    @IBOutlet weak var txtStock: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addStockAction(_ sender: Any) {
        guard let stockSymbol = txtStock.text else {return}
        
        getStockInfo(symbol: stockSymbol).done{ stockClass in
            print(stockClass)
            do {
                let realm = try Realm()
                //print(realm.configuration.fileURL) //check where the file stored, find in finder by cmd+shift+G & paste url to the box
                try realm.write({
                    realm.add(stockClass, update: .modified)
                })
                self.navigationController?.popViewController(animated: true)
                
            }
            catch {
                print("Error in adding data to the Realm DB \(error)");
            }
        }
        .catch { error in
            print("Unable to get stock value \(error)")
        }
        
    }
}
