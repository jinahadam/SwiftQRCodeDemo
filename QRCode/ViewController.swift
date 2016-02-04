//
//  ViewController.swift
//  QRCode
//
//  Created by Jinah Adam on 4/2/16.
//  Copyright © 2016 Jinah Adam. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  var captureSession:AVCaptureSession?
  var videoPreviewLayer:AVCaptureVideoPreviewLayer?
  var qrCodeFrameView:UIView?

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var cancelButton: UIButton!
  @IBOutlet weak var openButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    cancelButton.hidden = true
    label.hidden = true
    openButton.hidden = true
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func scanMe(sender: AnyObject) {
    
    
    cancelButton.hidden = false
    label.hidden = false
    openButton.hidden = false
    
    let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var error: NSError?
    let input: AnyObject!
    
    do {
      
      input = try AVCaptureDeviceInput(device: captureDevice)
      
    } catch let error1 as NSError {
      
      error = error1
      input = nil
      
      
    }
    
    if (error != nil) {
      print("\(error?.localizedDescription)")
    }
    
    captureSession = AVCaptureSession()
    captureSession?.addInput(input as! AVCaptureInput)
    
    let captureMetadataOutput = AVCaptureMetadataOutput()
    captureSession?.addOutput(captureMetadataOutput)
    captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    
    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    videoPreviewLayer?.frame = view.layer.bounds
    view.layer.addSublayer(videoPreviewLayer!)
    
    captureSession?.startRunning()
    
    view.bringSubviewToFront(cancelButton)
    view.bringSubviewToFront(label)
    view.bringSubviewToFront(openButton)
    
    qrCodeFrameView = UIView()
    qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
    qrCodeFrameView?.layer.borderWidth = 2
    view.addSubview(qrCodeFrameView!)
    view.bringSubviewToFront(qrCodeFrameView!)
    
  }
  
  func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    if metadataObjects == nil || metadataObjects.count == 0 {
      qrCodeFrameView?.frame = CGRectZero
      label.text = "No QR Code"
      return
    }
    
    let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
    
    if metadataObject.type == AVMetadataObjectTypeQRCode {
      let barcodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObject) as! AVMetadataMachineReadableCodeObject!
      qrCodeFrameView!.frame = barcodeObject.bounds
      
      if metadataObject.stringValue != nil {
        label.text = metadataObject.stringValue
        captureSession?.stopRunning()
        
      }
    }
  }
  
  @IBAction func cancel(sender: AnyObject) {
    
    cancelButton.hidden = true
    label.hidden = true
    cancelButton.hidden = true
    
    captureSession?.stopRunning()
    qrCodeFrameView?.removeFromSuperview()
    videoPreviewLayer?.removeFromSuperlayer()
    
    
  }

  @IBAction func openURL(sender: AnyObject) {
    
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
    if segue.identifier == "passData" {
      let webviewController = segue.destinationViewController as! WebViewController
      webviewController.qrLink = self.label.text!
      
    }
  }
}

