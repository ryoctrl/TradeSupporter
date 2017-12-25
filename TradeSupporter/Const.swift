//
//  Const.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/25.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation

struct Const {
    static let PubNub_BitBank: [String:Any] = [
        "SubscribeKey": "sub-c-e12e9174-dd60-11e6-806b-02ee2ddab7fe",
        "ticker_xrp_jpy": "ticker_xrp_jpy",
        "chart_xrp_jpy": "candlestick_xrp_jpy",
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
            "1w": "1day"
        ]
    ]
}
