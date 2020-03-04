//
//  FavTableDD.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import Foundation
import UIKit

class SearchTableDD: NSObject, UITableViewDataSource, UITableViewDelegate {
    var table: UITableView
    var cells = [String]()
    var historyDelegate: HistoryDelegate!

    init(_ tableView: UITableView, _ delegate: HistoryDelegate) {
        table = tableView
        historyDelegate = delegate

        super.init()

        table.delegate      = self
        table.dataSource    = self
    }
    func reload() {
        table.reloadData()
    }
    func add(_ text: String) {
        if (cells.count > 4) {
            cells.removeFirst()
        }
        cells.append(text)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! FavCell
        cell.restaurantLabel.text = cells[cells.count - indexPath.row - 1]

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyDelegate.history(cells[cells.count - indexPath.row - 1])
    }
}
