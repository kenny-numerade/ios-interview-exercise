//
//  Configure.swift
//  RickAndMortyDebugging
//
//  Created by Kenny Dang on 1/10/22.
//

import Foundation

func configure<T>(
    _ value: T,
    using closure: (inout T) throws -> Void
) rethrows -> T {
    var value = value
    try closure(&value)
    return value
}
