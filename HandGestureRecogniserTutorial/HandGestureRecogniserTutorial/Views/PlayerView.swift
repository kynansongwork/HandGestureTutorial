//
//  PlayerView.swift
//  HandGestureRecogniserTutorial
//
//  Created by Kynan Song on 06/07/2020.
//  Copyright © 2020 xDesign. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    func setPlayerURL(url: URL) {
        //To initialize player.
        player = AVPlayer(url: url)
        player.allowsExternalPlayback = true
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        
        self.layer.addSublayer(playerLayer)
        playerLayer.frame = self.bounds
    }
}
