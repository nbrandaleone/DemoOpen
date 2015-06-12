//
//  DetailViewController.swift
//  SpotDemo
//
//  Created by Nick Brandaleone on 6/4/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*  This View Controller handles the secondary views that "pops" in
    via the custom transition.

    The image from the Main/Menu VC is shown here expanded. Title and summary text
    is slided into place using constraints based animation. */


import UIKit

class DetailViewController: UIViewController, ZoomingIconViewController {
    
    var item: SocialItem?
    
    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var backButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var summaryLabelBottomConstraint: NSLayoutConstraint!
    
    @IBAction func handleBackButton(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let item = self.item {
            coloredView.backgroundColor = item.color
            imageView.image = item.image
            
            titleLabel.text = item.name
            summaryLabel.text = item.summary
        }
        else {
            coloredView.backgroundColor = UIColor.grayColor()
            imageView.image = nil
            
            titleLabel.text = nil
            summaryLabel.text = nil
        }
    }
    
    // We animate the labels, so I set up initial constraints off screen
    func setupState(initial: Bool) {
        if initial {
            backButtonTopConstraint.constant = -64
            summaryLabelBottomConstraint.constant = -200
        }
        else {
            backButtonTopConstraint.constant = 20
            summaryLabelBottomConstraint.constant = 80
        }
        view.layoutIfNeeded()
    }

    // This optional function pushes the labels into place.
    // Handles push/pop direction by calling "setupState" helper function.
    func zoomingIconTransition(transition: ZoomingIconTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool) {
        
        setupState(operation == .Push)
        
        UIView.animateWithDuration(0.6, delay: operation == .Push ? 0.2 : 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
            [self]
            self.setupState(operation == .Pop)
            }) { (finished) -> Void in
        }
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
// MARK: Protocol Methods
    func zoomingIconColoredViewForTransition(transition: ZoomingIconTransition) -> UIView! {
        return coloredView
    }
    
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView! {
        return imageView
    }

}
