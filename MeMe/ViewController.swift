//
//  ViewController.swift
//  Image Picker experiment
//
//  Created by Andreas Pfister on 04/05/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var mySelectedImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable Camera Button in toolbar in case there is no Camera supported by the current used device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // Set initial values and properties of the textfields
        
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        
        topText.delegate = self
        bottomText.delegate = self

        //bottomToolbar.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)

    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)

    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        //self.view.frame.origin.y += getKeyboardHeight(notification)
        self.view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    @IBAction func pickImageFromAlbum(sender:AnyObject) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        mySelectedImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        //Create the meme
        var meme = Meme( text: textField.text!, image:
            imageView.image, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage
    {
        bottomToolbar.hidden = true
        navigationController?.setNavigationBarHidden(hidden: true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        bottomToolbar.hidden = false
        navigationController?.setNavigationBarHidden(hidden: false, animated: false)
        
        
        return memedImage
    }
   
}

