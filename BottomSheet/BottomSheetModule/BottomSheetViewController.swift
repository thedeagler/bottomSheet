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

    let fullMinY: CGFloat = 20
    let compactMinY: CGFloat = UIScreen.main.bounds.height - 250

    var viewHeight: CGFloat {
        return UIScreen.main.bounds.height - fullMinY
    }

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
        switch recognizer.state {
        case .began:
            initialFrame = view.frame

        case .changed:
            view.frame = CGRect(x: initialFrame.minX,
                                y: max(initialFrame.minY + recognizer.translation(in: view).y, fullMinY),
                                width: initialFrame.width,
                                height: viewHeight)

        default:
            snap(view, to: [fullMinY, compactMinY], with: recognizer.velocity(in: view).y)
        }
    }

    let thresholdSpeed: CGFloat = 150

    func snap(_ view: UIView, to notches: [CGFloat], with velocity: CGFloat, onSnapToBottom: (() -> Void)? = nil) {
        let yBottom = view.frame.maxY
        let yPos = view.frame.minY
        var positions = [yBottom]
        positions.append(contentsOf: notches)
        positions = positions.sorted()

        let indexOfNextNeighbor = positions.firstIndex { $0 > yPos } ?? (positions.count - 1)
        let indexOfPreviousNeighbor = max(indexOfNextNeighbor - 1, 0)

        let indexOfNewPosition: Int
        if abs(velocity) > thresholdSpeed {
            indexOfNewPosition = velocity > 0 ? indexOfNextNeighbor : indexOfPreviousNeighbor
        } else {
            let prevNeighborDX = abs(yPos - positions[indexOfPreviousNeighbor])
            let nextNeighborDX = abs(yPos - positions[indexOfNextNeighbor])

            indexOfNewPosition = prevNeighborDX < nextNeighborDX ? indexOfPreviousNeighbor : indexOfNextNeighbor
        }

        let newYPos = positions[indexOfNewPosition]
        let newFrame = CGRect(x: view.frame.minX,
                              y: newYPos,
                              width: view.frame.width,
                              height: viewHeight)

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            view.frame = newFrame
        }) { _ in
            if newYPos == yBottom {
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            }
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

        containerView.layer.cornerRadius = 12
        handleView.layer.cornerRadius = 2

        rootViewController.view.translatesAutoresizingMaskIntoConstraints = false

        rootViewController.view.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 6).isActive = true
        rootViewController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        rootViewController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        view.frame = CGRect(x: view.frame.minX,
                            y: compactMinY,
                            width: view.frame.width,
                            height: viewHeight)

        addShadow(to: containerView)
    }

    func addShadow(to view: UIView) {
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 4
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
