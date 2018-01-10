//
//  Const.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation

struct Const {
    //ToDo: 必ず削除
    static let TEST_APIKEY = ""
    static let SECRET_KEY = ""
    
    static let BitBank: [String:Any] = [
        "SubscribeKey": "sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe",
        "chart_xrp_jpy": "candlestick_xrp_jpy",
        "ticker": "/ticker",
        "assets":"/v1/user/assets",
        "order": "/v1/user/spot/order",
        "Pairs": [
            "BTC": ["JPY": "btc_jpy"],
            "XRP": ["JPY": "xrp_jpy"],
            "LTC": ["BTC": "ltc_btc"],
            "ETH": ["BTC": "eth_btc"],
            "MONA": ["JPY": "mona_jpy",
                     "BTC": "mona_btc"
            ],
            "BCH": ["JPY": "bcc_jpy",
                    "BTC": "bcc_btc"
            ]
        ],
        "intervals": [
            "1m": "1min",
            "5m": "5min",
            "15m": "15min",
            "30m": "30min",
            "1h": "1hour",
            "4h": "4hour",
            "8h": "8hour",
            "12h": "12hour",
            "1d": "1day",
            "1w": "1week"
        ],
        //""
    ]
    
    static let dialogues: [String:String] = [
        "0001": "確認"
    ]
}
