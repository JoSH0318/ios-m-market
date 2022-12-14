//
//  Coordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/19.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    var parentCoordinators: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
}

extension Coordinator {
    func removeChildCoordinator(child: Coordinator) {
        childCoordinators.removeAll()
    }
}
