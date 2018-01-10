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
    
    var pubNubController: PubNubController!
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
    
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var fiatLabel: UILabel!
    
    @IBAction func autoPricingSelectChanged(_ sender: UISegmentedControl) {
        if !autoPricingSwitch.isOn { return }
        
        //瞬時に価格を変更
        if sender.selectedSegmentIndex == SELL_AUTO_PRICING { priceTextField.text = higherSellPrice }
        else { priceTextField.text = lowerBuyPrice}
    }
    
    var priceTextFieldInitialized = false
    @IBAction func orderButtonPushed(_ sender: Any) {
        if (amountTextField.text == "") { return }
        
        let alertController = UIAlertController(title: "Confirm", message:"購入確認画面 (デバッグモードにつき機能削除中)", preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in
            let price = self.priceTextField.text
            let amount = self.amountTextField.text
            var buyOrder = true
            if self.autoPricingSelect.selectedSegmentIndex == self.SELL_AUTO_PRICING {
                buyOrder = false
            }
            
            func completion(_ obj: JSON) -> Void {
                self.amountTextField.text = ""
                RightMenuViewController.sharedInstance!.getAmounts()
            }
            //self.api.order(StaticValues.selectingPair, amount!, price!, buyOrder, completion)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBOutlet weak var orderButton: UIButton!
    
    let api: API = BitBankAPI.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.shared = self
        self.pubNubController = PubNubController.sharedInstance
        
        apiSetup()
        labelFieldTextInitialize()
        navigationBarSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //ナビゲーションバー関連
    func navigationBarSetup() {
        //addLeftBarButtonWithImage(UIImage(named: "menu")!)
        setNavigationbarTitle("BTC/JPY")
        navigationController?.navigationBar.isTranslucent = false
    }
    
    //ナビゲーションバーに表示するタイトル(通貨ペア名)
    private func setNavigationbarTitle(_ title: String) {
        navigationController?.navigationBar.topItem!.title = title
    }
    
    func labelFieldTextInitialize() {
        fiatLabel.text = "0"
        paymentLabel.text = "0"
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
        api.getCandle(comp)
    }
    
    func updateLatestChart(data: Any) {
        let message = data as! [String:Any]
        let data = message["data"] as! NSDictionary
        let datas = data.object(forKey: "candlestick") as! [NSDictionary]
        datas.forEach({ data in
            if data.object(forKey: "type") as! String == api.interval {
                let ohlcv = (data.object(forKey: "ohlcv") as! NSArray)[0] as! NSArray
                let timestamp = ohlcv[ohlcv.count - 1]
                //print(type(of: timestamp), String(timestamp))
                let latestTimestamp = ViewController.chartTimestamps[self.entries.count -  1]
                print(Utilities.responseToUnixtime(String(describing: timestamp)), latestTimestamp)
            }
        })
        
        
        //self.entries.popLast()
        //chartSetup()
        //self.entries.append(CandleChartDataEntry(x: Double(count), shadowH))
    }
    //選択中通貨ペアの価格自動設定
    func updateOrderPrice(data: Any) {
        let message = data as! [String: Any]
        let data = message["data"] as! NSDictionary
        
        self.higherSellPrice = data[HIGHER_SELL] as! String
        self.lowerBuyPrice = data[LOWER_BUY] as! String
        
        if !autoPricingSwitch.isOn { return }
        
        if autoPricingSelect.selectedSegmentIndex == SELL_AUTO_PRICING { priceTextField.text = higherSellPrice }
        else { priceTextField.text = lowerBuyPrice }
    }
    
    //JSONにて自動価格入力を実行する
    func updateOrderPriceWithJSON(obj: JSON) {
        let data = obj["data"]
        
        self.higherSellPrice = data[HIGHER_SELL].stringValue
        self.lowerBuyPrice = data[LOWER_BUY].stringValue
        
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
                print(Int(value), ViewController.chartTimestamps.count)
                let date = Date(timeIntervalSince1970: ViewController.chartTimestamps[Int(value)])
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
            }
        }
        chartView.xAxis.valueFormatter = customFormatter()
        //chartView.xAxis.axisMaximum = Double(self.entries.count - CHART_NUM)
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
    
    //通貨ペアの選択
    func setPairs(_ pairs: String) {
        StaticValues.selectingPair = pairs
        pubNubController.changeSubscribingCurrencyPair()
        func comp(obj: JSON) -> Void {
            updateOrderPriceWithJSON(obj: obj)
        }
        api.get("ticker", comp)
        setNavigationbarTitle(pairs.replacingOccurrences(of: "_", with: "/").uppercased())
        chartView.data!.clearValues()
        apiSetup()
    }
    
    //チャートに表示する時間足
    func setInterval(_ interval: String) {
        api.setInterval(interval)
        chartView.data!.clearValues()
        apiSetup()
    }
    
    //金額と数量の入力内容変更
    @IBAction func textChanged(_ sender: Any) {
        if amountTextField.text != "" && priceTextField.text != "" {
            let amount = Double(amountTextField.text!)
            let price = Double(priceTextField.text!)
            paymentLabel.text = String(amount! * price!)
        } else {
            paymentLabel.text = "0"
        }
    }
    
    
    //キーボードを画面タッチで隠す
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
}
