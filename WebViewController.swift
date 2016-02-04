//
//  WebViewController.swift
//  QRCode
//
//  Created by Jinah Adam on 4/2/16.
//  Copyright © 2016 Jinah Adam. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
  
  
  var qrLink: String!
  

  @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

      let url = NSURL(string: qrLink)
      let request = NSURLRequest(URL: url!)
      webview.loadRequest(request)
      
      
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func goback(sender: AnyObject) {
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
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
