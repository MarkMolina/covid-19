//
//  DDCaptureProcessor.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 31/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import AVKit

class DDCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard error == nil else { print("Error capturing photo: \(error!)"); return }
        if photo.isRawPhoto {
            
            guard let pixelBuffer = photo.pixelBuffer else { return }
            
            let pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
            guard pixelFormat == kCVPixelFormatType_14Bayer_RGGB else {
                print("Unexpected pixel format: \(pixelFormat)")
                return
            }
            
            CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
            defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
            
            /* Data is Bayer 14-bit Little-Endian, packed in 16-bits, ordered R G R G... alternating with G B G B... */
            let buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt16>.self)
            
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            for col in 0...width {
                
                for row in 0...height {
                    
                    let pixel = buffer[col * height + row]
                    // do something...
                }
            }
            print("done")
        }
    }
}
