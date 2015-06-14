//
//  PreviewMeMe.swift
//  MeMe
//
//  Created by Andreas Pfister on 14/06/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit

class previewMemeViewController: UIViewController, UIActionSheetDelegate {
    
    @IBOutlet weak var previewImage: UIImageView!
    var meMeIndex: Int?
    var memes = [MeMe]()
    var appDelegate: AppDelegate!
    @IBOutlet var DeleteButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        let object = UIApplication.sharedApplication().delegate
        appDelegate = object as! AppDelegate
        previewImage.image = appDelegate.memes[meMeIndex!].meMeImage
        navigationItem.rightBarButtonItem = DeleteButton
    }
    
    @IBAction func deleteMeMe(sender: AnyObject) {
        let actionSheet = UIActionSheet(title: "Do you want to permanently delete this MeMe ?", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Confirm")
        actionSheet.actionSheetStyle = .Default
        actionSheet.showInView(self.view)
    }

    func actionSheet(actionSheet: UIActionSheet, didDismissWithButtonIndex buttonIndex: Int) {
        println("alles gut="+String(buttonIndex))
        
        switch buttonIndex {
            
        case 0:
            //confirm deletion
            appDelegate.memes.removeAtIndex(meMeIndex!)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            //actually, do nothing, just react on button Confirm, above !
            let a=1
        }

    }
}