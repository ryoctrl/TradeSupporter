//
//  API.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol API {
    var baseURL: String {get}
    func get(_ completion: @escaping (JSON) -> Void)
}
