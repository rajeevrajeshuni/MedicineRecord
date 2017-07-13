//
//  CameraViewController.swift
//  MedicineRecord
//
//  Created by Rajeev Rajeshuni on 12/26/17.
//  Copyright © 2017 Rajeev Rajeshuni. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import RealmSwift
import Photos
class CameraViewController: UIViewController {
    var capturesession = AVCaptureSession()
    var currentCamera:AVCaptureDevice?
    var frontCamera:AVCaptureDevice?
    var backCamera:AVCaptureDevice?
    var photoOutput:AVCapturePhotoOutput?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var image:UIImage?
    var user:User!
    var realm = try! Realm()
    @IBOutlet weak var PhotoCaptureButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //
        setupCaptureSession()
        setupCaptureDevice()
        setupInputOutput()
        setupPreviewLayer()
        StartRunningCaptureSession()
        
        //Askforpermissions()
    }
    func clearDatabase()
    {
        if(UserDefaults.standard.bool(forKey: "HasDataWhenLaunched")==false)
        {
            UserDefaults.standard.set(true, forKey: "HasLaunchedOnce")
            realm.deleteAll()
        }
    }
    func setupCaptureSession()
    {
        capturesession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupCaptureDevice()
    {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        for device in deviceDiscoverySession.devices{
            if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
            else if device.position == AVCaptureDevice.Position.back{
                backCamera = device
            }
        }
        currentCamera = backCamera
    }
    func setupInputOutput()
    {
        do{
           let CaptureDeviceInput =  try AVCaptureDeviceInput(device: currentCamera!)
            capturesession.addInput(CaptureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            capturesession.addOutput(photoOutput!)
        }
        catch{
            print("Error!!")
        }
    }
    func setupPreviewLayer()
    {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session:capturesession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func StartRunningCaptureSession()
    {
        capturesession.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CameraButton_TouchUpInside(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        let medicineSlotsAvailable = MedicineSlot.isEmpty(in: realm)
        if(medicineSlotsAvailable)
        {
            showAlert(with: "Add Medicine Slots to record medicine intake.")
        }
        else
        {
            self.photoOutput?.capturePhoto(with: settings, delegate:self)
        }
    }
    func showAlert(with text:String){
        let alert = UIAlertController(title:text,message:"",preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    }
    override func prepare(for segue:UIStoryboardSegue, sender:Any?)
    {
        if segue.identifier == "ConfirmImageSegue" {
            let NavigationController = segue.destination as! UINavigationController
            let destinationVC = NavigationController.topViewController as! ConfirmImageViewController
            destinationVC.image = self.image
        }
    }
    /*func Askforpermissions()
    {
        PHPhotoLibrary.requestAuthorization(<#T##handler: (PHAuthorizationStatus) -> Void##(PHAuthorizationStatus) -> Void#>)
    }*/
}
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            //print(imageData)
            self.image = UIImage(data: imageData)
        }
        performSegue(withIdentifier: "ConfirmImageSegue", sender: nil)
    }
}
