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
    var baseURL: String = "https://public.bitbank.cc"
    var pairs: String = "btc_jpy"
    var interval: String = "5min"
    
  
    func setPairs(pair: String) {
        self.pairs = pair
    }
    
    func setInterval(_ interval: String) {
        self.interval = interval
    }
    
    func get(_ completion: @escaping (JSON) -> Void){
        let URL = constructURL()
        Alamofire.request(URL).responseJSON { response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
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

        //ToDo:Builder作るべきかと。
        let URL: String = baseURL + "/" + pairs + "/candlestick/" + interval + "/" + day
        return URL
    }
}
