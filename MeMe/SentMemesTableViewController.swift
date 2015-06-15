//
//  SentMemesViewController.swift
//  MeMe
//
//  Created by Andreas Pfister on 13/06/15.
//  Copyright (c) 2015 iOS Development Blog. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var EditButton: UIBarButtonItem!
    var editModeEnabled: Bool = false
    var memes = [MeMe]()
    
    override func viewWillAppear(animated: Bool) {
        //pull the MeMes from the AppDelegate
        syncMemesFromAppDelegate()
        tableView.reloadData()
        EditButton.enabled = (memes.count > 0)
    }

    func syncMemesFromAppDelegate() {
        //help function to sync between "local" meme array and AppDelegate meme array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    func syncMemesToAppDelegate() {
        //help function to sync between "local" meme array and AppDelegate meme array
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes = memes
    }
    
    @IBAction func editTableView(sender: AnyObject) {
        //handle visibility and text of Edit Button, also (re-)set the tableView to/from edit mode
        if(editModeEnabled == false) {
            self.tableView.setEditing(true, animated: true)
            EditButton.title = "Done"
            EditButton.style = .Done
        } else {
            EditButton.title = "Edit"
            EditButton.style = .Plain
            self.tableView.setEditing(false, animated: true)
        }
        editModeEnabled = !editModeEnabled
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        memes.removeAtIndex(indexPath.row)
        syncMemesToAppDelegate()
        EditButton.enabled = (memes.count > 0)
        tableView.reloadData()
    }
    
    @IBAction func newMeMe(sender: AnyObject) {
        //get the MeMeComposer as modal View
        let meMeComposer = storyboard!.instantiateViewControllerWithIdentifier("MeMeComposer") as! UIViewController
        self.presentViewController(meMeComposer, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("AMeMe") as! UITableViewCell
        
        cell.textLabel!.text = memes[indexPath.row].topText
        cell.detailTextLabel!.text = memes[indexPath.row].bottomText
        cell.imageView?.image = memes[indexPath.row].meMeImage
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Put the preview for the selected MeMe onto the navigationController stack
        // Set the image already in that view
        // suggested (future) TODO: add ability to change the already sent MeMe and give the opportunity to resent it
        // ... by passing the whole MeMe object and put an Edit button into the Preview 
        // which will open up the MeMeEditor again
        let meMePreview = storyboard?.instantiateViewControllerWithIdentifier("MeMePreview") as! previewMemeViewController
        meMePreview.meMeIndex = indexPath.row
        self.navigationController?.pushViewController(meMePreview, animated: true)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    
}