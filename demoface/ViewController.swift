//
//  ViewController.swift
//  demoface
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet var lblResult: UILabel!
    @IBOutlet var btnGallery: UIButton!
    @IBOutlet var btnDetect: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var faceDetectionRequest : VNDetectFaceRectanglesRequest? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
         faceDetectionRequest = {
         
         let faceRequest = VNDetectFaceRectanglesRequest(completionHandler:self.handleFaceDetection)
         
         return faceRequest
         
        }()
    }
    
    @IBAction func detect(_ sender: UIButton){
        if(self.imageView?.image == nil){
            let alert = UIAlertController(title: "Select image", message: "Please select image for detection", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            
            return
        }
        
          let faceImage = CIImage(image: imageView.image!)
        start(ciImage: faceImage!)
    }
    @IBAction func gallary(_ sender: UIButton){
        picImages()
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       // self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
          //
            
            return
        }
        self.imageView.image = image;
        
        picker.dismiss(animated: true) {
            self.detect(self.btnDetect!)
        }
       // self.pickerController(picker, didSelect: image)
    }
    
    func picImages(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }

    func start(ciImage: CIImage){
        //cgImage: cgImage, options: [:]
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        do {
            try handler.perform([self.faceDetectionRequest!])
        } catch {
            print("Failed to perform classification.\n\(error.localizedDescription)")
        }
    }
    
    func handleFaceDetection (request: VNRequest, error: Error?) {
        
        guard let observations = request.results as? [VNFaceObservation]
        else {
            print("unexpected result type from VNFaceObservation")
            return
        }

        DispatchQueue.main.async {
            if observations.count > 0 {
                self.lblResult.text = "\(observations.count) Human(s) face detected"
            }else {
                self.lblResult.text = "No Human face detected"

            }
            for face in observations
            {
//                let view = self.createBoxView(withColor: UIColor.red)
//                view.frame = self.transformRect(fromRect: face.boundingBox, toViewRect: self.yourImageView)
//                self.yourImageView.addSubview(view)
            }
        }
    }
    
    func transformRect(fromRect: CGRect , toViewRect :UIView) -> CGRect {
        
        //Convert Vision Frame to UIKit Frame
        
        var toRect = CGRect()
        toRect.size.width = fromRect.size.width * toViewRect.frame.size.width
        toRect.size.height = fromRect.size.height * toViewRect.frame.size.height
        toRect.origin.y =  (toViewRect.frame.height) - (toViewRect.frame.height * fromRect.origin.y )
        toRect.origin.y  = toRect.origin.y -  toRect.size.height
        toRect.origin.x =  fromRect.origin.x * toViewRect.frame.size.width
        return toRect
        
    }

    func createBoxView(withColor : UIColor) -> UIView {
        
        let view = UIView()
        view.layer.borderColor = withColor.cgColor
        view.layer.borderWidth = 2
        view.backgroundColor = UIColor.clear
        return view
    }

}

