//
//  BottomSheetViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class BottomSheetViewController: UIViewController {

    private let hostedNavigationController: UINavigationController
    private var snapPositions: [CGFloat]
    private let outsideTouchMode: BottomSheetOutsideTouchMode
    private let bottomSheetTransitioningDelegate: BottomSheetTransitionDelegate

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var handleView: UIView!

    private var maxViewHeight: CGFloat {
        return UIScreen.main.bounds.height - snapPositions.min()!
    }

    private let defaultMinY: CGFloat = UIScreen.main.bounds.height - 250

    init(rootViewController: UIViewController & BottomSheetPresentable, outsideTouchMode: BottomSheetOutsideTouchMode) {
        hostedNavigationController = UINavigationController(rootViewController: rootViewController)
        self.outsideTouchMode = outsideTouchMode
        self.bottomSheetTransitioningDelegate =  BottomSheetTransitionDelegate(outsideTouchMode: outsideTouchMode)
        self.snapPositions = rootViewController.snapPositions.isEmpty ? [defaultMinY] : rootViewController.snapPositions

        super.init(nibName: nil, bundle: nil)

        hostedNavigationController.delegate = self
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


    /// Updates the list of snap positions which the view may jump to on resizing as well as moves the view to the
    /// nearest snap position.
    ///
    /// - Parameter snapPositions: The new valid snapping positions
    func update(snapPositions: [CGFloat]) {
        self.snapPositions = snapPositions
        snap(to: snapPositions, with: 0)
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
            snap(to: snapPositions, with: recognizer.velocity(in: view).y)
        }
    }

    /// The minimum speed required to snap to the position in the direction of the velocity, rather than nearest.
    private let thresholdSpeed: CGFloat = 150

    private func snap(to notches: [CGFloat], with velocity: CGFloat) {
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
                self.view.frame = newFrameWithBuffer
            }) { _ in
                self.view.frame = newFrame
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

        hostedNavigationController.navigationBar.shadowImage = UIImage()
        hostedNavigationController.navigationBar.isTranslucent = false

        hostedNavigationController.view.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 6).isActive = true
        hostedNavigationController.view.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        hostedNavigationController.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true

        view.frame = CGRect(x: view.frame.minX,
                            y: snapPositions.max()!,
                            width: UIScreen.main.bounds.width,
                            height: maxViewHeight)

        addShadow(to: containerView)
    }

    private func addShadow(to view: UIView) {
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

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let bottomSheetPan = gestureRecognizer as? UIPanGestureRecognizer,
            let otherPan = otherGestureRecognizer as? UIPanGestureRecognizer,
            let otherView = otherPan.view as? UIScrollView else { return false }

        let direction = bottomSheetPan.velocity(in: view).y

        let y = view.frame.minY
        let isSheetAtTop = y == snapPositions.min()!
        let isScrollViewAtTop = otherView.contentOffset.y <= -otherView.contentInset.top
        let isDirectionDown = direction > 0

        if isSheetAtTop, (!isScrollViewAtTop || !isDirectionDown) {
            otherView.isScrollEnabled = true
            return false
        } else {
            otherView.isScrollEnabled = false
            return true
        }
    }

}
extension BottomSheetViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let viewController = viewController as? BottomSheetPresentable {
            update(snapPositions: viewController.snapPositions)
            viewController.delegate = self
        }
    }
}

extension BottomSheetViewController: BottomSheetDelegate {
    func view(_ view: UIView, shouldUpdate snapPositions: [CGFloat]) {
        update(snapPositions: snapPositions)
    }
}
