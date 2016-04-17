//
//  Quote.swift
//  SwiftFighter
//
//  Created by Brian Williams on 4/9/16.
//  Copyright © 2016 RL. All rights reserved.
//

import Foundation

var formatter = NSDateFormatter.init()
var formatterInit = false

class Quote
{
    var venue : String = ""
    var symbol : String = ""
    
    var bid : Int = 0
    var bidSize : Int = 0
    var bidDepth : Int = 0
    
    var ask : Int = 0
    var askSize : Int = 0
    var askDepth : Int = 0
    
    var lastPrice : Int = 0
    var lastSize : Int = 0
    var lastTrade : String = ""
    var quoteTime : NSDate?
    
    
    init (json : NSDictionary)
    {
        if (!formatterInit)
        {
            formatterInit = true
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            formatter.locale = NSLocale.init(localeIdentifier: "en_US_POSIX")
        }
        
        var jsonObject = json["\(dictionaryKeys.symbol)"]
        if let symbol = jsonObject as? String
        {
            self.symbol = symbol
        }
            
        jsonObject = json["\(dictionaryKeys.venue)"]
        if let venue = jsonObject as? String
        {
            self.venue = venue
        }
            
        jsonObject = json["\(dictionaryKeys.bid)"]
        if let bid = jsonObject as? Int
        {
            self.bid = bid
        }
        
        jsonObject = json["\(dictionaryKeys.ask)"]
        if let ask = jsonObject as? Int
        {
            self.ask = ask
        }
        
        jsonObject = json["\(dictionaryKeys.bidSize)"]
        if let bidSize = jsonObject as? Int
        {
            self.bidSize = bidSize
        }

        jsonObject = json["\(dictionaryKeys.askSize)"]
        if let askSize = jsonObject as? Int
        {
            self.askSize = askSize
        }
        
        jsonObject = json["\(dictionaryKeys.bidDepth)"]
        if let bidDepth = jsonObject as? Int
        {
            self.bidDepth = bidDepth
        }
        
        jsonObject = json["\(dictionaryKeys.askDepth)"]
        if let askDepth = jsonObject as? Int
        {
            self.askDepth = askDepth
        }
        
        jsonObject = json["\(dictionaryKeys.last)"]
        if let lastPrice = jsonObject as? Int
        {
            self.lastPrice = lastPrice
        }
            
        jsonObject = json["\(dictionaryKeys.lastSize)"]
        if let lastSize = jsonObject as? Int
        {
            self.lastSize = lastSize
        }
            
        jsonObject = json["\(dictionaryKeys.lastTrade)"]
        if let lastTrade = jsonObject as? String
        {
            self.lastTrade = lastTrade
        }

        jsonObject = json["\(dictionaryKeys.quoteTime)"]
        if let quoteTime = jsonObject as? String
        {
           self.quoteTime = formatter.dateFromString(quoteTime)
        }
    }
}
