//
//  ViewController.swift
//  QR-Map
//
//  Created by soliduSystem on 27/03/23.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController {

    // MARK: - Override Func
    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        self.startRunningCaptureSession()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startRunningCaptureSession()
        
        let newView = UIImageView(frame: CGRect(
            x: self.view.frame.width*0.15,
            y: self.view.frame.height/2-self.view.frame.width*0.3,
            width: self.view.frame.width*0.7,
            height: self.view.frame.width*0.7))
        
        newView.image = UIImage(systemName: "viewfinder")
        newView.tintColor = .white
        newView.contentMode = .scaleAspectFit
        
        view.addSubview(newView)
        
        metadataOutput.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: CGRect(
            x: self.view.frame.width*0.15,
            y: self.view.frame.height/2-self.view.frame.width*0.3,
            width: self.view.frame.width*0.7,
            height: self.view.frame.width*0.7))
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stopRunningCaptureSession()
    }
    
    // MARK: - IBOutlet
    
    
    // MARK: - Public let / var
    var captureSession: AVCaptureSession! = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    var delegate : ScannerViewDelegate?
    
    let metadataOutput: AVCaptureMetadataOutput = AVCaptureMetadataOutput()

    
    // MARK: - Private let / var
    
    
    // MARK: - IBAction
    
    func failed() {
        let ac = UIAlertController(title: "Escaneo no compatible", message: "Su dispositivo no admite escanear un código. Utilice un dispositivo con cámara.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
 
    
    public func startRunningCaptureSession () -> Void {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    public func stopRunningCaptureSession () -> Void {
        if (captureSession?.isRunning == true) {
            DispatchQueue.global().async {
                self.captureSession.stopRunning()
            }
        }
    }
}


extension ScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        self.stopRunningCaptureSession()

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            self.delegate?.didscanned(code: stringValue)
            self.dismiss(animated: true)            
        }
    }
}



