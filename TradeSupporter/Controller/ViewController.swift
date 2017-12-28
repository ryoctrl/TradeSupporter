//
//  ViewController.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/24.
//  Copyright © 2017年 mosin. All rights reserved.
//

import UIKit
import PubNub
import Charts
import SwiftyJSON
import SlideMenuControllerSwift


class ViewController: UIViewController, UITextFieldDelegate {
    
    static var shared: ViewController?
    //チャート画面に表示する足の数
    let CHART_NUM = 75
    
    let HIGHER_SELL = "buy"
    let LOWER_BUY = "sell"
    
    let SELL_AUTO_PRICING = 0
    let BUY_AUTO_PRICING = 1
    
    var higherSellPrice = ""
    var lowerBuyPrice = ""
    
    @IBOutlet weak var chartView: CandleStickChartView!
    @IBOutlet weak var controllView: UIView!
    
    @IBOutlet weak var autoPricingSwitch: UISwitch!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var autoPricingSelect: UISegmentedControl!
    
    @IBAction func autoPricingSelectChanged(_ sender: UISegmentedControl) {
        if !autoPricingSwitch.isOn { return }
        
        //瞬時に価格を変更
        if sender.selectedSegmentIndex == SELL_AUTO_PRICING { priceTextField.text = higherSellPrice }
        else { priceTextField.text = lowerBuyPrice}
    }
    
    var priceTextFieldInitialized = false
    @IBAction func orderButtonPushed(_ sender: Any) {
        if (amountTextField.text == "") { return }
        let price = priceTextField.text
        let amount = amountTextField.text
        var buyOrder = true
        if autoPricingSelect.selectedSegmentIndex == SELL_AUTO_PRICING {
            buyOrder = false
        }
        
        func completion(_ obj: JSON) -> Void {
            self.amountTextField.text = ""
            RightMenuViewController.sharedInstance!.getAmounts()
        }
        
        //ToDo: 通貨ペアを動的にすること
        let pair_test = "xrp_jpy"
        api.order(pair_test, amount!, price!, buyOrder, completion)
    }
    
    
    @IBOutlet weak var orderButton: UIButton!
    
    
    let api: API = BitBankAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
        
        pubNubSetup()
        apiSetup()
        /* Slide Menu */
        addLeftBarButtonWithImage(UIImage(named: "menu")!)
        //NavigationBarが半透明かどうか
        navigationController?.navigationBar.isTranslucent = false
        //NavigationBarの色を変更します
        //navigationController?.navigationBar.barTintColor = UIColor.cyan
        //NavigationBarに乗っている部品の色を変更します
        //navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem!.title = "BTC/JPY"
        //バーの左側にボタンを配置します(ライブラリ特有)
        //addLeftBarButtonWithImage(UIImage(named: "menu")!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    static var chartTimestamps: [Double] = []
    var entries: [CandleChartDataEntry] = []
    func apiSetup() {
        func comp(json: JSON) -> Void {
            ViewController.chartTimestamps = []
            self.entries = []
            let data = json["data"]["candlestick"][0]["ohlcv"]
            let margin = data.count > CHART_NUM ? CHART_NUM : data.count
            var count = 0
            for i in data.count-margin..<data.count {
                let xStr = data[i][5].stringValue
                ViewController.chartTimestamps.append(atof(String(xStr.prefix(xStr.characters.count - 3))))
                //let xStr = data[i][5].stringValue
                //let x = atof(String(xStr.prefix(xStr.characters.count - 3))) / 100//XAxis
                let shadowH = data[i][1].doubleValue//高値
                let shadowL = data[i][2].doubleValue //安値
                let open = data[i][0].doubleValue //始値
                let close = data[i][3].doubleValue //終値
                self.entries.append(CandleChartDataEntry(x: Double(count), shadowH: shadowH, shadowL: shadowL, open: open, close: close))
                count += 1
            }
            self.chartSetup()
        }
        api.get(comp)
    }
    
    func pubNubSetup() {
        let subscribes: [String] = [
//            Const.PubNub_BitBank["chart_xrp_jpy"]! as! String,
            Const.PubNub_BitBank["ticker_xrp_jpy"]! as! String
        ]
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let config = PNConfiguration(publishKey: Const.PubNub_BitBank["SubscribeKey"]! as! String, subscribeKey: Const.PubNub_BitBank["SubscribeKey"]! as! String)
        delegate.client = PubNub.clientWithConfiguration(config)
        delegate.client.addListener(delegate)
        delegate.client.subscribeToChannels(subscribes, withPresence: true)
    }
    
    func updateOrderPrice(data: Any) {
        let message = data as! [String: Any]
        let data = message["data"] as! NSDictionary
        
        self.higherSellPrice = data[HIGHER_SELL] as! String
        self.lowerBuyPrice = data[LOWER_BUY] as! String
        
        if !autoPricingSwitch.isOn { return }
        
        if autoPricingSelect.selectedSegmentIndex == SELL_AUTO_PRICING { priceTextField.text = higherSellPrice }
        else { priceTextField.text = lowerBuyPrice }
    }
    
    //shadowプロパティはヒゲを表す
    func chartSetup() {
        
        //ロウソク足のデータをset
        let set = CandleChartDataSet(values: self.entries, label: "XRP/JPY")
        chartView.data = CandleChartData(dataSet: set)
        
        //軸関連の表示設定
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.xAxis.labelPosition = .bottom
        //X軸の日付表示
        class customFormatter: IAxisValueFormatter {
            func stringForValue(_ value: Double, axis: AxisBase?) -> String {
                //let date = Date(timeIntervalSince1970: value * 100)
                let date = Date(timeIntervalSince1970: ViewController.chartTimestamps[Int(value)])
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
            }
        }
        chartView.xAxis.valueFormatter = customFormatter()
        //ロウソク足の表示設定
        set.drawValuesEnabled = false
        set.increasingColor = UIColor.green
        set.decreasingColor = UIColor.red
        set.shadowColorSameAsCandle = true
        set.increasingFilled = true
        set.shadowWidth /= 2
        //グラフ全体の表示設定
        chartView.chartDescription!.text = ""
        chartView.legend.enabled = false
    }
    
    func setPairs(_ pairs: String) {
        api.setPairs(pair: pairs)
        navigationController?.navigationBar.topItem!.title = pairs.replacingOccurrences(of: "_", with: "/").uppercased()
        chartView.data!.clearValues()
        apiSetup()
    }
    
    func setInterval(_ interval: String) {
        api.setInterval(interval)
        print(interval)
        chartView.data!.clearValues()
        apiSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
}
