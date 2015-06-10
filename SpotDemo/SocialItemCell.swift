//
//  SocialItemCell.swift
//  ZoomingIcons
//
//  Created by Nick Brandaleone on 6/4/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

import UIKit

/*
This is the collection view cell. It is used on the first screen.
There is an image, and a matching background color.
We warp the cornerRadius of the background color layer to make it appear round.
*/

class SocialItemCell: UICollectionViewCell {

    @IBOutlet weak var coloredView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    var item: SocialItem? {
        didSet {
            if let item = item {
                coloredView.backgroundColor = item.color
                imageView.image = item.image
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        coloredView.layer.cornerRadius = bounds.width/2.0
        coloredView.layer.masksToBounds = true
    }
}
