//
//  ViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/4/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

struct CellData {
    let title: String
    let description: String?

    init(_ title: String, description: String? = nil) {
        self.title = title
        self.description = description
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var data: [CellData] = {
        return (0..<100).map({
            switch $0 {
            case 0:
                return CellData("Dismiss on background tap with animation",
                                description: "Background is dimmed, and will dismiss the bottom sheet when tapped with an animation which fades out the background and translates the card down and off screen.")
            case 1:
                return CellData("Dismiss on background tap without animation",
                                description: "Background is dimmed, and will instantly disappear along with the bottom sheet when tapped.")
            case 2:
                return CellData("Interactive background",
                                description: "The view behind the bottom sheet remains interactable.")
            case 3:
                return CellData("No interaction on background touches",
                                description: "The background is not interactable, and taps will not dismiss the bottom sheet.")

            default:
                return CellData("Extra cell #\($0)")
            }
        })
    }()

    struct ReuseId {
        static let cell = "hello"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseId.cell) ?? UITableViewCell(style: .subtitle, reuseIdentifier: ReuseId.cell)
        cell.textLabel?.text = data[indexPath.row].title
        cell.detailTextLabel?.text = data[indexPath.row].description
        cell.detailTextLabel?.numberOfLines = 0

        if indexPath.row < 4 {
            cell.accessoryType = .disclosureIndicator
        } else {
            cell.isUserInteractionEnabled = false
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let touchMode: BottomSheetOutsideTouchMode
        let vc = DopeViewController()

        switch indexPath.row {
        case 0:
            touchMode = .dismiss(animated: true)

        case 1:
            touchMode = .dismiss(animated: false)

        case 2:
            touchMode = .interact

        case 3:
            touchMode = .none

        default:
            return
        }

        tableView.deselectRow(at: indexPath, animated: true)

        let bottomSheet = BottomSheetViewController(rootViewController: vc, outsideTouchMode: touchMode)
        present(bottomSheet, animated: true)
    }
}

