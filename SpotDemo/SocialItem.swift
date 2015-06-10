//
//  SocialItem.swift
//  SpotDemo
//
//  Created by Nick Brandaleone on 6/4/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

/*
    The model for the zoomed-in screen.  Two labels, an image and matching background color.
*/

import UIKit

struct SocialItem {
    let image: UIImage?
    let color: UIColor
    let name: String
    let summary: String
}