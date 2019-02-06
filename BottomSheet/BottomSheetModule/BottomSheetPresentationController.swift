//
//  BottomSheetPresentationController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

/// Enumerates the different ways to handle touches in the background of the bottom sheet.
enum BottomSheetOutsideTouchMode {
    /// Do nothing
    case none
    /// Dismiss the bottom sheet
    case dismiss(animated: Bool)
    /// Allow interactions with the presenting view controller in the empty space behind the half sheet
    case interact
}

class BottomSheetPresentationController: UIPresentationController {
    private let outsideTouchMode: BottomSheetOutsideTouchMode
    private var touchForwardingView: TouchForwardingView!

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, outsideTouchMode: BottomSheetOutsideTouchMode) {
        self.outsideTouchMode = outsideTouchMode
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        switch outsideTouchMode {
        case .interact:
            touchForwardingView = TouchForwardingView(frame: containerView!.bounds)
            touchForwardingView.destinationView = presentingViewController.view
            containerView?.insertSubview(touchForwardingView, at: 0)

        case .dismiss(let animated):
            let view = UIView(frame: containerView!.bounds)
            let selector = animated ? #selector(dismissPresentedViewControllerWithAnimation) : #selector(dismissPresentedViewControllerWithoutAnimation)
            let tapRecognizer = UITapGestureRecognizer(target: self, action: selector)
            view.addGestureRecognizer(tapRecognizer)
            containerView?.insertSubview(view, at: 0)

        default:
            break
        }
    }

    @objc
    private func dismissPresentedViewControllerWithAnimation() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }

    @objc
    private func dismissPresentedViewControllerWithoutAnimation() {
        presentingViewController.dismiss(animated: false, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }

        containerView?.subviews.forEach {
            $0.removeFromSuperview()
        }
    }

    // Responds to size changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // do stuff
        print("transitioning")
    }

}
