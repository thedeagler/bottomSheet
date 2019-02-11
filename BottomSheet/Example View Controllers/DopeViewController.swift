//
//  DopeViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class DopeViewController: UIViewController, BottomSheetPresentable {

    weak var delegate: BottomSheetDelegate?
    var snapPositions: [CGFloat] = [20, UIScreen.main.bounds.height - 250]

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(DopeViewController.handleDismissTap(_:)))
        navigationItem.title = "Dope"
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

    @IBAction func showAction(_ sender: UIButton) {
        colorBox.isHidden = !colorBox.isHidden
        let compactHeight: CGFloat = colorBox.isHidden ? 250 : 450
        delegate?.view(view, shouldUpdate: [20, UIScreen.main.bounds.height - compactHeight])
    }

    @IBOutlet weak var colorBox: UIView!

    @objc
    func handleDismissTap(_ sender: UIBarButtonItem) {
        dismiss()
    }

    func dismiss() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
