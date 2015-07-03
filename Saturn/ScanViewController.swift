//
//  ViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/22/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import AVFoundation

class ScanViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
    @IBOutlet weak var camera: UIImageView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var codeField: UITextField!
    
    @IBOutlet weak var buyButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraTopConstraint: NSLayoutConstraint!
    
    var objCaptureSession = AVCaptureSession()
    var objCaptureVideoPreviewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var qrCodeRead : Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        
        let font = UIFont(name: "SanFranciscoText-Regular", size: 14)!
        let attributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor(), NSFontAttributeName : font]
        codeField.attributedPlaceholder = NSAttributedString(string: "Ou insira o código manualmente", attributes:attributes)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        self.codeField.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func tappedCloseButton(sender: UIButton!)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldDidChange(codeField: UITextField) {
        if count(codeField.text) != 10 {
            return
        }
        
        if startsWith(codeField.text, "ST") {
            self.performSegueWithIdentifier("SensorViewController", sender: codeField.text)
        } else {
            codeField.text = ""
//            codeField.endEditing(true)
            codeField.placeholder = "Código inválido"
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        var border = CALayer()
        var width = CGFloat(2.0)
        border.borderColor = UIColor(red: 222/255, green: 226/255, blue: 233/255, alpha: 1).CGColor
        border.frame = CGRect(x: 0, y: codeField.frame.size.height - width, width:  codeField.frame.size.width, height: codeField.frame.size.height)
        
        border.borderWidth = width
        codeField.layer.addSublayer(border)
        codeField.layer.masksToBounds = true
        
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.maskQRCode()
        self.addLabelToView(blurView)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(objCaptureDevice, error: &error)
        if (error != nil) {
            var alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    func addVideoPreviewLayer() {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer)
        objCaptureSession.startRunning()
        
        objCaptureVideoPreviewLayer?.opacity = 1
        camera.layer.addSublayer(objCaptureVideoPreviewLayer)
        camera.clipsToBounds = true
        
        objCaptureVideoPreviewLayer?.frame = camera.layer.frame
        objCaptureVideoPreviewLayer?.position = CGPoint(
            x : camera.frame.size.width / 2,
            y : 0
        )
        
        objCaptureVideoPreviewLayer?.frame.size.height = camera.frame.size.height * 2

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
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        var count = metadataObjects.count
        
        if metadataObjects == nil || count < 1 {
            println("No qr code is detected")
            return
        }
        
        let metadataObj = metadataObjects[count - 1] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            if metadataObj.stringValue != nil {
                let metadata = metadataObj.stringValue
                self.performSegueWithIdentifier("SensorViewController", sender: metadata)
            }
        }
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .ContinuousAutoFocus
            device.unlockForConfiguration()
        }
        
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
