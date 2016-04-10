//
//  AppDelegate.swift
//  SwiftFighter
//
//  Created by Brian Williams on 4/9/16.
//  Copyright © 2016 RL. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource
{
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var tableView: NSTableView!
    
    var apiKey : String = ""
    var quotes: Array<Quote> = []
    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        let path = NSBundle.mainBundle().pathForResource("apikey", ofType: "txt")!
        apiKey = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        // Insert code here to tear down your application
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = NSTableCellView.init(frame: NSMakeRect(0, 0, 100, 50))
        let quote = quotes[row]
        cell.textField?.stringValue = quote.symbol
        
        return cell
    }
    
    func openSocket ()
    {
        
    }
    
    func trade ()
    {
        let account = "WAR50459484"
        let venue = "IANBEX"
       // let stock = "UUHF"
        //IMOL IANBEX
        //var action = StockfighterPlaceOrder(account: account, venue: venue, stock:stock , price: 7900, quanity: 100, direction:TradeDirection.buy, orderType: TradeType.limit)
        //action.go()
        
        let ticker = StockfighterTicker(account: account, venue: venue)
        ticker.go()
    }
}

