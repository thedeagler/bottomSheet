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
        setupViews()
    }


    private func setupViews() {
        addChild(rootViewController)
        rootViewController.didMove(toParent: self)
        containerView.addSubview(rootViewController.view)

        containerView.layer.cornerRadius = 8
        handleView.layer.cornerRadius = 2

        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        rootViewController.view.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 16).isActive = true
        rootViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
    }
}
