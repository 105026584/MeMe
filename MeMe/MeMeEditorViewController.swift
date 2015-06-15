//
//  ViewController.swift
//  MeMe
//
//  Created by Andreas Pfister on 13/06/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import UIKit

class MeMeEditorViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    let defaultText = "type here"
    
    @IBOutlet weak var mySelectedImage: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var initialMessage: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var shareMeMeButton: UIBarButtonItem!
    
    @IBAction func shareMeMe(sender: AnyObject) {
        
        //Create the MeMe and store it in the global Array of MeMe's
        var meMeImage = generateMemedImage()
        var meme = MeMe(
            topText: topText.text,
            bottomText: bottomText.text,
            originalImage: mySelectedImage.image!,
            meMeImage: meMeImage
        )
        
        //pass the generated image to the ActivityView
        let myActivityView = UIActivityViewController(activityItems: [meMeImage], applicationActivities: nil)
        self.presentViewController(myActivityView, animated: true, completion: nil)
        //check on success and dismiss editor in case it worked out, also "just" apply the MeMe object to the global array in such a case, otherwise it is like a cancellation
        myActivityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success == true) {
                let object = UIApplication.sharedApplication().delegate
                let appDelegate = object as! AppDelegate
                appDelegate.memes.append(meme)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    // create the textfield attributes objects
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
        
        //Setting the defaultAttributes and visibility for the textfields
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .Center
        bottomText.textAlignment = .Center
        initialMessage.text = (cameraButton.enabled ? "Take a picture with your camera or select an image from your album" : "Select an image from your album")
        initialMessage.hidden = false
        topText.hidden = true
        bottomText.hidden = true
        shareMeMeButton.enabled = false

        //delegates for the textboxes
        topText.delegate = self
        bottomText.delegate = self
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // start observing required keyboard behaviour
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // stop observing required keyboard behaviour
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        //just empty the field in case the content does not match "type here"
        if(textField.text == defaultText) {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //put default Text in case the textfield is empty to prevent loss of visbility
        if(textField.text == ""){
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // in case Return got hit on the report, editing will end
        self.view.endEditing(true)
        return false
    }
    
    // the following functions are required to change the y of the whole frame, moving up the whole frame by the height of the keyboard to avoid overlay of textfields by the keyboard
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
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
        self.view.frame.origin.y = 0.0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    @IBAction func pickImageFromAlbum(sender:AnyObject) {
        // ImagePicker instance for photo library only
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        // ImagePicker instance, take camera
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        //set the ImageView.image to the selected/taken image
        let myImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        mySelectedImage.image = myImage
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        //set the proper visibility for the textfields
        initialMessage.hidden = true
        topText.hidden = false
        bottomText.hidden = false
        shareMeMeButton.enabled = true
        
        //TODO - position the textfields within the image itself ( not only imageView )
    }
    
    @IBAction func cancelComposer(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    func generateMemedImage() -> UIImage
    {
        //hide the navigationitems before taking a "snapshot"
        bottomToolbar.hidden = true
        navigationBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //"snapshot" taken, time to bring back the navigationitems
        bottomToolbar.hidden = false
        navigationBar.hidden = false
        
        return memedImage
    }
    
}

