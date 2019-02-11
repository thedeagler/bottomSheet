//
//  BottomSheetPresentable.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/11/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

protocol BottomSheetPresentable {
    /// The minY positions where the view should jump to when the view is resized
    var snapPositions: [CGFloat] { get }

}
