//
//  MenuViewController.swift
//  ZoomingIcons
//
//  Created by Nick Brandaleone on 6/4/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*
    This is the main screen.  It shows various target markets that a customer can choose to find parking.
    For demo purposes, I have created New York, and Boston.  The others are social media sites.

    I use a CollectionView to make the layout more flexible.
    When a user clicks on a cirlce, we launch a custom animation which will bring us into the next screen,
    which is handled by the DetailViewController.

    The animation is inspired by the Twitter app.
*/

import UIKit

let reuseIdentifier = "Cell"

class MenuViewController: UICollectionViewController, ZoomingIconViewController {

    // for zooming in custom transition animation
    var selectedIndexPath: NSIndexPath?
    
    let items = [
        SocialItem(image: UIImage(named: "boston-icon"), color: UIColor(red: 130.0/255.0, green: 209.0/255.0, blue: 216.0/255.0, alpha: 1), name: "Boston", summary: "Boston is a world class city, with parking problems to match."),
        SocialItem(image: UIImage(named: "nyc-icon"), color: UIColor(red: 3.0/255.0, green: 50.0/255.0, blue: 81.0/255.0, alpha: 1), name: "New York City", summary: "New York City needs no introduction. Nick lived here for many years. 'Nuff said."),
        SocialItem(image: UIImage(named: "icon-twitter"), color: UIColor(red: 0.255, green: 0.557, blue: 0.910, alpha: 1), name: "Twitter", summary: "Twitter is an online social networking service that enables users to send and read short 140-character messages called \"tweets\"."),
        SocialItem(image: UIImage(named: "icon-facebook"), color: UIColor(red: 0.239, green: 0.353, blue: 0.588, alpha: 1), name: "Facebook", summary: "Facebook (formerly thefacebook) is an online social networking service headquartered in Menlo Park, California. Its name comes from a colloquialism for the directory given to students at some American universities."),
        SocialItem(image: UIImage(named: "icon-youtube"), color: UIColor(red: 0.729, green: 0.188, blue: 0.180, alpha: 1), name: "Youtube", summary: "YouTube is a video-sharing website headquartered in San Bruno, California. The service was created by three former PayPal employees in February 2005 and has been owned by Google since late 2006. The site allows users to upload, view, and share videos."),
        SocialItem(image: UIImage(named: "icon-vimeo"), color: UIColor(red: 0.329, green: 0.737, blue: 0.988, alpha: 1), name: "Vimeo", summary: "Vimeo is a U.S.-based video-sharing website on which users can upload, share and view videos. Vimeo was founded in November 2004 by Jake Lodwick and Zach Klein."),

    ]
    
/*  
    SocialItem(image: UIImage(named: "icon-instagram"), color: UIColor(red: 0.325, green: 0.498, blue: 0.635, alpha: 1), name: "Instagram", summary: "Instagram is an online mobile photo-sharing, video-sharing and social networking service that enables its users to take pictures and videos, and share them on a variety of social networking platforms, such as Facebook, Twitter, Tumblr and Flickr.")
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        collectionView?.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 2
    }

    // Hard-coded the number of sections for demo purposes only
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        switch section {
        case 0: return 2
        case 1: return 3
        default: return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SocialItemCell
        
        // Configure the cell
        var index = 0
        for s in 0..<indexPath.section {
            index += self.collectionView(collectionView, numberOfItemsInSection: s)
        }
        index += indexPath.item
        
        let item = items[index]
        cell.item = item
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    
    // MARK: UICollectionViewDelegate
    
    // programatically set up next VC. I can accomplish this with Segue as well.
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath
        
        var index = 0
        for s in 0..<indexPath.section {
            index += self.collectionView(collectionView, numberOfItemsInSection: s)
        }
        index += indexPath.item
        
        let item = items[index]
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        controller.item = item
        
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: Customization of spacing
    
    // Determine on a per section (i.e. row) basis the left/right insets
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth = layout.itemSize.width

        let numberOfCells = self.collectionView(collectionView, numberOfItemsInSection:section)
        
        // We calculate the width required by the cells and the spacing between them
        let widthOfCells = CGFloat(numberOfCells) * layout.itemSize.width + CGFloat(numberOfCells-1) * layout.minimumInteritemSpacing

        let inset = (collectionView.bounds.width - widthOfCells) / 2.0

        return UIEdgeInsets(top: 0, left: inset, bottom: 40, right: inset)
    }
    
    // MARK: Protocol Methods. Zooming functionality for custom transitions
    func zoomingIconColoredViewForTransition(transition: ZoomingIconTransition) -> UIView! {
        if let indexPath = selectedIndexPath {
            let cell = collectionView!.cellForItemAtIndexPath(indexPath)as! SocialItemCell
            return cell.coloredView
        }
        else {
            return nil
        }
    }
    
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView! {
        if let indexPath = selectedIndexPath {
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! SocialItemCell
            return cell.imageView
        }
        else {
            return nil
        }
    }
}
