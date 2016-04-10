//
//  Quote.swift
//  SwiftFighter
//
//  Created by Brian Williams on 4/9/16.
//  Copyright © 2016 RL. All rights reserved.
//

import Foundation


class Quote
{
    var symbol : String = ""
    var venue : String = ""
    var bid : Int = 0
    var ask : Int = 0
    var bidSize : Int = 0
    var askSize : Int = 0
    var bidDepth : Int = 0
    var askDepth : Int = 0
    var lastPrice : Int = 0
    var lastSize : Int = 0
    var lastTrade : String = ""
    var quoteTime : String = ""
    
    init (jsonDictionary : Dictionary <String, Any>)
    {
        self.symbol = String(jsonDictionary["\(dictionaryKeys.symbol)"])
        self.venue = String(jsonDictionary["\(dictionaryKeys.venue)"])

        if let bidValue = jsonDictionary["\(dictionaryKeys.bid)"] as? Int
        {
            self.bid = Int(bidValue)
        }
        
        if let askValue = jsonDictionary["\(dictionaryKeys.ask)"] as? Int
        {
            self.ask = Int(askValue)
        }
        
        if let bidSize = jsonDictionary["\(dictionaryKeys.bidSize)"] as? Int
        {
            self.bidSize = Int(bidSize)
        }
        
        if let askSize = jsonDictionary["\(dictionaryKeys.askSize)"] as? Int
        {
            self.askSize = Int(askSize)
        }
        
        if let bidDepth = jsonDictionary["\(dictionaryKeys.bidDepth)"] as? Int
        {
            self.bidDepth = Int(bidDepth)
        }
        
        if let askDepth = jsonDictionary["\(dictionaryKeys.askDepth)"] as? Int
        {
            self.askDepth = Int(askDepth)
        }
        
        if let lastPrice = jsonDictionary["\(dictionaryKeys.lastPrice)"] as? Int
        {
            self.lastPrice = Int(lastPrice)
        }
        
        if let lastSize = jsonDictionary["\(dictionaryKeys.lastSize)"] as? Int
        {
            self.lastSize = Int(lastSize)
        }
        
        if let lastTrade = jsonDictionary["\(dictionaryKeys.lastTrade)"] as? String
        {
            self.lastTrade = lastTrade;
        }
        
        if let quoteTime = jsonDictionary["\(dictionaryKeys.quoteTime)"] as? String
        {
            self.quoteTime = String(quoteTime);
        }
    }
}


//{ // the below is the same as returned through the REST quote API
//    "symbol": "FAC",
//    "venue": "OGEX",
//    "bid": 5100, // best price currently bid for the stock
//    "ask": 5125, // best price currently offered for the stock
//    "bidSize": 392, // aggregate size of all orders at the best bid
//    "askSize": 711, // aggregate size of all orders at the best ask
//    "bidDepth": 2748, // aggregate size of *all bids*
//    "askDepth": 2237, // aggregate size of *all asks*
//    "last": 5125, // price of last trade
//    "lastSize": 52, // quantity of last trade
//    "lastTrade": "2015-07-13T05:38:17.33640392Z", // timestamp of last trade,
//    "quoteTime": "2015-07-13T05:38:17.33640392Z" // server ts of quote generation
//}