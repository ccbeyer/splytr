//
//  SplitViewController.swift
//  LoveInASnap
//
//  Created by Chris Beyer on 7/18/15.
//  Copyright (c) 2015 Lyndsey Scott. All rights reserved.
//

import UIKit

class SplitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

  
  @IBOutlet
  var tableView: UITableView!
  
    @IBOutlet weak var taxLabel: UILabel!
  
  
  var lineItems = [String: Double]()
  var items: [NSString] = []
  var prices: [Double] = []
  var tax: Double = 0.0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        taxLabel.text = String(format:"%.2f", tax)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  
  
  ///TABLE VIEW
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count;
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
    
    //var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
    
    
    //we know that cell is not empty now so we use ! to force unwrapping
    if (prices.count > indexPath.row) {
      cell.textLabel?.text = items[indexPath.row]
    
    
      cell.detailTextLabel?.text = String(format:"%.2f", prices[indexPath.row])
    }
    
    //cell.textLabel?.text = "hello"
    
    /*var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    
    
    cell.textLabel?.text = self.items[indexPath.row]
    cell.detailTextLabel?.text = "price"
    */
    
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    println("You selected cell #\(indexPath.row)!")
    println(items[indexPath.row])
  }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
