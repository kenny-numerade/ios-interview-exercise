//
//  Cell+Reuse.swift
//  RickAndMortyDebugging
//
//  Created by Kenny Dang on 1/10/22.
//

import UIKit

protocol ReusableIdentifier {
    static var reuseIdentifier: String { get }
}

extension ReusableIdentifier {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: ReusableIdentifier {

}

extension UICollectionViewCell: ReusableIdentifier {

}
