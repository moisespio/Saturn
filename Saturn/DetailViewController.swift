//
//  DetailViewController.swift
//  Saturn
//
//  Created by Moisés Pio on 6/29/15.
//  Copyright (c) 2015 Saturn. All rights reserved.
//

import UIKit
import AVFoundation

class DetailViewController: UIViewController {
    @IBOutlet weak var sensorIdentifier: UILabel!
    @IBOutlet weak var sensorLocation: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var gasLevelLabel: UILabel!
    @IBOutlet weak var constraintUpdateView: NSLayoutConstraint!
    
    var sensorStatus = 0
    var sensorNameText = ""
    var sensorLocationText = ""
    var sensorObjectId = ""
    var sensorGasLevelIcon = [
        "big-ok-icon",
        "big-warning-icon",
        "big-danger-icon"
    ]
    
    var sensorGasLevelLabel = [
        "Nenhum vazamento detectado",
        "Pequeno vazamento detectado",
        "Grande vazamento detectado"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSaturnNavigationBarWithCloseButton("tappedCloseButton:")
        
        sensorIdentifier.text = sensorNameText
        sensorLocation.text = sensorLocationText
        
        self.icon.image = UIImage(named: sensorGasLevelIcon[sensorStatus])
        self.gasLevelLabel.text = sensorGasLevelLabel[sensorStatus]
        
        let speechSynthesizer = AVSpeechSynthesizer()
        
        let speechUtterance = AVSpeechUtterance(string: "Você selecionou o seguinte sensor: Cozinha. Nenhum vazamento detectado.")
        
        speechUtterance.rate = 0.1
        speechUtterance.pitchMultiplier = 1
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "pt-BR")
        
        speechSynthesizer.speakUtterance(speechUtterance)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateSensor()
    }
    
    func updateSensor()
    {
        SensorModel.getSensor(self.sensorObjectId) {
            (sensorModel: SensorModel?) -> Void in
            if (sensorModel != nil) {
                self.sensorIdentifier.text = sensorModel!.sensorName
                self.sensorLocation.text = sensorModel!.sensorDescription
                self.icon.image = UIImage(named: self.sensorGasLevelIcon[sensorModel!.sensorStatus])
                self.gasLevelLabel.text = self.sensorGasLevelLabel[sensorModel!.sensorStatus]
            }
        }
        
        UIView.animateWithDuration(10, animations: {
            self.constraintUpdateView.constant = self.view.frame.size.width
            self.view.layoutIfNeeded() ?? ()
            }, completion: {
                (value: Bool) in
                if (value){
                    self.constraintUpdateView.constant = 0
                    self.view.layoutIfNeeded() ?? ()
                    self.updateSensor()
                }
        })
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tappedCloseButton(sender: UIViewController!) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
