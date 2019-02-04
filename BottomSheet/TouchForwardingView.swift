//
//  TouchForwardingView.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class TouchForwardingView: UIView {
    var destinationView: UIView?

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event), hitView != self { return hitView }

        return destinationView?.hitTest(convert(point, to: destinationView), with: event)
    }
}
