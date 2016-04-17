//
//  AppDelegate.swift
//  SwiftFighter
//
//  Created by Brian Williams on 4/9/16.
//  Copyright © 2016 RL. All rights reserved.
//

import Cocoa
import PlotKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSTableViewDelegate, NSTableViewDataSource
{
    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var plotView: PlotView!
    
    var apiKey : String = ""
    var quotes: Array<Quote> = []
    
    let account = "IYK11423813"
    let venue = "BHKTEX"
    let stock = "OCGI"
    
    func applicationDidFinishLaunching(aNotification: NSNotification)
    {
        
        let nib = NSNib(nibNamed: "StockCellView", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib!, forIdentifier: "StockCellView")
        
        let path = NSBundle.mainBundle().pathForResource("apikey", ofType: "txt")!
        apiKey = try! String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        
        createAxes()
        
        openSocket()
    }

    func applicationWillTerminate(aNotification: NSNotification)
    {
        // Insert code here to tear down your application
    }
    
    let π = M_PI
    let font = NSFont(name: "Optima", size: 16)!
    func createAxes() {

        var xaxis = Axis(orientation: .Horizontal, ticks: .Fit(10))
        xaxis.position = .Value(0)
        xaxis.labelAttributes = [NSFontAttributeName: font]
        plotView.addAxis(xaxis)
        
        var yaxis = Axis(orientation: .Vertical, ticks: .Fit(4))
        yaxis.labelAttributes = [NSFontAttributeName: font]
        plotView.addAxis(yaxis)
    }
    
    func createPlot()
    {
        var bid : Array<Point> = [];
        var ask : Array<Point> = [];
        for quote in quotes
        {
            if let time = quote.quoteTime
            {
                let ts = time.timeIntervalSinceReferenceDate
                if (quote.bid > 0)
                {
                    bid.append(Point(x:ts, y:Double(quote.bid)))
                }
                
                if (quote.ask > 0)
                {
                    ask.append(Point(x:ts, y:Double(quote.ask)))
                }
            }
        }
        
        plotView.removeAllPlots();
        
        let bidSet = PointSet(points: bid)
        bidSet.lineColor = NSColor.redColor()
        plotView.addPointSet(bidSet)
        
        let askSet = PointSet(points: ask)
        askSet.lineColor = NSColor.blueColor()
        plotView.addPointSet(askSet)
    }
    
    func newQuotes(quotes:Array<Quote>)
    {
        self.quotes.appendContentsOf(quotes)
        self.createPlot();
        self.tableView.reloadData()
    }

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return quotes.count
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeViewWithIdentifier("StockCellView", owner: self) as! StockCellView
        let quote = quotes[row]
        
        var value = ""
        if let title = tableColumn?.title
        {
            switch title
            {
                case "Stock":
                    value = quote.symbol
                
                case "Bid":
                    value = "\(quote.bid)"
                
                case "Bid Size":
                    value = "\(quote.bidSize)"
                
                case "Bid Depth":
                    value = "\(quote.bidDepth)"
                
                case "Ask":
                    value = "\(quote.ask)"
                
                case "Ask Size":
                    value = "\(quote.askSize)"
                
                case "Ask Depth":
                    value = "\(quote.askDepth)"
                
                case "Last Price":
                    value = "\(quote.lastPrice)"
                
                case "Last Size":
                    value = "\(quote.lastSize)"
                
                default:
                    value = ""
            }
        }
        
        cell.stockSymbol.stringValue = value
        return cell
    }
    
    func openSocket ()
    {
        let ticker = StockfighterOrderBook(account: account, venue: venue, stock: stock)
        
        ticker.openSocket(
            { (msg) in
                if let text = msg as? String
                {
                    if let data = text.dataUsingEncoding(NSUTF8StringEncoding)
                    {
                        var buffer: Array<Quote> = []
                        do
                        {
                            let jsonObject : AnyObject! = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                            
                            if let jsonDict = jsonObject as? NSDictionary
                            {
                                if let quoteDict = jsonDict["\(dictionaryKeys.quote)"] as? NSDictionary
                                {
                                    buffer.append(Quote.init(json: quoteDict))
                                }
                            }
                        }
                        catch
                        {
                            print("Error")
                        }
                        
                        self.newQuotes(buffer)
                    }
                }
            }
        )
    }
    
    func trade ()
    {
        let account = "WAR50459484"
        let venue = "IANBEX"
        let stock = "UUHF"
        let action = StockfighterPlaceOrder(account: account, venue: venue, stock:stock , price: 7900, quanity: 100, direction:TradeDirection.buy, orderType: TradeType.limit)
        action.apiKey = apiKey
        action.go()
    }
}

