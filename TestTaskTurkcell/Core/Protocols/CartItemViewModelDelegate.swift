//
//  CartItemViewModelDelegate.swift
//  TestTaskTurkcell
//
//  Created by Sergey Starushkin on 1.03.21.
//

import Foundation

protocol CartItemViewModelDelegate: AnyObject {
    func updateUI(for state: ProductViewModel.ViewState)
}
