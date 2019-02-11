//
//  BottomSheetPresentable.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/11/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

protocol BottomSheetPresentable: class {
    /// The minY positions where the view should jump to when the view is resized. The minimum value will be the initial position of the card, and all cards can be swiped down, off screen to dismiss.
    var snapPositions: [CGFloat] { get }

    var delegate: BottomSheetDelegate? { get set }
}

protocol BottomSheetDelegate: class {
    /// Notifies the bottom sheet of an impending size change.
    func view(_ view: UIView, willResizeTo newSize: CGSize)

    // Maybe something here to update snap states instead?
}
