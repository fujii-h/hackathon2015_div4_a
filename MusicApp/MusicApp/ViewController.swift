//
//  ViewController.swift
//  MusicApp
//
//  Created by anthony on 2015/09/17.
//  Copyright (c) 2015年 Ateam. All rights reserved.
//

import UIKit
import CoreMotion //To use motion func!!
import AVFoundation

class ViewController: UIViewController {

    // Connection with interface builder
    @IBOutlet weak var Synthetic_val: UILabel!
    @IBOutlet weak var accelLevelVal: UILabel!
    
    // create instance of MotionManager
    let motionManager: CMMotionManager = CMMotionManager()
    
    
    //音声再生に関するやつ
    var audioPlayer = AVAudioPlayer()
    
    //音源の取得
    let sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("test", ofType: "mp3")!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize MotionManager
        motionManager.deviceMotionUpdateInterval = 0.2 // n Hz
        
        // Start motion data acquisition
        motionManager.startDeviceMotionUpdatesToQueue( NSOperationQueue.currentQueue(), withHandler:{
            deviceManager, error in
            var accel: CMAcceleration = deviceManager.userAcceleration
            //Calc synthetic vector of accel
            let syntheticTmp = pow(pow(accel.x,2.0)+pow(accel.y,2.0)+pow(accel.z,2.0),0.5)
            //Display Raw Accel num
            self.Synthetic_val.text = String(format: "%.2f",syntheticTmp)
            //Display Accel Level
            self.accelLevelVal.text = String(format: "%d",self.accelLevel(syntheticTmp))
            
        })
        
        //音楽再生に関する初期設定
        audioPlayer = AVAudioPlayer(contentsOfURL: sound_data, error: nil)
        
        audioPlayer.enableRate = true
        audioPlayer.numberOfLoops = -1  //これで音楽ファイルを無限ループにしている
        audioPlayer.prepareToPlay()
        
        //音楽再生
        audioPlayer.play()
    }
    
    //AccelLevel selection and return Int num
    func accelLevel(level: Double) -> Int {
        
        var num=1
        
        
        //音楽再生のレベル5段階
        switch level {
        case 0.0...0.5 :
            num = 1
            audioPlayer.rate = 1.0
            println("レベル1")
        case 0.5...1.0 :
            num = 2
            audioPlayer.rate = 1.2
            println("レベル2")
        case 1.0...1.5 :
            num = 3
            audioPlayer.rate = 1.4
            println("レベル3")
        case 1.5...2.0 :
            num = 4
            audioPlayer.rate = 1.6
            println("レベル4")
        case 2.0...2.5 :
            num = 5
            audioPlayer.rate = 1.8
            println("レベル5")
        default :
            break
        }
        return num
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

