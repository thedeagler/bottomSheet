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

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DopeViewController.handleDismissTap(_:)))
        navigationItem.title = "Title"
    }

    @IBAction func listButtonAction(_ sender: Any) {
        let newVC = ExampleTableViewController()
        newVC.title = "List"
        newVC.view.backgroundColor = .white
        navigationController?.pushViewController(newVC, animated: true)
    }

    @IBAction func pushButtonAction(_ sender: UIButton) {
        let newVC = UIViewController()
        newVC.title = "Plain"
        newVC.view.backgroundColor = .white
        navigationController?.pushViewController(newVC, animated: true)
    }

    @IBAction func closeButtonAction(_ sender: UIButton) {
        dismiss()
    }

    @objc
    func handleDismissTap(_ sender: UIBarButtonItem) {
        dismiss()
    }

    func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
