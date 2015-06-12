//
//  ZoomingIconTransition.swift
//  SpotDemo
//
//  Created by Nick Brandaleone on 6/5/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*  
    Custom Animation for transitions.  Using iOS 7 feature (protocol: UIViewControllerAnimatedTransitioning), 
    allowing us to hook into modal system transitions, using our own animations.

    This turned out to be quite complicated...
    One needs a container view for the animations. I also used a matching background color view on
    both the initial/final views to make the animation appear seamless.

    I zoom or increase the size of the circular background view x15 by animation. We then are flipped
    into the new view (DetailedViewController). I then bring in the two text labels
    by altering their NSConstraints. There is also a "back" button for navigation. We are still using
    push/pop of views by a navigation controller under the hood.

    
*/

import UIKit

private let kZoomingIconTransitionDuration: NSTimeInterval = 0.6
private let kZoomingIconTransitionZoomedScale: CGFloat = 15
private let kZoomingIconTransitionBackgroundScale: CGFloat = 0.80

class ZoomingIconTransition: NSObject, UINavigationControllerDelegate, UIViewControllerAnimatedTransitioning {
    
    var operation: UINavigationControllerOperation = .None
    
    enum TransitionState {
        case Initial
        case Final
    }
    
    // We work with matching images/colors. Makes it easier to work with pair
    typealias ZoomingViews = (coloredView: UIView, imageView: UIView)
    
    
    // This is key to setting up the animation. We use implicit animation, so we just
    // need to configure original state and final state. Core Animation does the rest.
    func configureViewsForState(state: TransitionState, containerView: UIView, backgroundViewController: UIViewController, viewsInBackground: ZoomingViews, viewsInForeground: ZoomingViews, snapshotViews: ZoomingViews) {
        
        switch state {
        case .Initial:
            backgroundViewController.view.transform = CGAffineTransformIdentity
            backgroundViewController.view.alpha = 1
            
            snapshotViews.coloredView.transform = CGAffineTransformIdentity
            snapshotViews.coloredView.frame = containerView.convertRect(viewsInBackground.coloredView.frame, fromView: viewsInBackground.coloredView.superview)
            snapshotViews.imageView.frame = containerView.convertRect(viewsInBackground.imageView.frame, fromView: viewsInBackground.imageView.superview)
            
        case .Final:
            // We fade out from view and shrink it slightly
            backgroundViewController.view.transform = CGAffineTransformMakeScale(kZoomingIconTransitionBackgroundScale, kZoomingIconTransitionBackgroundScale)
            backgroundViewController.view.alpha = 0
            
            // We zoom the colored circle by x15 times
            // The center of circle stays on the image, making the zoom effect appear to pop from that point
            // The imageView rectangle expands, allowing the picture in it to also expand (aspectFill)
            snapshotViews.coloredView.transform = CGAffineTransformMakeScale(kZoomingIconTransitionZoomedScale, kZoomingIconTransitionZoomedScale)
            snapshotViews.coloredView.center = containerView.convertPoint(viewsInForeground.imageView.center, fromView: viewsInForeground.imageView.superview)
            snapshotViews.imageView.frame = containerView.convertRect(viewsInForeground.imageView.frame, fromView: viewsInForeground.imageView.superview)
            
        default:
            ()
        }
    }
    
