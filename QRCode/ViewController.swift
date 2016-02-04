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
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func scanMe(sender: AnyObject) {
    
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
    
    view.bringSubviewToFront(label)
    
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
      }
    }
    
    
  }
  

}

