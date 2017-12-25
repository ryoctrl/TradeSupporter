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
    
  
    func setPairs(pair: String) {
        self.pairs = pair
    }
    
    func get(_ completion: @escaping (JSON) -> Void){
        //let URL = baseURL + "/btc_jpy/candlestick/5min/20171224"
        let URL = constructURL()
        Alamofire.request(URL).responseJSON { response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
    }
    
    //APIのエンドポイントURLの組み立て
    //ToDo: ロウソク足と足感覚と日付を動的にしてx
    func constructURL() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        let day = dateFormatter.string(from: Date(timeInterval: -60 * 60 * 9, since: Date())).replacingOccurrences(of: "/", with: "")

        let URL: String = baseURL + "/" + pairs + "/candlestick/5min/" + day
        return URL
    }
}
