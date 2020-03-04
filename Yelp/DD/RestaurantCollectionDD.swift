//
//  RestaurantCollectionDD.swift
//  Yelp
//
//  Created by Charles Wang on 3/3/20.
//  Copyright © 2020 Charles Wang. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class RestaurantCollectionDD: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var parentView: UIView
    var collection: UICollectionView
    var yelp: Yelp?
    var cells = [Businesses]()
    var position = 0
    var total = 0
    let border = CGFloat(10)

    var location: CLLocation?
    var isFirstTime = true
    var isSearching = false
    var isGettingMore = false
    var wrapper: UIView?
    var icon: UIActivityIndicatorView?
    var query: String?
    var updateDelegate: UpdateDelegate

    init(_ view: UIView, _ collectionView: UICollectionView, _ delegate: UpdateDelegate) {
        parentView = view
        collection = collectionView
        collection.isScrollEnabled = false
        updateDelegate = delegate

        super.init()

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: border, bottom: 0, right: border)
        collectionView.collectionViewLayout = layout

        NotificationCenter.default.addObserver(self, selector: #selector(gotLocation),
                                               name: .device_location_changed, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func gotLocation(_ notifcation: Notification) {
        location = notifcation.userInfo!["location"] as? CLLocation
        search(nil)
    }
    func search(_ offset: Int?) {
        guard let location = location else { return }
        if (isFirstTime || isSearching || isGettingMore) {
            Requests.shared.getBusiness(search: query, location.coordinate.latitude, location.coordinate.longitude, offset) { (yelp) in

                DispatchQueue.main.async {
                    self.yelp = yelp
                    if let biz = yelp?.businesses {
                        if (self.isSearching) {
                            self.cells.removeAll()
                        }
                        for b in biz {
                            self.cells.append(b)
                        }
                    }
                    self.total = self.cells.count
                    self.updateDelegate.update(self.position+1, self.total)

                    self.collection.reloadData()

                    if (self.isGettingMore) {
                        self.scrollRight()
                    } else {
                        self.allLeft()
                    }

                    self.parentView.isUserInteractionEnabled = true
                    if let wrapper = self.wrapper, let icon = self.icon {
                        wrapper.removeFromSuperview()
                        icon.removeFromSuperview()
                    }
                    self.isGettingMore = false
                    self.isSearching = false
                }

            }
            isFirstTime = false
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = collectionView.frame.size.height
        let w = collectionView.frame.size.width

        return CGSize(width: w - 2 * border, height: h - 2 * border)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (cells.isEmpty) {
            return UICollectionViewCell()
        }
        let business = cells[indexPath.item]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as! RestaurantCell
        cell.restaurantLabel.text = business.name ?? "---"
        cell.ratingLabel.text = business.rating?.description

        cell.restaurantImage.loadImageFrom(url: business.image_url)
        cell.restaurantImage.layer.cornerRadius = 10
        
        cell.backgroundColor = .lightGray
        cell.layer.cornerRadius = 10
        
        return cell
    }
    func allLeft() {
        position = 0
        updateDelegate.update(position+1, total)
        let path = IndexPath(item: position, section: 0)
        collection.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    func allRight() {
        if (cells.isEmpty) {
            return
        }
        position = cells.count - 1
        updateDelegate.update(position+1, total)
        let path = IndexPath(item: position, section: 0)
        collection.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    func scrollLeft() {
        guard position > 0 else { return }
        position -= 1
        updateDelegate.update(position+1, total)
        let path = IndexPath(item: position, section: 0)
        collection.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    func scrollRight() {
        if (cells.isEmpty) {
            return
        }
        if (position == cells.count - 1) {
            fetchMore()
            return
        }
        position += 1
        updateDelegate.update(position+1, total)
        let path = IndexPath(item: position, section: 0)
        collection.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    func fetchMore() {
        parentView.isUserInteractionEnabled = false
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        if (wrapper == nil) {
            wrapper = UIView(frame: frame)
            if let wrapper = wrapper {
                wrapper.center = parentView.center
                wrapper.backgroundColor = .black
                wrapper.layer.cornerRadius = 5
            }
        }

        if (icon == nil) {
            icon = UIActivityIndicatorView(style: .large)
            if let icon = icon {
                icon.startAnimating()
                icon.center = parentView.center
            }
        }
        isGettingMore = true
        parentView.addSubview(wrapper!)
        parentView.addSubview(icon!)

        search(cells.count + 20)
    }
}
