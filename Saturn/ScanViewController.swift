//
//  ViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/22/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var buyButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraTopConstraint: NSLayoutConstraint!

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var qrCodeRead : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        qrCodeRead = false
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        
        let font = UIFont(name: "SanFranciscoText-Regular", size: 14)!
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName : font]
        codeField.attributedPlaceholder = NSAttributedString(string: "Ou insira o código manualmente",
            attributes:attributes)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func tappedCloseButton(sender: UIButton!)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        searchForDevices()
        
        var border = CALayer()
        var width = CGFloat(2.0)
        border.borderColor = UIColor(red: 222/255, green: 226/255, blue: 233/255, alpha: 1).CGColor
        border.frame = CGRect(x: 0, y: codeField.frame.size.height - width, width:  codeField.frame.size.width, height: codeField.frame.size.height)
        
        border.borderWidth = width
        codeField.layer.addSublayer(border)
        codeField.layer.masksToBounds = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func animateWithKeyboard(notification: NSNotification) {
        var userInfo = notification.userInfo!

        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        if notification.name == UIKeyboardWillShowNotification {
            buyButtonBottomConstraint.constant = keyboardSize.height
            cameraTopConstraint.constant = (keyboardSize.height - 70) * -1
        }
        else {
            buyButtonBottomConstraint.constant = 0
            cameraTopConstraint.constant = 70
        }
        
        view.setNeedsUpdateConstraints()
        let options = UIViewAnimationOptions(curve << 16)
        
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        animateWithKeyboard(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateWithKeyboard(notification)
    }
    
    func addLabelToView(view: UIView) {
        var label = UILabel(frame: CGRectMake(0, 0, 240, 80))
        label.center = CGPointMake(camera.frame.size.width / 2, camera.frame.size.height - 60)
        label.textAlignment = NSTextAlignment.Center
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont(name: "SanFranciscoText-Regular", size: 16)
        label.text = "Aponte sua câmera para o QRCode localizado no sensor"
        label.textColor = UIColor.whiteColor()
        view.addSubview(label)
    }
    
    func searchForDevices() {
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    
                    if captureDevice != nil {
                        beginSession()
                        configQRCode()
                        addLabelToView(blurView)
                    }
                }
            }
        }
    }
    
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {

        if metadataObjects == nil || metadataObjects.count == 0 {
            println("No qr code is detected")
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            if metadataObj.stringValue != nil && qrCodeRead == false {
                qrCodeRead = true
                let metadata = metadataObj.stringValue
                self.performSegueWithIdentifier("SensorViewController", sender: metadata)
            }
        }
    }
    
    func beginSession() {
        maskQRCode()
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.opacity = 1
        
        camera.layer.addSublayer(previewLayer)
        camera.clipsToBounds = true
        
        previewLayer?.frame = camera.layer.frame
        previewLayer?.position = CGPoint(
            x : camera.frame.size.width / 2,
            y : 0
        )
        
        previewLayer?.frame.size.height = camera.frame.size.height * 2
        
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .ContinuousAutoFocus
            device.unlockForConfiguration()
        }
        
    }
    
    func configQRCode() {
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func maskQRCode () {
        var blur: UIView!
        blurView.clipsToBounds = true

        blur = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffectStyle.Dark))
        blur.frame = blurView.frame
        blur.userInteractionEnabled = false

        blurView.addSubview(blur)
        
        let squareSize: CGFloat = 190
        
        let path = UIBezierPath (
            roundedRect: blur.frame,
            cornerRadius: 0)
        
        let square = UIBezierPath (
            roundedRect: CGRect (
                origin: CGPoint (
                    x: blur.center.x - squareSize / 2,
                    y : blur.center.y - (squareSize / 2) - 30
                ),
                size: CGSize (
                    width: squareSize,
                    height: squareSize
                )
            ),
            cornerRadius: 10
        )
        
        path.appendPath(square)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer ()
        maskLayer.path = path.CGPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        let borderLayer = CAShapeLayer ()
        borderLayer.path = square.CGPath
        borderLayer.strokeColor = UIColor(red: 127/255, green: 148/255, blue: 255/255, alpha: 1).CGColor
        borderLayer.lineWidth = 15
        
        let borderLayer2 = CAShapeLayer ()
        borderLayer2.path = square.CGPath
        borderLayer2.strokeColor = UIColor(red: 127/255, green: 148/255, blue: 255/255, alpha: 0.2).CGColor
        borderLayer2.lineWidth = 30

        blur.layer.addSublayer(borderLayer2)
        blur.layer.addSublayer(borderLayer)
        
        blur.layer.mask = maskLayer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SensorViewController" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let vc = navigationController.viewControllers[0] as! SensorViewController
            vc.sensorCode = sender as! String
        }
    }
}
