//
//  ViewController.swift
//  MusicApp
//
//  Created by anthony on 2015/09/17.
//  Copyright (c) 2015年 Ateam. All rights reserved.
//

import UIKit
import CoreMotion //To use motion func!!

class ViewController: UIViewController {

    // Connection with interface builder
    @IBOutlet weak var Synthetic_val: UILabel!
    @IBOutlet weak var accelLevelVal: UILabel!
    
    // create instance of MotionManager
    let motionManager: CMMotionManager = CMMotionManager()
    
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
    }
    
    //AccelLevel selection and return Int num
    func accelLevel(level: Double) -> Int {
        
        var num=1
        
        switch level {
        case 0.0...0.5 :
            num = 1
        case 0.5...1.0 :
            num = 2
        case 1.0...1.5 :
            num = 3
        case 1.5...2.0 :
            num = 4
        case 2.0...2.5 :
            num = 5
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