    // Protocol requirement. How much time for the transition
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kZoomingIconTransitionDuration
    }
    
    // Protocol requirement. Custom animation
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let duration = transitionDuration(transitionContext)
        
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let containerView = transitionContext.containerView()
        
        var backgroundViewController = fromViewController
        var foregroundViewController = toViewController
        
        if operation == .Pop {
            backgroundViewController = toViewController
            foregroundViewController = fromViewController
        }
        
        // get the image view in the background and foreground view controllers
        let backgroundImageViewMaybe = (backgroundViewController as? ZoomingIconViewController)?.zoomingIconImageViewForTransition(self)
        let foregroundImageViewMaybe = (foregroundViewController as? ZoomingIconViewController)?.zoomingIconImageViewForTransition(self)
        
        assert(backgroundImageViewMaybe != nil, "Cannot find image view in background view controller")
        assert(foregroundImageViewMaybe != nil, "Cannot find image view in foreground view controller")
        
        let backgroundImageView = backgroundImageViewMaybe!
        let foregroundImageView = foregroundImageViewMaybe!
        
        // get the colored view in the background and foreground view controllers
        let backgroundColoredViewMaybe = (backgroundViewController as? ZoomingIconViewController)?.zoomingIconColoredViewForTransition(self)
        let foregroundColoredViewMaybe = (foregroundViewController as? ZoomingIconViewController)?.zoomingIconColoredViewForTransition(self)
        
        assert(backgroundColoredViewMaybe != nil, "Cannot find colored view in background view controller")
        assert(foregroundColoredViewMaybe != nil, "Cannot find colored view in foreground view controller")
        
        let backgroundColoredView = backgroundColoredViewMaybe!
        let foregroundColoredView = foregroundColoredViewMaybe!
        
        // create view snapshots
        // view controller need to be in view hierarchy for snapshotting (snapshotViewAfterScreenUpdates)
        // We create the snapshots for performnace reasons during animation
        containerView.addSubview(backgroundViewController.view)
        let snapshotOfColoredView = backgroundColoredView.snapshotViewAfterScreenUpdates(false)
        
        let snapshotOfImageView = UIImageView(image: backgroundImageView.image)
        snapshotOfImageView.contentMode = .ScaleAspectFit
        
        // setup animation. Hide views, use snapshots.
        backgroundColoredView.hidden = true
        foregroundColoredView.hidden = true
        
        backgroundImageView.hidden = true
        foregroundImageView.hidden = true
        
        // Add views in correct order. Background is white color
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.addSubview(backgroundViewController.view)
        containerView.addSubview(snapshotOfColoredView)
        containerView.addSubview(foregroundViewController.view)
        containerView.addSubview(snapshotOfImageView)
        
        // temporarily set the To view background color to clear
        let foregroundViewBackgroundColor = foregroundViewController.view.backgroundColor
        foregroundViewController.view.backgroundColor = UIColor.clearColor()
        
        var preTransitionState = TransitionState.Initial
        var postTransitionState = TransitionState.Final
        
        if operation == .Pop {
            preTransitionState = TransitionState.Final
            postTransitionState = TransitionState.Initial
        }
        
        configureViewsForState(preTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundColoredView, backgroundImageView), viewsInForeground: (foregroundColoredView, foregroundImageView), snapshotViews: (snapshotOfColoredView, snapshotOfImageView))
        
        // perform animation in Detail View Controller. Slide labels into place.
        (backgroundViewController as? ZoomingIconViewController)?.zoomingIconTransition?(self, willAnimateTransitionWithOperation: operation, isForegroundViewController: false)
        (foregroundViewController as? ZoomingIconViewController)?.zoomingIconTransition?(self, willAnimateTransitionWithOperation: operation, isForegroundViewController: true)
        
        // need to layout now if we want the correct parameters for frame
        // This is in case the foreground has not been called yet (getting params from IB, for example)
        foregroundViewController.view.layoutIfNeeded()
        
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .allZeros, animations: { () -> Void in
            [self]
            self.configureViewsForState(postTransitionState, containerView: containerView, backgroundViewController: backgroundViewController, viewsInBackground: (backgroundColoredView, backgroundImageView), viewsInForeground: (foregroundColoredView, foregroundImageView), snapshotViews: (snapshotOfColoredView, snapshotOfImageView))
            
            }, completion: {
                (finished) in
                
                backgroundViewController.view.transform = CGAffineTransformIdentity
                
                // Remove snapshots, and expose view. Foreground is on top.
                snapshotOfColoredView.removeFromSuperview()
                snapshotOfImageView.removeFromSuperview()
                
                backgroundColoredView.hidden = false
                foregroundColoredView.hidden = false
                
                backgroundImageView.hidden = false
                foregroundImageView.hidden = false
                
                // Change foreground color from clear to its proper color
                foregroundViewController.view.backgroundColor = foregroundViewBackgroundColor
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    // Delegate Method
    // If test fails, we return nil, and fall back on the system transition.
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        // protocol needs to be @objc for conformance testing
        if fromVC is ZoomingIconViewController &&
            toVC is ZoomingIconViewController {
                self.operation = operation
                return self
        }
        else {
            return nil
        }
    }
}

// Fow now, optional functions are only supported in Objectice-C, not Swift.
@objc
protocol ZoomingIconViewController {
    func zoomingIconColoredViewForTransition(transition: ZoomingIconTransition) -> UIView!
    func zoomingIconImageViewForTransition(transition: ZoomingIconTransition) -> UIImageView!
    
    optional
    func zoomingIconTransition(transition: ZoomingIconTransition, willAnimateTransitionWithOperation operation: UINavigationControllerOperation, isForegroundViewController isForeground: Bool)
}