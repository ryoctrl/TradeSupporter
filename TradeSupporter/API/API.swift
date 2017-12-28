//
//  API.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol API {
    var baseURL: String {get}
    var pairs: String{get set}
    var interval: String{get set}
    
    func setPairs(pair: String)
    func setInterval(_ interval: String)
    func constructURL() -> String
    func get(_ completion: @escaping (JSON) -> Void)
    func getWithAuth(_ key: String, _ completion: @escaping (JSON) -> Void)
    func postWithAuth(_ key: String, _ postJson: Parameters, _ completion: @escaping(JSON) -> Void)
    func order(_ pair: String,
               _ amount: String,
               _ price: String,
               _ buyType: Bool,
               _ completion: @escaping(JSON) -> Void)
}
