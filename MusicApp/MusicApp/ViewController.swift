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
    @IBOutlet weak var musicImg: UIImageView!
    
    // create instance of MotionManager
    let motionManager: CMMotionManager = CMMotionManager()
    
    
    //音声再生に関するやつ
    var audioPlayer = AVAudioPlayer()
    
    //音源の取得
    var sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("test", ofType: "mp3")!)
    
    //タイマーとか曲選択関連のやつ
    var timer = NSTimer()
    var counter:Float = 0
    var timerFlag: Bool = true
    var soundNum: Int = 0
    
    let image1 = UIImage(named: "mp3_001@2x.jpg")
    let image2 = UIImage(named: "mp3_002@2x.jpg")
    let image3 = UIImage(named: "mp3_003@2x.jpg")
    let image4 = UIImage(named: "mp3_004@2x.jpg")
    let image5 = UIImage(named: "mp3_005@2x.jpg")
    
    var musicNum = 1
    var maxMusicNum = 1
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
        
        //選曲スタート
        if timerFlag {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("up"), userInfo: nil, repeats: true)
        }
        
    }
    
    //AccelLevel selection and return Int num
    func accelLevel(level: Double) -> Int {
        
        var num = 1
        
        //音楽再生のレベル5段階
        switch level {
        case 0.0...0.5 :
            num = 1
            if !timerFlag { audioPlayer.rate = 1.0 } else { musicNum = 1 }
            println("レベル1")
        case 0.5...1.0 :
            num = 2
            if !timerFlag { audioPlayer.rate = 1.1 } else { musicNum = 2 }
            println("レベル2")
        case 1.0...1.5 :
            num = 3
            if !timerFlag { audioPlayer.rate = 1.2 } else { musicNum = 3 }
            println("レベル3")
        case 1.5...2.0 :
            num = 4
            if !timerFlag { audioPlayer.rate = 1.3 } else { musicNum = 4 }
            println("レベル4")
        case 2.0...2.5 :
            num = 5
            if !timerFlag { audioPlayer.rate = 1.4 } else { musicNum = 5 }
            println("レベル5")
        default :
            break
            
        }
        return num
    }
    
    //選曲するためのsomethnig
    func selectMusic () {
        //1~5で選曲する
        switch maxMusicNum {
        case 1:
            sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("001", ofType: "mp3")!)
            musicImg = UIImageView(image: image1)
            println("レベル1の曲を選曲しました")
        case 2:
            sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("002", ofType: "mp3")!)
            musicImg = UIImageView(image: image2)
            println("レベル2の曲を選曲しました")
            
        case 3:
            sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("003", ofType: "mp3")!)
            musicImg = UIImageView(image: image3)
            println("レベル3の曲を選曲しました")
        case 4:
            sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("004", ofType: "mp3")!)
            musicImg = UIImageView(image: image4)
            println("レベル4の曲を選曲しました")
        case 5:
            sound_data = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("005", ofType: "mp3")!)
            musicImg = UIImageView(image: image5)
            println("レベル5の曲を選曲しました")
        default :
            break
        }
        
        
        //音楽再生に関する初期設定
        audioPlayer = AVAudioPlayer(contentsOfURL: sound_data, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.numberOfLoops = -1  //これで音楽ファイルを無限ループにしている
        audioPlayer.prepareToPlay()

        //音楽再生
        audioPlayer.play()
        println("音楽スタート")
    }
    
    func up () {
        counter += 0.1
        println("\(counter)秒だよ musicナンバー: \(musicNum)")
        if maxMusicNum < musicNum {
            maxMusicNum = musicNum
        }
        if counter > 5.0 {
            //タイマーストップ
            timer.invalidate()
            timerFlag = false
            self.selectMusic()
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

