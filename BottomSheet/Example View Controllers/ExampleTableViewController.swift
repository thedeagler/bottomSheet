//
//  ExampleTableViewController.swift
//  BottomSheet
//
//  Created by Stephen Wu on 2/6/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import UIKit

class ExampleTableViewController: UITableViewController, BottomSheetPresentable {

    weak var delegate: BottomSheetDelegate?
    var snapPositions: [CGFloat] = [20, UIScreen.main.bounds.height - 400]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 35
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "hi")
        cell.textLabel?.text = "item \(indexPath.row)"
        return cell
    }
}
