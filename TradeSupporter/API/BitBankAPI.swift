//
//  BitBankAPI.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BitBankAPI: API {
    static let sharedInstance = BitBankAPI()
    
    private init() {
    }
    
    var baseURL: String = "https://public.bitbank.cc"
    var basePrivateURL: String = "https://api.bitbank.cc"
    var interval: String = "5min"

    func setInterval(_ interval: String) {
        self.interval = interval
    }
    
    func get(_ key: String, _ completion: @escaping (JSON) -> Void) {
        var URL = baseURL
        if key == "ticker" {
            URL += "/" + StaticValues.selectingPair + (Const.BitBank["ticker"] as! String)
        }
        Alamofire.request(URL).responseJSON{ response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
    }
    
    func getCandle(_ completion: @escaping (JSON) -> Void){
        let URL = constructURL()
        Alamofire.request(URL).responseJSON { response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
    }
    
    func getWithAuth(_ key: String, _ completion: @escaping (JSON) -> Void) {
        let path = Const.BitBank[key] as! String
        let nonce = Utilities.createUnixtimestamp()
        let seed = nonce + path
        let signature = Utilities.createSignature(seed, Const.SECRET_KEY)
        let URL = basePrivateURL + path
        let headers: HTTPHeaders = [
            "ACCESS-KEY": Const.TEST_APIKEY,
            "ACCESS-NONCE": nonce,
            "ACCESS-SIGNATURE": signature
        ]
        
        Alamofire.request(URL, headers: headers).responseJSON { response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
    }
    
    func postWithAuth(_ key: String, _ postJson: Parameters, _ completion: @escaping (JSON) -> Void) {
        let path = Const.BitBank[key] as! String
        var jsonStr: String = postJson.description
        jsonStr = jsonStr.replacingOccurrences(of: "[", with: "{")
        jsonStr = jsonStr.replacingOccurrences(of: "]", with: "}")
        jsonStr = jsonStr.replacingOccurrences(of: " ", with: "")
        let nonce = Utilities.createUnixtimestamp()
        let seed = nonce + jsonStr
        let signature = Utilities.createSignature(seed, Const.SECRET_KEY)
        let URL = basePrivateURL + path
        let headers: HTTPHeaders = [
            "ACCESS-KEY": Const.TEST_APIKEY,
            "ACCESS-NONCE": nonce,
            "ACCESS-SIGNATURE": signature
        ]
        
        Alamofire.request(URL, method: .post, parameters: postJson, encoding: JSONEncoding.default, headers: headers)
            .responseJSON{ response in
                print(response)
                guard let obj = response.result.value else { return }
                completion(JSON(obj))
        }
    }
    
    func order(_ pair: String, _ amount: String, _ price: String, _ buyType: Bool, _ completion: @escaping (JSON) -> Void) {
        var side = ""
        if buyType {
            side = "buy"
        } else {
            side = "sell"
        }
        //ToDo: amountをを変数に変更
        let postJson: Parameters = [
            "pair": pair,
            "amount": "1",
            "price": price,
            "side": side,
            "type": "limit"
        ]
        postWithAuth("order", postJson, completion)
    }
    
    //APIのエンドポイントURLの組み立て
    //ToDo: ロウソク足を動的にして
    func constructURL() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        var day = dateFormatter.string(from: Date(timeInterval: -60 * 60 * 9, since: Date())).replacingOccurrences(of: "/", with: "")
        
        //4時間足以上のチャートを表示する場合日付はYYYY、それ以外はYYYYMMDDで指定する。
        if (self.interval.contains("hour") || self.interval.contains("week") || self.interval.contains("day")) && self.interval != "1hour"{
            day = String(day.prefix(4))
        }
        
        let pairs = StaticValues.selectingPair

        //ToDo:Builder作るべきかと。
        let URL: String = baseURL + "/" + pairs + "/candlestick/" + interval + "/" + day
        return URL
    }
}
