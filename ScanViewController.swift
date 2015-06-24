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

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let navBar:UINavigationBar = UINavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBarHidden = true
        navBar.frame=CGRectMake(0, 0, self.view.frame.size.width, 70)
        self.view.addSubview(navBar)
        
        let menuButton : UIButton = UIButton(frame: CGRectMake(self.view.frame.width-85, 0, 60, 65))
        menuButton.setImage(UIImage(named: "menuButton"), forState: UIControlState.Normal)
        menuButton.addTarget(self, action: "tappedMenuButton:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(menuButton)
        
        let lblSaturn : UILabel = UILabel(frame: CGRectMake(26, 0, 100, 60))
        lblSaturn.font = UIFont(name: "SanFranciscoText-Semibold", size: 14)
        lblSaturn.text = "S A T U R N"
        lblSaturn.textColor = UIColor.whiteColor()
        navBar.addSubview(lblSaturn)
    }
    
    func tappedMenuButton(sender: UIButton!)
    {
        println("tapped button")
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
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    func addLabelToView(view: UIView) {
        var label = UILabel(frame: CGRectMake(0, 0, 240, 80))
        label.center = CGPointMake(camera.frame.size.width / 2, camera.frame.size.height - 30)
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
            if metadataObj.stringValue != nil {
                println(metadataObj.stringValue)
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
        previewLayer?.opacity = 0.3
        
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
            device.focusMode = .Locked
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
        
        let squareSize: CGFloat = 200
        
        let path = UIBezierPath (
            roundedRect: blur.frame,
            cornerRadius: 0)
        
        let square = UIBezierPath (
            roundedRect: CGRect (
                origin: CGPoint (
                    x: blur.center.x - squareSize / 2,
                    y : blur.center.y - squareSize / 2
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
        borderLayer.strokeColor = UIColor.whiteColor().CGColor
        borderLayer.lineWidth = 20
        blur.layer.addSublayer(borderLayer)
        
        blur.layer.mask = maskLayer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

