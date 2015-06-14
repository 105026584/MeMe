//
//  SentMemesCollectionViewController.swift
//  MeMe
//
//  Created by Andreas Pfister on 14/06/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController : UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var memes = [MeMe]()
    var editModeEnabled: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        //pull the MeMes from the AppDelegate
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        // reload the view to show new added memes
        collectionView?.reloadData()
    }
    
    @IBAction func newMeMe(sender: AnyObject) {
        var meMeComposer = storyboard!.instantiateViewControllerWithIdentifier("MeMeComposer") as! UIViewController
        //self.presentViewController(meMeComposer, animated: true, completion: nil)
        //self.navigationController?.pushViewController(meMeComposer, animated: true)
        self.presentViewController(meMeComposer, animated: true, completion: nil)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("AMeMe", forIndexPath: indexPath) as! MeMeCollectionViewCell
        cell.imageView.image = memes[indexPath.row].meMeImage
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Put the preview for the selected MeMe onto the navigationController stack
        // Set the image already in that view
        // suggested (future) TODO: add ability to change the already sent MeMe and give the opportunity to resent it
        // ... by passing the whole MeMe object and put an Edit button into the Preview
        // which will open up the MeMeEditor again
        let meMePreview = storyboard?.instantiateViewControllerWithIdentifier("MeMePreview") as! previewMemeViewController
        meMePreview.meMeIndex = indexPath.row
        self.navigationController?.pushViewController(meMePreview, animated: true)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
}