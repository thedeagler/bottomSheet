//
//  BottomSheetAnimator.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

/// Presentation animator
class BottomSheetPresentationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let animationDuration: TimeInterval = 0.33

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return BottomSheetPresentationAnimator.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.isAnimated else { return }

        let toViewController = transitionContext.viewController(forKey: .to)!
        let animationDuration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView

        toViewController.view.transform = .init(translationX: 0, y:containerView.bounds.height)
        containerView.addSubview(toViewController.view)

        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.95, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = .identity
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
}

/// Dismissal animator
class BottomSheetDismissalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    static let animationDuration: TimeInterval = 0.33

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return BottomSheetDismissalAnimator.animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard transitionContext.isAnimated else { return }

        let fromViewController = transitionContext.viewController(forKey: .from)!
        let animationDuration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView

        UIView.animate(withDuration: animationDuration, animations: {
            fromViewController.view.transform = .init(translationX: 0, y:containerView.bounds.height)
        }) { finished in
            fromViewController.removeFromParent()
            transitionContext.completeTransition(finished)
        }
    }
}
