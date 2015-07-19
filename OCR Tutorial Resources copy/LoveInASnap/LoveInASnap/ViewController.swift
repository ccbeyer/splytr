//
//  ViewController.swift
//  LoveInASnap
//
//  Created by Lyndsey Scott on 1/11/15
//  for http://www.raywenderlich.com/
//  Copyright (c) 2015 Lyndsey Scott. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
  
  @IBOutlet
  var tableView: UITableView!
  
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var findTextField: UITextField!
  @IBOutlet weak var replaceTextField: UITextField!
  @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
  
  var activityIndicator:UIActivityIndicatorView!
  var originalTopMargin:CGFloat!
  
  var items: [NSString] = []
  
  var lineItems = [String: Double]()
  var prices: [Double] = []
  var tax: Double = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
  }
  
  @IBAction func takePhoto(sender: AnyObject) {
    // 1
    view.endEditing(true)
    
    // 2
    let imagePickerActionSheet = UIAlertController(title: "Snap/Upload Photo",
      message: nil, preferredStyle: .ActionSheet)
    
    // 3
    if UIImagePickerController.isSourceTypeAvailable(.Camera) {
      let cameraButton = UIAlertAction(title: "Take Photo",
        style: .Default) { (alert) -> Void in
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = .Camera
          self.presentViewController(imagePicker,
            animated: true,
            completion: nil)
      }
      imagePickerActionSheet.addAction(cameraButton)
    }
    
    // 4
    let libraryButton = UIAlertAction(title: "Choose Existing",
      style: .Default) { (alert) -> Void in
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker,
          animated: true,
          completion: nil)
    }
    imagePickerActionSheet.addAction(libraryButton)
    
    // 5
    let cancelButton = UIAlertAction(title: "Cancel",
      style: .Cancel) { (alert) -> Void in
    }
    imagePickerActionSheet.addAction(cancelButton)
    
    // 6
    presentViewController(imagePickerActionSheet, animated: true,
      completion: nil)
  }
  
  @IBAction func swapText(sender: AnyObject) {
    
  }
  
  @IBAction func sharePoem(sender: AnyObject) {
    
  }
  
  func scaleImage(image: UIImage, maxDimension: CGFloat) -> UIImage {
    
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)
    var scaleFactor: CGFloat
    
    if image.size.width > image.size.height {
      scaleFactor = image.size.height / image.size.width
      scaledSize.width = maxDimension
      scaledSize.height = scaledSize.width * scaleFactor
    } else {
      scaleFactor = image.size.width / image.size.height
      scaledSize.height = maxDimension
      scaledSize.width = scaledSize.height * scaleFactor
    }
    
    UIGraphicsBeginImageContext(scaledSize)
    image.drawInRect(CGRectMake(0, 0, scaledSize.width, scaledSize.height))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }

  
  func performImageRecognition(image: UIImage) {
    // 1
    let tesseract = G8Tesseract()
    
    // 2
    tesseract.language = "eng"
    
    // 3
    tesseract.engineMode = .TesseractCubeCombined
    
    // 4
    //tesseract.pageSegmentationMode = .Auto
    
    
    tesseract.setVariableValue(",", forKey: kG8ParamTesseditCharBlacklist)
    
    
    // 5
    tesseract.maximumRecognitionTime = 60.0
    
    // 6
    tesseract.image = image.g8_blackAndWhite()
    tesseract.recognize()
    
    let result:[NSString] = split(tesseract.recognizedText as String, { $0 == "\n" }, allowEmptySlices: true)
    var itemsPre = result
    //items = result
    var reachedTotal = false;
    prices = []
    for (var i = 0; i < itemsPre.count; i++) {
      var lastSpace = itemsPre[i].rangeOfString(" ", options: NSStringCompareOptions.BackwardsSearch).location
      println(lastSpace)
      if (lastSpace <= 30) {
        lineItems[itemsPre[i].substringToIndex(lastSpace)] = (NSString)(string: itemsPre[i].substringFromIndex(lastSpace+1)).doubleValue
        var item = (itemsPre[i].substringToIndex(lastSpace)) //item
        var price = (itemsPre[i].substringFromIndex(lastSpace)) //price
        price = price.stringByReplacingOccurrencesOfString(",", withString: ".")
        price = price.stringByReplacingOccurrencesOfString("$", withString: "")
        price = price.stringByReplacingOccurrencesOfString(":", withString: "")
        var priceDouble = (price as NSString).doubleValue
        
        
        /*var lastPeriod = (price as NSString).rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch)
        if ((price as NSString).length > lastPeriod.location + 2) {
          price = price.substringToIndex(lastPeriod)
        }*/
        
        if let textRange = item.lowercaseString.rangeOfString("total") {
          reachedTotal = true;
        }
        if let textRange = item.lowercaseString.rangeOfString("tax") {
          reachedTotal = true
          tax = priceDouble
        }
        if (!reachedTotal) {
          //items[i] = item
          items.append(item)
          prices.append(priceDouble)
        }
      }
    }
    
    /*
    for line in items {
      var lastSpace = line.rangeOfString(" ", options: NSStringCompareOptions.BackwardsSearch).location
      println(lastSpace)
      if (lastSpace <= 30) {
        lineItems[line.substringToIndex(lastSpace)] = (NSString)(string: line.substringFromIndex(lastSpace+1)).doubleValue
        println(line.substringToIndex(lastSpace))
        println(line.substringFromIndex(lastSpace))
      }
    }
    */
    
    self.tableView.reloadData()
    // 7
    textView.text = tesseract.recognizedText
    textView.editable = true
    
    // 8
    removeActivityIndicator()
    performSegueWithIdentifier("toSplitView", sender: self)
  }

  
  
  // Activity Indicator methods
  
  func addActivityIndicator() {
    activityIndicator = UIActivityIndicatorView(frame: view.bounds)
    activityIndicator.activityIndicatorViewStyle = .WhiteLarge
    activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.25)
    activityIndicator.startAnimating()
    view.addSubview(activityIndicator)
  }
  
  func removeActivityIndicator() {
    activityIndicator.removeFromSuperview()
    activityIndicator = nil
  }
  
  
  // The remaining methods handle the keyboard resignation/
  // move the view so that the first responders aren't hidden
  

  

}

extension ViewController: UITextFieldDelegate {
  
  
  
  
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
    
    
      cell.detailTextLabel?.text = String(format:"%f", prices[indexPath.row])
    }
    
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
  

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    if (segue.identifier == "toSplitView") {
      
      if let viewController: SplitViewController = segue.destinationViewController as? SplitViewController {
        viewController.items = items
        viewController.prices = prices
        viewController.tax = tax
      }
      
    }
  }
  
  
   
  
}





extension ViewController: UIImagePickerControllerDelegate {
  
  func imagePickerController(picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      let selectedPhoto = info[UIImagePickerControllerOriginalImage] as UIImage /////////add !
      let scaledImage = scaleImage(selectedPhoto, maxDimension: 640)
      
      addActivityIndicator()
      
      dismissViewControllerAnimated(true, completion: {
        self.performImageRecognition(scaledImage)
      })
  }

}
