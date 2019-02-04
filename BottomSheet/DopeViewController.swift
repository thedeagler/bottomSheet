//
//  DopeViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class DopeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func handleDismissTap(_ sender: UIButton) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
