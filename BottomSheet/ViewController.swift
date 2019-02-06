//
//  ViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var data: [String] = {
        return (0..<100).map({
            switch $0 {
            case 0:
                return "Background dismiss with animation"
            case 1:
                return "Background dismiss without animation"
            case 2:
                return "Background interactive"
            case 3:
                return "Background not interactive"
            case 4:
                return "Without nav"

            default:
                return "nothing #\($0)"
            }
        })
    }()

    struct ReuseId {
        static let cell = "hello"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ReuseId.cell)
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func showBottomSheet(_ sender: UIBarButtonItem) {
        let vc = DopeViewController()
        let nav = UINavigationController(rootViewController: vc)
        let bottomSheet = BottomSheetViewController(rootViewController: nav, outsideTouchMode: .dismiss(animated: true))
        present(bottomSheet, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseId.cell)!
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let touchMode: BottomSheetOutsideTouchMode
        let vc: UIViewController

        switch indexPath.row {
        case 0:
            let dvc = DopeViewController()
            vc = UINavigationController(rootViewController: dvc)
            touchMode = .dismiss(animated: true)

        case 1:
            let dvc = DopeViewController()
            vc = UINavigationController(rootViewController: dvc)
            touchMode = .dismiss(animated: false)

        case 2:
            let dvc = DopeViewController()
            vc = UINavigationController(rootViewController: dvc)
            touchMode = .interact

        case 3:
            let dvc = DopeViewController()
            vc = UINavigationController(rootViewController: dvc)
            touchMode = .none

        case 4:
            vc = DopeViewController()
            touchMode = .dismiss(animated: true)

        default:
            return
        }

        let bottomSheet = BottomSheetViewController(rootViewController: vc, outsideTouchMode: touchMode)
        present(bottomSheet, animated: true)
    }
}

