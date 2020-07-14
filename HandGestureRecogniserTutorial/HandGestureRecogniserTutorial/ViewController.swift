//
//  ViewController.swift
//  HandGestureRecogniserTutorial
//
//  Created by Kynan Song on 06/07/2020.
//  Copyright © 2020 xDesign. All rights reserved.
//

import UIKit
import Vision
import AVKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var gestureView: UIImageView!
    @IBOutlet weak var playerView: PlayerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVision()
        setUpPlayer()
        setUpAirPlay()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setUpVision() {
        
    }
    
    func setUpPlayer() {
        playerView.setPlayerURL(url: URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!)
        playerView.player.play()
    }
    
    func setUpAirPlay() {
        let airplay = AVRoutePickerView(frame: CGRect(x: 0, y: 40, width: 80, height: 80))
        airplay.center.x = self.view.center.x
        airplay.tintColor = UIColor.white
        self.view.addSubview(airplay)
    }


}

