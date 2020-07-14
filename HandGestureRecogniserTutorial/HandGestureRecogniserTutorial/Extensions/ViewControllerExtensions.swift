//
//  ViewControllerExtensions.swift
//  HandGestureRecogniserTutorial
//
//  Created by Kynan Song on 14/07/2020.
//  Copyright © 2020 xDesign. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func prepareCamera() {
        //Array of all available devices.
        let availableDevices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices
        
        captureDevice = availableDevices.first
        beginSession()
    }
    
    func beginSession() {
        //Configure session.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(captureDeviceInput)
        } catch {
            print("Failed to create video device input")
            return
        }
        
        captureSession.beginConfiguration()
        //Photo resolution.
        captureSession.sessionPreset = .vga640x480
        
        //Output for vision.
        let dataOutput = AVCaptureVideoDataOutput()
        //Need to specify a dictionary of the pixel format typekey.
        //How images willbe recieved by vision.
        dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        dataOutput.alwaysDiscardsLateVideoFrames = true
        
        if captureSession.canAddOutput(dataOutput) {
            captureSession.addOutput(dataOutput)
        }
        
        captureSession.commitConfiguration()
        
        let queue = DispatchQueue(label: "captureQueue")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
        
        captureSession.startRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        //Vision needs orientation information.
        let exifOrientation = self.exifOrientationFromDevice()
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print("There was a request error: \(error)")
        }
    }
    
    func exifOrientationFromDevice() -> CGImagePropertyOrientation {
        let deviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation

        switch deviceOrientation {

        case .portrait:
            exifOrientation = .up
        case .portraitUpsideDown:
            exifOrientation = .left
        case .landscapeLeft:
            exifOrientation = .upMirrored
        case .landscapeRight:
            exifOrientation = .down
        default:
            exifOrientation = .up
        }

        return exifOrientation
    }
}

