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
            return "cell #\($0)"
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
        let bottomSheet = BottomSheetViewController(rootViewController: vc, outsideTouchMode: .interact)
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
}

