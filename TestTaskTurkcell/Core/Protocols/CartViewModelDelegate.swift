//
//  CartViewModelDelegate.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 1.03.21.
//

import Foundation

protocol CartViewModelDelegate: AnyObject {
    func updateUI(for state: ProductViewModel.ViewState)
}
