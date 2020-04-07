//
//  DDCaptureProcessor.swift
//  covid-19
//
//  Created by Mark Anthony Molina on 31/03/2020.
//  Copyright © 2020 dakke dak. All rights reserved.
//

import AVKit

class DDCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    
    static let RawFormat = kCVPixelFormatType_14Bayer_RGGB
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didCapturePhotoFor resolvedSettings: AVCaptureResolvedPhotoSettings) {
//
//        print("didCapturePhotoFor:")
//    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        print("didFinishProcessingPhoto:")
        
        guard error == nil else { print("Error capturing photo: \(error!)"); return }
        
        if photo.isRawPhoto {
            
            guard let pixelBuffer = photo.pixelBuffer else { return }
            
            let pixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
            guard pixelFormat == DDCaptureProcessor.RawFormat else {
                
                print("Unexpected pixel format: \(pixelFormat)")
                return
            }
            
            CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
            defer { CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly) }
            
            /* Data is Bayer 14-bit Little-Endian, packed in 16-bits, ordered R G R G... alternating with G B G B... */
            let buffer = unsafeBitCast(CVPixelBufferGetBaseAddress(pixelBuffer), to: UnsafeMutablePointer<UInt16>.self)
            
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
            
            
            var index = 0
            var outputString = ""
            
            for y in 0...height {
                
                for x in 0..<width {
                    
                    index = (y * width + x)
                    outputString += "\(buffer[index]) "
                }
                
                outputString += "\n"
            }
            
            print(index)
            print(width * height)
            print("width: \(width)")
            print("height: \(height)")
            print("bytes per row: \(bytesPerRow)")
            
            print("done")
            
            //12192768
            
//            let file = "file.txt" //this is the file. we will write to and read from it
//
//            let text = outputString
//
//            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//                let fileURL = dir.appendingPathComponent(file)
//
//                //writing
//                do {
//                    try text.write(to: fileURL, atomically: false, encoding: .utf8)
//                }
//                catch { print("error handling here") }
//            }
        }
    }
}
