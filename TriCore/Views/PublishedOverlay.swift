//
//  PublishedOverlay.swift
//  TriCore
//
//  Created by Kyle Zawacki on 8/19/15.
//  Copyright © 2015 University Of Wisconsin Parkside. All rights reserved.
//

import UIKit

class PublishedOverlay: UIView
{
    override func drawRect(rect: CGRect)
    {
        self.alpha = 0.8
    }
    
    static func showCompleted()
    {
        TAOverlay.showOverlayWithLabel("Published!", options: [TAOverlayOptions.OverlayTypeSuccess,
            TAOverlayOptions.OpaqueBackground, TAOverlayOptions.OverlaySizeRoundedRect, TAOverlayOptions.AllowUserInteraction])
    }
    
    static func showPublishing()
    {
        TAOverlay.showOverlayWithLabel("Publishing", options: [TAOverlayOptions.OverlayTypeActivityLeaf,
            TAOverlayOptions.OpaqueBackground, TAOverlayOptions.OverlaySizeRoundedRect])
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        TAOverlay.hideOverlay()
    }
}
