//
//  ViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/22/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var camera: UIImageView!

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        searchForDevices()
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
                    }
                }
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func maskQRCode () {
        var blur: UIView!

        blur = UIVisualEffectView (effect: UIBlurEffect (style: UIBlurEffectStyle.Light))
        blur.frame = view.frame
        blur.userInteractionEnabled = false

        camera.addSubview(blur)
        
        let squareSize: CGFloat = 140
        
        let path = UIBezierPath (
            roundedRect: blur.frame,
            cornerRadius: 0)
        
        let square = UIBezierPath (
            roundedRect: CGRect (
                origin: CGPoint (
                    x: blur.center.x - squareSize / 2,
                    y : 100
                ),
                size: CGSize (
                    width: squareSize,
                    height: squareSize
                )
            ),
            cornerRadius: 5
        )
        
        path.appendPath(square)
        path.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer ()

        maskLayer.path = path.CGPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        
        let borderLayer = CAShapeLayer ()

        borderLayer.path = square.CGPath
        borderLayer.strokeColor = UIColor.whiteColor().CGColor
        borderLayer.lineWidth = 5
        blur.layer.addSublayer(borderLayer)
        
        blur.layer.mask = maskLayer
    }


}

