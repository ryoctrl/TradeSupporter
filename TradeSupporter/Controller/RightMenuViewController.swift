//
//  RightMenuViewController.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/28.
//  Copyright © 2017年 mosin. All rights reserved.
//

import UIKit
import SwiftyJSON

class RightMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    static var sharedInstance: RightMenuViewController?
   
    @IBOutlet weak var informationList: UITableView!
    
    var amountDatas: [[String:String]] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAmounts()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RightMenuViewController.sharedInstance = self
        
        let nib = UINib(nibName: "InformationCell", bundle: nil)
        informationList.register(nib, forCellReuseIdentifier: "informationCell")
        informationList.delegate = self
        informationList.dataSource = self
        informationList.isScrollEnabled = false
        informationList.layoutMargins = UIEdgeInsets.zero
        
        getAmounts()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAmounts() {
        func completion(_ obj: JSON) -> Void{
            let datas: JSON = obj["data"]["assets"]
            amountDatas.removeAll()
            datas.forEach{ (_, data) in
                var currencyPair: [String:String] = [:]
                currencyPair["name"] = data["asset"].string!
                currencyPair["amount"] = data["onhand_amount"].string!
                amountDatas.append(currencyPair)
                if currencyPair["name"] == "jpy" {
                    setFiatToApplication(currencyPair["amount"]!)
                }
            }
            informationList.reloadData()
        }
        BitBankAPI.sharedInstance.getWithAuth("assets", completion)
    }
    
    private func setFiatToApplication(_ price: String) {
        StaticValues.fiat = Double(price)!
        ViewController.shared!.fiatLabel.text = String(StaticValues.fiat)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return amountDatas.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "informationCell", for: indexPath) as! InformationCell
        cell.titleLabel.text = amountDatas[indexPath.row]["name"]
        cell.contentLabel.text = amountDatas[indexPath.row]["amount"]
        cell.frame.size.width = informationList.frame.width
        cell.layoutMargins = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.informationList.cellForRow(at: indexPath) as! InformationCell
        
        informationList.deselectRow(at: indexPath, animated: true)
    }
    

}
