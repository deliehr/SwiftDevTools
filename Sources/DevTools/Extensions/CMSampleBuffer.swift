//
//  File.swift
//  
//
//  Created by Dominik Liehr on 30.07.24.
//

import Foundation
import AVFoundation
import UIKit

extension CMSampleBuffer {
    var uiImage: UIImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(self) else { return nil }

        let context = CIContext()
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)

        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        return UIImage(cgImage: cgImage)
    }
}
