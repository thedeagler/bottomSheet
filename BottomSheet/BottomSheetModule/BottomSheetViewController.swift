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
        addChild(rootViewController)
        rootViewController.didMove(toParent: self)
        view.addSubview(rootViewController.view)
    }
}
