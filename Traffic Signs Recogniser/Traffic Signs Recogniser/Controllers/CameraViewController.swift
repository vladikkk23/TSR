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
    // MARK: - Properties
    var bufferSize: CGSize = .zero
    var rootLayer: CALayer! = nil
    
    private var detectionOverlay: CALayer! = nil
    
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoOutputQueue = DispatchQueue(label: "Video_Output")
    
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil
    
    var currentRequestIndex = 0
    
    // Max detections at same time
    static let maxDetections = 3
    
    var boundingBoxes: [BoundingBox]!
    
    // Initializing request handler
    var request: VNCoreMLRequest!
    
    // Store all detections for current request
    var detections: [VNRecognizedObjectObservation]!
    
    // Store last sign
    private var lastSign: String!
    
    // User settings
    private var playSound: Bool!
    
    // MARK: - Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set sign notification sound
        self.playSound = UserDefaults.standard.bool(forKey: "warnings")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupRequests()
        self.setupCamra()
        self.setupLayers()
        self.updateLayerGeometry()
        
        self.setupBoundingBoxes()
        
        self.session.startRunning()
    }
    
    func setupLayers() {
        self.detectionOverlay = CALayer()
        self.detectionOverlay.name = "DetectionOverlay"
        self.detectionOverlay.bounds = CGRect(x: 0.0, y: 0.0, width: bufferSize.width, height: bufferSize.height)
        self.detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        self.rootLayer.addSublayer(detectionOverlay)
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
        
        self.request = VNCoreMLRequest(model: model, completionHandler: self.processDetections(for:error:))
        self.request.imageCropAndScaleOption = .centerCrop
    }
    
    func setupBoundingBoxes() {
        self.boundingBoxes = [BoundingBox]()
        
        for _ in 0 ..< CameraViewController.maxDetections {
            let boundingBox = BoundingBox()
            boundingBox.textLayer.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), 1, -1, 1)
            
            self.boundingBoxes.append(boundingBox)
        }
    }
    
    func setupCamra() {
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
            self.videoDataOutput.alwaysDiscardsLateVideoFrames = true
            self.videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            self.videoDataOutput.setSampleBufferDelegate(self, queue: self.videoOutputQueue)
        } else {
            NSLog("Could not add video data output to the session")
            self.session.commitConfiguration()
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
        self.session.commitConfiguration()
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.rootLayer = view.layer
        self.previewLayer.frame = rootLayer.bounds
        self.rootLayer.addSublayer(previewLayer)
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
            
            do {
                try handler.perform([self.request])
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
            if let detections = results as? [VNRecognizedObjectObservation] {
                self.drawBoxes(detections: detections)
            } else {
                print("Unable to detect anything.\nNo Errors")
            }
        }
    }
    
    func drawBoxes(detections: [VNRecognizedObjectObservation]) {
        if detections.count < 1 {
            // Remove previous bounding boxes
            self.detectionOverlay.sublayers = nil
        } else {
            self.detections = detections
            
            var goodDetections = [VNRecognizedObjectObservation]()
            
            // Select best detections
            for detection in detections {
                for label in detection.labels {
                    if !label.confidence.isLess(than: 0.85) {
                        goodDetections.append(detection)
                    }
                }
            }
            
            // Show bounding boxes
            for index in 0 ..< boundingBoxes.count {
                if index < goodDetections.count {
                    // Don't notify user about signs that repeat
                    if self.lastSign != goodDetections[index].labels.first!.identifier {
                        self.lastSign = goodDetections[index].labels.first!.identifier
                        
                        if self.playSound {
                            AudioServicesPlayAlertSound(SystemSoundID(1322))
                        }
                    }
                    
                    // The coordinates are normalized to the dimensions of the processed image, with the origin at the image's lower-left corner.
                    let boundingBox = VNImageRectForNormalizedRect(goodDetections[index].boundingBox, Int(self.bufferSize.width), Int(self.bufferSize.height))
                    
                    let detectionType = ObservationTypeEnum(fromRawValue: "\(goodDetections[index].labels.first!.identifier)")
                    
                    let boxColor = detectionType.getColor()
                    
                    self.boundingBoxes[index].show(frame: boundingBox, label: goodDetections[index].labels.first!.identifier, color: boxColor)
                    
                    // Add the bounding boxes to detection layer
                    self.boundingBoxes[index].addToLayer(self.detectionOverlay)
                    
                    // Uncomment next 2 lines to print detections output
                    // print("\(goodDetections[index].labels.first!.identifier) confidence: \(goodDetections[index].labels.first!.confidence)")
                    // print("-------------------")
                } else {
                    self.boundingBoxes[index].hide()
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
