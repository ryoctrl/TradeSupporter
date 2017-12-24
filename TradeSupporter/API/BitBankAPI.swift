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
        let pairs = Const.PubNub_BitBank["Pairs"] as! [String: String]
        //ToDo: btc_jpyの決め打ちはナンセンスでは？
        self.pairs = pairs.keys.contains(pair) ? pairs[pair]! : "btc_jpy"
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
    //ToDo: ロウソク足と足感覚と日付を動的にして
    func constructURL() -> String {
        let URL: String = baseURL + "/" + pairs + "/candlestick/1hour/20171224"
        return URL
    }
}
