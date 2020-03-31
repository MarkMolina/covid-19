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
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
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
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
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
        guard let device = AVCaptureDevice.default(for: .video) else {
            
            print("Unable to access back camera")
            return
        }
        
        do {
            
            let input = try AVCaptureDeviceInput(device: device)
            guard self.captureSession.canAddInput(input) else { return }
            
            self.captureSession.addInput(input)
            self.captureSession.addOutput(photoOutpout)
            
            self.setupLivePreview()
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
    
    @IBAction func runTest(_ sender: Any) {
        
        start()
    }
}

extension DDCameraViewController {
    
    private func toggleTorch(on: Bool) {
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                
                if on == true {
                    try device.setTorchModeOn(level: DDParameterStore.shared.flashIntensity)
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch { print("Torch could not be used") }
        } else { print("Torch is not available") }
    }
}

extension DDCameraViewController {
    
    private func start() {
        
        guard let rawFormat = self.photoOutpout.availableRawPhotoPixelFormatTypes.first else { return }
        let photoSettings = AVCapturePhotoSettings(rawPixelFormatType: rawFormat)
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        // WIP: Implement timings
        
        // Handle Flash
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        toggleTorch(on: !device.isTorchActive)
        
        // Handle Photo
        photoOutpout.capturePhoto(with: photoSettings, delegate: self)
    }
}
