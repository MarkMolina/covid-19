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
    
    @IBOutlet weak var previewLayer: UIView!
    
    private lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd4K3840x2160
        return captureSession
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        layer.videoGravity = .resizeAspect
        layer.connection?.videoOrientation = .portrait
        return layer
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.setupCamera()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
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
            // setup output
            self.captureSession.addInput(input)
            
            self.setupLivePreview()
        }
        catch let error {
            print("Unable to initialize back camera: \(error.localizedDescription)")
        }
    }
    
    private func setupLivePreview() {
        
        self.previewLayer.layer.addSublayer(self.videoPreviewLayer)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let s = self else { return }
            s.captureSession.startRunning()
            
            DispatchQueue.main.async {
                
                s.videoPreviewLayer.frame = s.previewLayer.bounds
            }
        }
    }
    
    
}
