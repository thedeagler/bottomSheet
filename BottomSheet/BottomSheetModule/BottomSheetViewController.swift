//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {

    let rootViewController: UIViewController

    private let outsideTouchMode: BottomSheetOutsideTouchMode
    private let bottomSheetTransitioningDelegate: BottomSheetTransitionDelegate

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var handleView: UIView!

    init(rootViewController: UIViewController, outsideTouchMode: BottomSheetOutsideTouchMode) {
        self.rootViewController = rootViewController
        self.outsideTouchMode = outsideTouchMode
        self.bottomSheetTransitioningDelegate =  BottomSheetTransitionDelegate(outsideTouchMode: outsideTouchMode)

        super.init(nibName: nil, bundle: nil)

        transitioningDelegate = bottomSheetTransitioningDelegate
        modalPresentationStyle = .custom
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupViews()
    }

    private var initialFrame: CGRect!

    @objc
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let dY = recognizer.translation(in: view).y

        switch recognizer.state {
        case .began:
            initialFrame = containerView.frame

        case .changed:
            containerView.frame = CGRect(x: initialFrame.minX,
                                         y: initialFrame.minY + dY,
                                         width: initialFrame.width,
                                         height: initialFrame.height - dY)
            // somehow change height of view controller

        default:
            break
        }
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        containerView.addGestureRecognizer(panGesture)
    }

    private func setupViews() {
        addChild(rootViewController)
        rootViewController.didMove(toParent: self)
        containerView.addSubview(rootViewController.view)
        containerView.backgroundColor = rootViewController.view.backgroundColor

        containerView.layer.cornerRadius = 8
        handleView.layer.cornerRadius = 2

        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        rootViewController.view.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 6).isActive = true
        rootViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}
