//
//  ViewController.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

class MainVC: UIViewController, UpdateDelegate, HistoryDelegate {
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var allBack: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var allNext: UIButton!

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!

    @IBOutlet weak var searchLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var enableLocationView: UIView!

    var restaurantDD: RestaurantCollectionDD!
    var searchDD: SearchTableDD!

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantDD = RestaurantCollectionDD(view, collectionView, self)
        collectionView.delegate = restaurantDD
        collectionView.dataSource = restaurantDD

        searchDD = SearchTableDD(tableView, self)
        tableView.delegate = searchDD
        tableView.dataSource = searchDD

        let tap = UITapGestureRecognizer(target: self, action: #selector(startSearch))
        searchLabel.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(checkLocation),
                                               name: .app_became_active, object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkLocation()
    }
    override func viewDidLayoutSubviews() {
        allBack.setTitleColor(.blue, for: .normal)
        totalLabel.textColor = .blue
        allNext.setTitleColor(.blue, for: .normal)

        backButton.layer.cornerRadius = 10
        backButton.drawOutline(thick: 2.0, color: .blue)
        backButton.setTitleColor(.blue, for: .normal)

        nextButton.layer.cornerRadius = 10
        nextButton.drawOutline(thick: 2.0, color: .blue)
        nextButton.setTitleColor(.blue, for: .normal)

        searchButton.imageView?.setColor(.blue)
    }
    func update(_ pos: Int, _ total: Int) {
        totalLabel.text = "\(pos)/\(total)"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    @objc func checkLocation() {
        let status = CLLocationManager.authorizationStatus()
        if (status == .denied) {
            enableLocationView.isHidden = false
        } else {
            enableLocationView.isHidden = true
        }
    }
    @IBAction func allBack(_ sender: Any) {
        restaurantDD.allLeft()
    }
    @IBAction func allNext(_ sender: Any) {
        restaurantDD.allRight()
    }

    @IBAction func back(_ sender: Any) {
        restaurantDD.scrollLeft()
    }
    @IBAction func next(_ sender: Any) {
        restaurantDD.scrollRight()
    }
    @IBAction func search(_ sender: Any) {
        startSearch()
    }
    @objc func startSearch() {
        let alert = UIAlertController(title: "What are you looking for?", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Search for..."
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let search = UIAlertAction(title: "Search", style: .default) { (action) in
            let searchText = alert.textFields?[0].text
            if let searchText = searchText {
                self.searchDD.add(searchText)
                self.searchDD.reload()
            }
            self.searchLabel.text = searchText
            self.searchLabel.textColor = .black
            self.restaurantDD.isSearching = true
            self.restaurantDD.query = searchText
            self.restaurantDD.search(nil)
        }
        alert.addAction(cancel)
        alert.addAction(search)
        present(alert, animated: true, completion: nil)
    }
    func history(_ text: String) {
        self.searchDD.add(text)
        self.searchDD.reload()
        self.searchLabel.text = text
        self.searchLabel.textColor = .black
        self.restaurantDD.isSearching = true
        self.restaurantDD.query = text
        self.restaurantDD.search(nil)
    }
    @IBAction func openSettings(_ sender: Any) {
        let settingsUrl = URL(string:UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
    }
}

protocol UpdateDelegate {
    func update(_ pos: Int, _ total: Int)
}
protocol HistoryDelegate {
    func history(_ text: String)
}
