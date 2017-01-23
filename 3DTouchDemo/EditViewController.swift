//
//  EditViewController.swift
//  3DTouchDemo
//
//  Created by Juan Catalan on 1/22/17.
//  Copyright © 2017 Bitcrafters, Inc. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class EditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var detail: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var favorite: UISwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var activeTextField: UITextField?
    let datePicker = UIDatePicker()

    var asset = Asset()
    var index: Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        if let index = index {
            asset = AssetStorage.sharedStorage.asset(atIndex: index)
            name.text = asset.name
            detail.text = asset.detail
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            date.text = dateFormatter.string(from: asset.date)
            favorite.isOn = asset.favorite
            thumbnail.image = UIImage(data: asset.imageData)
            datePicker.date = asset.date
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(datePickerAction), for: .valueChanged)
            date.inputView = datePicker
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Image selection
    
    
    // MARK: - Textfield and keyboard
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func datePickerAction(picker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        date.text = dateFormatter.string(from: picker.date)
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.scrollRectToVisible(name.frame, animated: false)
    }
    
    func keyboardDidShow(_ notification: Notification) {
        if let info = notification.userInfo {
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height - toolbar.frame.height, 0.0)
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
            var visibleRect = self.containerView.frame
            visibleRect.size.height -= contentInsets.bottom
            let activeTextFieldFrame = activeTextField!.frame
            let activeTextFieldBottom = CGPoint(x: activeTextFieldFrame.minX, y: activeTextFieldFrame.maxY)
            if !visibleRect.contains(activeTextFieldBottom) {
                scrollView.scrollRectToVisible(activeTextFieldFrame, animated: true)
            }
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        NotificationCenter.default.removeObserver(self)
        if let identifier = segue.identifier {
            if identifier == "EditSaveSegue" {
                guard
                    let name = name.text,
                    let detail = detail.text,
                    let image = thumbnail.image,
                    let data = UIImagePNGRepresentation(image)
                else {
                    return
                }
                asset.name = name
                asset.detail = detail
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                asset.date = dateFormatter.date(from: date.text!)!
                asset.favorite = favorite.isOn
                asset.imageData = data
            }
        }
    }
}

extension EditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func selectPicture() {
        self.view.endEditing(true)
        perform(#selector(checkAuthorizationStatusAndShowPhotoPicker), with: nil, afterDelay: 0.3)
    }
    
    func checkAuthorizationStatusAndShowPhotoPicker()  {
        
        let cameraMediaType = AVMediaTypeVideo
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: cameraMediaType)
        
        switch cameraAuthorizationStatus {
            
        case .authorized:
            showCameraUserInterface()
            
        case .restricted:
            // Handle the user has restricted access to the camera (parental controls)
            break
            
        case .denied:
            // Handle the case the user denied access to the camera
            break
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(forMediaType: cameraMediaType) { granted in
                if granted {
                    self.showCameraUserInterface()
                } else {
                    // Handle the case the user denied access to the camera
                }
            }
        }
    }
    
    func showCameraUserInterface() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        thumbnail.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

