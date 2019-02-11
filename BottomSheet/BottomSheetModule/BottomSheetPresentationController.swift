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
    private var dimmingView: UIView?

    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, outsideTouchMode: BottomSheetOutsideTouchMode) {
        self.outsideTouchMode = outsideTouchMode
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }

    private func makeDimmingView(animated: Bool) -> UIView {
        let view = UIView(frame: containerView!.bounds)
        view.backgroundColor = UIColor.black
        view.alpha = 0
        let selector = animated ? #selector(dismissPresentedViewControllerWithAnimation) : #selector(dismissPresentedViewControllerWithoutAnimation)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: selector)
        view.addGestureRecognizer(tapRecognizer)

        return view
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        switch outsideTouchMode {
        case .interact:
            let touchForwardingView = TouchForwardingView(frame: containerView!.bounds)
            touchForwardingView.destinationView = presentingViewController.view
            containerView?.insertSubview(touchForwardingView, at: 0)

        case .dismiss(let animated):
            let view = makeDimmingView(animated: animated)
            dimmingView = view
            containerView?.insertSubview(view, at: 0)

            guard let coordinator = presentedViewController.transitionCoordinator else {
                view.alpha = 0.5
                return
            }

            coordinator.animate(alongsideTransition: { _ in
                view.alpha = 0.5
            }, completion: nil)

        default:
            break
        }
    }

    override func dismissalTransitionWillBegin() {
        guard let view = dimmingView else { return }

        guard let coordinator = presentedViewController.transitionCoordinator else {
            view.alpha = 0
            return
        }

        coordinator.animate(alongsideTransition: { _ in
            view.alpha = 0
        }, completion: nil)
    }

    override func dismissalTransitionDidEnd(_ completed: Bool) {
        guard completed else { return }

        containerView?.subviews.forEach {
            $0.removeFromSuperview()
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
}
