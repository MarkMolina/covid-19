//
//  DDCameraViewController.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 29/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import UIKit
import AVFoundation

class DDCameraViewController: DDViewController {
    
    private enum TestState: String {
        case ready = "ready"
        case running = "waiting"
    }
    
    @IBOutlet weak var previewLayer: UIView!
    @IBOutlet weak var cameraButton: DDCameraButton!
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        return captureSession
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = .resizeAspectFill
        layer.connection?.videoOrientation = .portrait
        return layer
    }()
    
    private let photoOutpout: AVCapturePhotoOutput = {
        let output = AVCapturePhotoOutput()
        output.isHighResolutionCaptureEnabled = true
        return output
    }()
    
    private let device: AVCaptureDevice? = {
        AVCaptureDevice.default(.builtInTelephotoCamera, for: .video, position: .back)
    }()
    
    private let processor = DDCaptureProcessor()
    
    private var flashStartTime: Date = Date()
    private var flashEndTime: Date = Date()
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        guard (device != nil) else {
            
            print("Unable to access back camera")
            return
        }
        
        self.setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
        if let firstInput = self.captureSession.inputs.first {
            self.captureSession.removeInput(firstInput)
        }
    }
    
    // MARK: Private
    
    private func setupCamera() {
        
        do {
            
            let input = try AVCaptureDeviceInput(device: device!)
            guard captureSession.canAddInput(input) else { return }
            guard captureSession.canAddOutput(photoOutpout) else { return }
            
            captureSession.beginConfiguration()
            captureSession.addInput(input)
            captureSession.addOutput(photoOutpout)
            captureSession.commitConfiguration()
            
            setupLivePreview()
        }
        catch let error {
            print("Unable to initialize back camera: \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        
        self.previewLayer.layer.insertSublayer(videoPreviewLayer, at: 0)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let s = self else { return }
            s.captureSession.startRunning()
            
            DispatchQueue.main.async {
                
                s.videoPreviewLayer.frame = s.previewLayer.bounds
            }
        }
    }
    
    @IBAction private func didTapEdit() {
        
        let min = Float(device!.activeFormat.minExposureDuration.seconds)
        let max = Float(device!.activeFormat.maxExposureDuration.seconds)
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DDSettingsTableViewController") as! DDSettingsTableViewController
        vc.exposureMinMax = (min, max)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func runTest(_ sender: Any) {
        
        start()
    }
}

extension DDCameraViewController {
    
    private func toggleTorch(on: Bool) {

        if device!.hasTorch {
            do {
                try device!.lockForConfiguration()
                
                if on == true {
                    try device!.setTorchModeOn(level: DDParameterStore.shared.flashIntensity)
                } else {
                    device!.torchMode = .off
                }
                
                print("Flash: \(on)")

                device!.unlockForConfiguration()
            } catch { print("Torch could not be used") }
        } else { print("Torch is not available") }
    }
    
    private func setExposureSettings(completionHandler: ((CMTime) -> Void)?) {
        
        do {
            try device!.lockForConfiguration()
            
            let exposureDuration = CMTimeMakeWithSeconds(Double(DDParameterStore.shared.exposeTime1 * 1000), preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            device!.exposureMode = .custom
            
            print(device!.activeFormat.minExposureDuration)
            print(device!.activeFormat.maxExposureDuration)
            device!.setExposureModeCustom(duration: device!.activeFormat.maxExposureDuration, iso: AVCaptureDevice.currentISO, completionHandler: completionHandler)
            
            device!.unlockForConfiguration()
            
        } catch { print("Failed setting exposure time") }
    }
}

extension DDCameraViewController {
    
    private func start() {
        
        guard photoOutpout.availableRawPhotoPixelFormatTypes.contains(DDCaptureProcessor.RawFormat) else {
            print("Required raw pixel format not found")
            return
        }
        let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: DDCaptureProcessor.RawFormat)
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        // WIP: Implement timings
        
        // step 1: illuminate
        startIllumination()
        
        // step 2: delay for afterburn
        let delay = DDParameterStore.shared.delay.msToSeconds
        Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            // step 3: expose
            self.setExposureSettings(completionHandler: { [unowned self] (_) in
                
                // lastly: process photo
                //self.photoOutpout.capturePhoto(with: photoSettings, delegate: self.processor)
            })
        }
    }
    
    private func startIllumination() {
        
        flashStartTime = Date()
        toggleTorch(on: true)
        
        let duration = DDParameterStore.shared.flashDuration.msToSeconds
        
        Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] (_) in
            
            guard let `self` = self else { return }
            
            guard self.device!.isTorchActive == true else {
                print("Unexpected scenario occured. Flash wasn't on.")
                return
            }
            
            self.toggleTorch(on: false)
            self.flashEndTime = Date()
            
            
            print("Flash duration: \(self.flashEndTime.timeIntervalSince(self.flashStartTime).secondsToMiliseconds)")
        }
    }
}
