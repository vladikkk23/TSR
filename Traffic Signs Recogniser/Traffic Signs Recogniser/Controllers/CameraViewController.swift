//
//  CameraViewController.swift
//  Traffic Signs Recogniser
//
//  Created by vladikkk on 28/01/2021.
//

import UIKit
import AVFoundation
import Vision
import VideoToolbox

class CameraViewController : UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    private var detectionOverlay: CALayer! = nil
    
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoOutputQueue = DispatchQueue(label: "Video_Output")
    
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    
    var currentRequestIndex = 0
    // How many predictions we can do concurrently.
    static let maxRequests = 3
    
    // Initializing request handler
    var requests = [VNCoreMLRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRequests()
        self.loadCamera()
        self.setupLayers()
        self.updateLayerGeometry()
        
        self.session.startRunning()
    }
    
    func setupLayers() {
        detectionOverlay = CALayer()
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: bufferSize.width, height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry() {
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite {
            scale = 1.0
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // Rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: scale, y: -scale))
        
        // Center the layer
        detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
        
        CATransaction.commit()
    }
    
    private func setupRequests() {
        // Get model URL
        guard let modelURL = Bundle.main.url(forResource: "TSRv3copy", withExtension: "mlmodelc") else { return }
        
        // Create desired model
        guard let model = try? VNCoreMLModel(for: MLModel(contentsOf: modelURL)) else { return }
        
        for _ in 0 ..< CameraViewController.maxRequests {
            let request = VNCoreMLRequest(model: model, completionHandler: self.processDetections(for:error:))
            request.imageCropAndScaleOption = .centerCrop
            self.requests.append(request)
        }
        
//        let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
//            self?.processDetections(for: request, error: error)
//        })
//
//        request.imageCropAndScaleOption = .scaleFit
    }
    
    func loadCamera() {
        guard let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .back).devices.first else { return }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("NO CAMERA DETECTED")
            return
        }
        
        // Begin session config
        self.session.beginConfiguration()
        self.session.sessionPreset = .hd1920x1080
        
        guard self.session.canAddInput(videoDeviceInput) else {
            NSLog("Could not add video device input to the session")
            self.session.commitConfiguration()
            return
        }
        // Add video input
        self.session.addInput(videoDeviceInput)
        
        if session.canAddOutput(self.videoDataOutput) {
            // Add a video data output
            self.session.addOutput(videoDataOutput)
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
        } else {
            NSLog("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        guard let captureConnection = videoDataOutput.connection(with: .video) else { return }
        
        // Always process the frames
        captureConnection.isEnabled = true
        
        do {
            try videoDevice.lockForConfiguration()
            
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice.activeFormat.formatDescription))
            // Read frame dimensions
            self.bufferSize.width = CGFloat(dimensions.width)
            self.bufferSize.height = CGFloat(dimensions.height)
            
            videoDevice.unlockForConfiguration()
        } catch {
            NSLog(error.localizedDescription)
        }
        
        // Save session config
        session.commitConfiguration()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        rootLayer = view.layer
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Get buffer with image data
        guard let buffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            NSLog("Error: Failed to get image buffer: \(#line)")
            
            return
        }
        
        guard let uiImage = UIImage(pixelBuffer: buffer) else {
            return
        }
        
        self.updateDetections(for: uiImage)
    }
    
    private func updateDetections(for image: UIImage) {
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else {
            fatalError("Unable to read device orientation.")
        }
        
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            let request = self.requests[self.currentRequestIndex]
            
            self.currentRequestIndex += 1
            
            if self.currentRequestIndex >= CameraViewController.maxRequests {
                self.currentRequestIndex = 0
            }
            
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform detection.\n\(error.localizedDescription)")
            }
        }
    }
    
    private func processDetections(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                if error != nil {
                    print("Unable to detect anything.\n\(error!.localizedDescription)")
                } else {
                    print("Unable to detect anything.\nNo Errors")
                }
                
                CATransaction.begin()
                CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
                
                // Remove previous bounding boxes
                self.detectionOverlay.sublayers = nil
                
                CATransaction.commit()
                
                return
            }
            
            // Parse result, to get detections
            let detections = results as! [VNRecognizedObjectObservation]
            self.drawBoxes(detections: detections)
        }
    }
    
    func drawBoxes(detections: [VNRecognizedObjectObservation]) {
        for detection in detections {
            for label in detection.labels {
                if !label.confidence.isLess(than: 0.85) {
                    // Uncomment next 2 lines to print output
                    print("\(label.identifier) confidence: \(label.confidence)")
                    print("-------------------")
                    
                    let box = BoundingBox()
                    box.addToLayer(self.detectionOverlay)
                    
                    // The coordinates are normalized to the dimensions of the processed image, with the origin at the image's lower-left corner.
                    let boundingBox = VNImageRectForNormalizedRect(detection.boundingBox, Int(self.bufferSize.width), Int(self.bufferSize.height))
                    
                    let detectionType = ObservationTypeEnum(fromRawValue: "\(label.identifier)")
                    
                    let boxColor = detectionType.getColor()
                    
                    box.show(frame: boundingBox, label: detection.labels.first?.identifier ?? "Object", color: boxColor)
                    box.textLayer.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), 1, -1, 1)
                }
            }
        }
    }
    
    // Specify device orientation
    private func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
}
