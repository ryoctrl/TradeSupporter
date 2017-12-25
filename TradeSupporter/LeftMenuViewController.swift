//
//  LeftMenuViewController.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController {

    var mainView: ViewController?
    
    
    @IBOutlet weak var keyCoinSelector: UISegmentedControl!
    @IBOutlet weak var valCoinSelector: UISegmentedControl!
    @IBOutlet weak var intervalSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = ViewController.shared
        selectorSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func selectorSetup() {
        let keys = Const.PubNub_BitBank["Pairs"] as! [String:Any]
        keyCoinSelector.changeAllSegmentWithArray(arr: [String](keys.keys.sorted()), initialize: true)
        keyCoinSelector.selectedSegmentIndex = 1
        valCoinSelector.changeAllSegmentWithArray(arr: ["JPY"], initialize: true)
        let intervalKeys = Const.PubNub_BitBank["intervals"] as! [String:String]
        intervalSegmentSetting(Utilities.sortIntervales([String](intervalKeys.keys)))
    }
    
    //通貨ペアの基本通貨選択
    @IBAction func keyCoinChanged(_ sender: UISegmentedControl) {
        let selectedCoin = sender.titleForSegment(at: sender.selectedSegmentIndex)
        var values = Const.PubNub_BitBank["Pairs"] as! [String:Any]
        values = values[selectedCoin!] as! [String:String]
        valCoinSelector.changeAllSegmentWithArray(arr: [String](values.keys.sorted()), initialize: true)
        ViewController.shared!.setPairs(values[valCoinSelector.titleForSegment(at: valCoinSelector.selectedSegmentIndex)!] as! String)
    }
    
    //通貨ペアの代替通貨選択
    @IBAction func valCoinChanged(_ sender: UISegmentedControl) {
        let selectedValCoin = sender.titleForSegment(at: sender.selectedSegmentIndex)
        let selectedKeyCoin = keyCoinSelector.titleForSegment(at: keyCoinSelector.selectedSegmentIndex)
        var values = Const.PubNub_BitBank["Pairs"] as! [String:Any]
        values = values[selectedKeyCoin!] as! [String:String]
        ViewController.shared!.setPairs(values[selectedValCoin!] as! String)
    }
    
    func intervalSegmentSetting(_ intervals: [String: [String]]) {
        intervalSelector.removeAllSegments()
        intervalSelector.changeAllSegmentWithArray(arr: (intervals["minutes"]?.sorted())!)
        intervalSelector.changeAllSegmentWithArray(arr: (intervals["hours"]?.sorted())!)
        intervalSelector.changeAllSegmentWithArray(arr: (intervals["days"]?.sorted())!)
        intervalSelector.changeAllSegmentWithArray(arr: (intervals["weeks"]?.sorted())!)
    }
}

extension UISegmentedControl {
    func changeAllSegmentWithArray(arr: [String], initialize: Bool = false){
        if initialize {
            self.removeAllSegments()
        }
        for i in 0..<arr.count {
            self.insertSegment(withTitle: arr[i], at: numberOfSegments, animated: false)
        }
        
        self.selectedSegmentIndex = 0
    }
    
}
