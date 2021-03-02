//
//  SelfConfiguringCell.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 27.02.21.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
}

extension SelfConfiguringCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
