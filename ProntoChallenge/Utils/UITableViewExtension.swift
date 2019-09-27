//
//  UITableViewExtension.swift
//  ProntoChallenge
//
//  Created by Angel Trejo Flores on 9/27/19.
//  Copyright © 2019 Angel Trejo Flores. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    /// Returns a reusable cell object located by its identifier and also serves to avoid the use of casting class.
    func dequeue<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Cannot dequeue a cell with identifier \(T.reuseIdentifier)")
        }
        return cell
    }
}
