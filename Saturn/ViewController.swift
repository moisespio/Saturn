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
    @IBOutlet weak var blurred: UIImageView!
    @IBOutlet weak var squareCanvas: UIImageView!

    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
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
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = blurred.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)

        blurred.layer.addSublayer(previewLayer)
        blurred.addSubview(visualEffectView)
        blurred.clipsToBounds = true
        
//        squareCanvas.layer.addSublayer(previewLayer)
        squareCanvas.clipsToBounds = true
        
        previewLayer?.frame = blurred.layer.frame
        previewLayer?.position = CGPoint(
            x : blurred.frame.size.width / 2,
            y : 0
        )
        previewLayer?.frame.size.height = blurred.frame.size.height * 2

        captureSession.startRunning()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

