//
//  StockfighterAction.swift
//  Stockfighter
//
//  Created by Brian Williams on 4/8/16.
//  Copyright © 2016 RL. All rights reserved.
//

import Foundation

enum dictionaryKeys : String
{
    case ok = "ok"
    case symbols = "symbols"
    case symbol = "symbol"
    case name = "name"
    case venue = "venue"
    case direction = "direction"
    case originalQty = "originalQty"
    
    case quote = "quote"
    case bids = "bids"
    case asks = "asks"
    case bid = "bid"
    case bidSize = "bidSize"
    case ask = "ask"
    case askSize = "askSize"
    case bidDepth = "bidDepth"
    case askDepth = "askDepth"
    
    case quantity = "qty"
    case price = "price"
    case orderType = "orderType"
    case orderId = "id"
    case account = "account"
    case timeStamp = "ts"
    case fills = "fills"
    case totalFilled = "totalFilled"
    case open = "open"
    case isBuy = "isBuy"
    
    case last = "last"
    case lastSize = "lastSize"
    case lastTrade = "lastTrade"
    case quoteTime = "quoteTime"
}

enum TradeDirection : String
{
    case buy = "buy"
    case sell = "sell"
}

enum TradeType : String
{
    case market = "market"
    case limit = "limit"
    case fillOrKill = "fill-or-kill"
    case immediateOrCancel = "immediate-or-cancel"
}

enum HTTPMetod : String
{
    case get = "GET"
    case post = "POST"
}

class StockfighterAction
{
    let baseUrl : NSURL = NSURL(string: "https://api.stockfighter.io")!
    var apiKey = ""
    var httpMethod = HTTPMetod.get
    
    func url() -> NSURL
    {
        return NSURL(string:"/ob/api/heartbeat/", relativeToURL: self.baseUrl)!
    }
    
    func params() -> Dictionary <String, AnyObject>?
    {
        return nil
    }
    
    func go()
    {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let request = NSMutableURLRequest(URL: self.url())
        
        request.HTTPMethod = "\(self.httpMethod)"
        
        if (request.HTTPMethod == "\(HTTPMetod.post)")
        {
            if let params = self.params()
            {
                do
                {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions())
                    
                    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                }
                catch
                {
                    print("Failed to create JSON body")
                }
            }
        }
        
        request.addValue(apiKey, forHTTPHeaderField:"X-Starfighter-Authorization")
        
        let task = session.dataTaskWithRequest(request)
        {
            data, response, error in
            
            if let httpResponse = response as? NSHTTPURLResponse
            {
                if httpResponse.statusCode != 200
                {
                    print("response was not 200: \(response)")
                    return
                }
            }
            
            if (error != nil)
            {
                print("error submitting request: \(error)")
                return
            }
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                
                print(result)
            }
            catch
            {
                print("error processing result")
            }
        }
        
        task.resume()
    }
}

class StockfighterPingVenue : StockfighterAction
{
    var account = ""
    var venue = ""
    
    init (account : String, venue : String)
    {
        super.init()
        
        self.account = account
        self.venue = venue
    }
    
    override func url() -> NSURL
    {
        return NSURL(string:"/ob/api/venues/\(self.venue)", relativeToURL: self.baseUrl)!
    }

}

class StockfighterGetOrderBook : StockfighterAction
{
    var venue = ""
    var stock = ""
    
    init (venue : String, stock : String)
    {
        super.init()
        
        self.venue = venue
        self.stock = stock
    }
    
    override func url() -> NSURL
    {
        return NSURL(string:"/ob/api/venues/\(self.venue)/stocks/\(self.stock)", relativeToURL: self.baseUrl)!
    }
}

class StockfighterPlaceOrder : StockfighterAction
{
    var account = ""
    var venue = ""
    var stock = ""
    var price = 0
    var quanity = 1
    var direction = TradeDirection.buy
    var orderType = TradeType.limit
    
    init (account : String, venue : String, stock : String, price : Int, quanity : Int, direction : TradeDirection, orderType : TradeType)
    {
        super.init()
        
        self.httpMethod = HTTPMetod.post
        self.account = account
        self.venue = venue
        self.stock = stock
        self.price = price
        self.quanity = quanity
        self.direction = direction
        self.orderType = orderType
    }
    
    override func url() -> NSURL
    {
        return NSURL(string:"/ob/api/venues/\(self.venue)/stocks/\(stock)/orders", relativeToURL: self.baseUrl)!
    }

    override func params() -> Dictionary <String, AnyObject>?
    {
        return [
            "\(dictionaryKeys.account)" : self.account,
            "\(dictionaryKeys.venue)": self.venue,
            "\(dictionaryKeys.symbol)" : self.stock,
            "\(dictionaryKeys.price)" : self.price,
            "\(dictionaryKeys.quantity)" : self.quanity,
            "\(dictionaryKeys.direction)" : "\(self.direction)",
            "\(dictionaryKeys.orderType)" : "\(self.orderType)"
        ]
    }
}

class StockfighterTicker : StockfighterAction
{
    var account = ""
    var venue = ""
    var stock = ""

    init (account : String, venue : String)
    {
        super.init()
        self.account = account
        self.venue = venue
    }
    
    func openSocket(messageProcessor:(data : Any)->())
    {
        let ws = WebSocket("wss://api.stockfighter.io/ob/api/ws/\(self.account)/venues/\(self.venue)/tickertape")
        
        ws.event.message = messageProcessor
        
        ws.event.error = { error in
             print(error)
        }
        
        ws.open()
    }
}

class StockfighterOrderBook : StockfighterAction
{
    var account = ""
    var venue = ""
    var stock = ""
    
    init (account : String, venue : String, stock : String)
    {
        super.init()
        self.account = account
        self.venue = venue
        self.stock = stock
    }
    
    func openSocket(messageProcessor:(data : Any)->())
    {
        let ws = WebSocket("wss://api.stockfighter.io/ob/api/ws/\(self.account)/venues/\(self.venue)/tickertape/stocks/\(self.stock)")
        
        ws.event.message = messageProcessor
        
        ws.event.error = { error in
            print(error)
        }
        
        ws.open()
    }
}


