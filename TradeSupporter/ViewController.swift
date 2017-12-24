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


class ViewController: UIViewController {
    
    @IBOutlet weak var chartView: CandleStickChartView!
    @IBOutlet weak var controllView: UIView!
    
    //価格自動入力のON.OFF
    @IBAction func autoPricingSwitchAction(_ sender: UISwitch) {
        if sender.isOn {
            autoPricingSelect.isEnabled = true
        } else {
            autoPricingSelect.isEnabled = false
        }
    }
    
    @IBOutlet weak var autoPricingSelect: UISegmentedControl!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //pubNubSetup()
        apiSetup()
        title = "BTC/JPY"
        //chartSetup()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var entries: [CandleChartDataEntry] = []
    func apiSetup() {
        let api: API = BitBankAPI()
        func comp(json: JSON) -> Void {
            let data = json["data"]["candlestick"][0]["ohlcv"]
            //print(data.count)
            let numOfBars = 40
            let margin = data.count > numOfBars ? numOfBars : data.count
            for i in data.count-margin..<data.count {
                let xStr = data[i][5].stringValue
                let x = atof(String(xStr.prefix(xStr.characters.count - 3))) / 100//XAxis
                let shadowH = data[i][1].doubleValue//高値
                let shadowL = data[i][2].doubleValue //安値
                let open = data[i][0].doubleValue //始値
                let close = data[i][3].doubleValue //終値
                //print(x, shadowH, shadowL, open, close)
                self.entries.append(CandleChartDataEntry(x: x, shadowH: shadowH, shadowL: shadowL, open: open, close: close))
                self.chartSetup()
            }
            
        }
        api.get(comp)
    }
    
    func pubNubSetup() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let config = PNConfiguration(publishKey: Const.PubNub_BitBank["SubscribeKey"]! as! String, subscribeKey: Const.PubNub_BitBank["SubscribeKey"]! as! String)
        delegate.client = PubNub.clientWithConfiguration(config)
        delegate.client.addListener(delegate)
        delegate.client.subscribeToChannels([Const.PubNub_BitBank["chart_xrp_jpy"]! as! String], withPresence: true)
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
                //rint(value)
                let date = Date(timeIntervalSince1970: value * 100)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                //print(formatter.string(from: date))
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
}

