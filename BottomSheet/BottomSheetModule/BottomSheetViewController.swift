//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {

    let hostedNavigationController: UINavigationController
    private let snapPositions: [CGFloat]
    private let outsideTouchMode: BottomSheetOutsideTouchMode
    private let bottomSheetTransitioningDelegate: BottomSheetTransitionDelegate

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var handleView: UIView!

    private var maxViewHeight: CGFloat {
        return UIScreen.main.bounds.height - snapPositions.min()!
    }

    private var defaultMinY: CGFloat = UIScreen.main.bounds.height - 250

    init(rootViewController: UIViewController & BottomSheetPresentable, outsideTouchMode: BottomSheetOutsideTouchMode) {
        hostedNavigationController = UINavigationController(rootViewController: rootViewController)
        self.outsideTouchMode = outsideTouchMode
        self.bottomSheetTransitioningDelegate =  BottomSheetTransitionDelegate(outsideTouchMode: outsideTouchMode)
        self.snapPositions = rootViewController.snapPositions.isEmpty ? [defaultMinY] : rootViewController.snapPositions

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
                                y: max(initialFrame.minY + recognizer.translation(in: view).y, snapPositions.min()!),
                                width: initialFrame.width,
                                height: maxViewHeight)

        default:
            snap(view, to: snapPositions, with: recognizer.velocity(in: view).y)
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
        let newFrameWithBuffer = CGRect(x: view.frame.minX,
                                        y: newYPos,
                                        width: view.frame.width,
                                        height: maxViewHeight + 100) // Adding buffer for spring animation
        let newFrame = CGRect(x: view.frame.minX,
                                        y: newYPos,
                                        width: view.frame.width,
                                        height: maxViewHeight)

        if newYPos == yBottom {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                view.frame = newFrameWithBuffer
            }) { _ in
                view.frame = newFrame
            }
        }
    }

    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        panGesture.delegate = self
        containerView.addGestureRecognizer(panGesture)
    }

    private func setupViews() {
        addChild(hostedNavigationController)
        hostedNavigationController.didMove(toParent: self)
        containerView.addSubview(hostedNavigationController.view)
        containerView.backgroundColor = hostedNavigationController.topViewController?.view.backgroundColor

        containerView.layer.cornerRadius = 12
        handleView.layer.cornerRadius = 2

        hostedNavigationController.view.translatesAutoresizingMaskIntoConstraints = false

        hostedNavigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        hostedNavigationController.navigationBar.shadowImage = UIImage()
        hostedNavigationController.navigationBar.isTranslucent = true

        hostedNavigationController.view.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 6).isActive = true
        hostedNavigationController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        hostedNavigationController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        view.frame = CGRect(x: view.frame.minX,
                            y: snapPositions.max()!,
                            width: view.frame.width,
                            height: maxViewHeight)

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

extension BottomSheetViewController: UIGestureRecognizerDelegate {

    // Solution
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
        let direction = gesture.velocity(in: view).y

        let y = view.frame.minY
//        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
//            tableView.isScrollEnabled = false
//        } else {
//            tableView.isScrollEnabled = true
//        }

//        if y == fullMinY {
//
//        } else {
//
//        }

        return true
    }

}
extension BottomSheetViewController: UINavigationControllerDelegate {

}

protocol BottomSheetDisplayable: class {
    /// The height of the view it first appears in the bottom sheet.
    var initialHeight: CGFloat { get }

    /// The minY positions that the view may snap to when the user resizes the bottom sheet.
    var snapPositions: [CGFloat] { get }

    var delegate: BottomSheetResizeable? { get set }
}

protocol BottomSheetResizeable: class {
    func view(_ view: UIView, willResizeTo height: CGFloat)
}
