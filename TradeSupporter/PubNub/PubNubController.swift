//
//  PubNubController.swift
//  TradeSupporter
//
//  Created by mosin on 2017/12/29.
//  Copyright © 2017年 mosin. All rights reserved.
//

import Foundation
import PubNub


class PubNubController {
    static let sharedInstance = PubNubController()
    var subscribingPair = StaticValues.selectingPair
    var client: PubNub!
    var delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    private init() {
        pubNubSetup()
    }
    
    func pubNubSetup() {
        let config = PNConfiguration(publishKey: Const.BitBank["SubscribeKey"]! as! String, subscribeKey: Const.BitBank["SubscribeKey"]! as! String)
        delegate.client = PubNub.clientWithConfiguration(config)
        delegate.client.addListener(delegate)
        addSubscribe()
    }
    
    func addSubscribe() {
        let pairTickerChannel = "ticker_" + subscribingPair
        let subscribes: [String] = [
            Const.BitBank["chart_xrp_jpy"]! as! String,
            //Const.BitBank[pairTickerChannel]! as! String
            pairTickerChannel
        ]        
        delegate.client.subscribeToChannels(subscribes, withPresence: true)
    }
    
    func changeSubscribingCurrencyPair(){
        let currentPairChannel = "ticker_" + subscribingPair
        delegate.client.unsubscribeFromChannels([currentPairChannel], withPresence: false)
        self.subscribingPair = StaticValues.selectingPair
        addSubscribe()
    }
}
