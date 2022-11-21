//
//  AppCoordinator.swift
//  MMarket
//
//  Created by 조성훈 on 2022/10/19.
//

import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var parentCoordinators: Coordinator?
    var childCoordinators: [Coordinator] = []
    private let useCase: ProductUseCase = DefaultProductUseCase(
        repository: DefaultProductRepository(
            networkProvider: DefaultNetworkProvider()
        )
    )
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        tabBarController.tabBar.tintColor = .label
        
        let mainNavigationController = UINavigationController()
        mainNavigationController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        mainNavigationController.navigationBar.tintColor = .label
        
        let myPageNavigationController = UINavigationController()
        myPageNavigationController.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "star.fill"), tag: 1)
        myPageNavigationController.navigationBar.tintColor = .label
        
        tabBarController.viewControllers = [mainNavigationController, myPageNavigationController]
        navigationController.viewControllers = [tabBarController]
        navigationController.setNavigationBarHidden(true, animated: false)
        
        let mainCoordinator = MainCoordinator(
            navigationController: mainNavigationController,
            parentCoordinators: self,
            useCase: self.useCase
        )
        let myPageCoordinator = MyPageCoordinator(
            navigationController: myPageNavigationController,
            parentCoordinators: self,
            useCase: self.useCase
        )
        
        childCoordinators.append(mainCoordinator)
        childCoordinators.append(myPageCoordinator)
        mainCoordinator.start()
        myPageCoordinator.start()
    }
}
