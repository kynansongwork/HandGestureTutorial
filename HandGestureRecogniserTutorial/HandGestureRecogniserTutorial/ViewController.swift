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
    
    //Camera Properties
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice!
    var devicePosition: AVCaptureDevice.Position = .front
    
    //Vision
    var requests = [VNRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpVision()
        setUpPlayer()
        setUpAirPlay()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareCamera()
    }
    
    func setUpVision() {
        //classification model
        guard let visionModel = try? VNCoreMLModel(for: HandGesturesModel1().model) else {
            fatalError("Can't load vision model.")
        }
        
        let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        
        self.requests = [classificationRequest]
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
    
    func handleClassification(request: VNRequest, error: Error?) {
        //Deals with classifications from the vision framework.
        
        guard let observations = request.results else {
            print("No results")
            return
        }
        
        //Transforming into usable objects.
        let classifications = observations
            .compactMap({$0 as? VNClassificationObservation})
            //Checking if elements have a confidence of greater than 50%.
            .filter({$0.confidence > 0.5})
            //Getting array of identifiers.
            .map({$0.identifier})
        
        print(classifications)
        
        
    }


}

