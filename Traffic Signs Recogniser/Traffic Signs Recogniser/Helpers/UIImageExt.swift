//
//  UIImageExt.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit
import VideoToolbox

extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        guard let cGImage = cgImage else {
            return nil
        }
        
        self.init(cgImage: cGImage)
    }
}
