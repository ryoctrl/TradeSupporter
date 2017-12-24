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
  
    func get(_ completion: @escaping (JSON) -> Void){
        //let URL = baseURL + "/xrp_jpy/candlestick/1hour/20171224"
        let URL = baseURL + "/btc_jpy/candlestick/5min/20171224"
        Alamofire.request(URL).responseJSON { response in
            guard let obj = response.result.value else { return }
            completion(JSON(obj))
        }
    }
}
