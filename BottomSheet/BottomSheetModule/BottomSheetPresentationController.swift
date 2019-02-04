//
//  BottomSheetPresentationController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class BottomSheetPresentationController: UIPresentationController {
    var touchForwardingView: TouchForwardingView!

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let height: CGFloat = 500

        return CGRect(x: 0,
                      y: containerView.bounds.height - height,
                      width: containerView.bounds.width,
                      height: height)
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        touchForwardingView = TouchForwardingView(frame: containerView!.bounds)
        touchForwardingView.destinationView = presentingViewController.view
        containerView?.insertSubview(touchForwardingView, at: 0)
    }

    // Responds to size changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // do stuff
    }

}
