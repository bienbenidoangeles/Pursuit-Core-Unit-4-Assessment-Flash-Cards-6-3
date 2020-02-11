//
//  FlashCardsTabBarController.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class FlashCardsTabBarController: UITabBarController {
    
    var dataPersistence = DataPersistence<FlashCard>(filename: "SavedFlashCards.plist")
    
    lazy var flashCardsViewController: UIViewController = {
        let viewController = FlashCardsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(systemName: "questionmark.circle"), tag: 0)
        viewController.dataPersistance = dataPersistence
        return viewController
    }()
    
    lazy var createFlashCardsViewController: UIViewController = {
        let viewController = CreateFlashCardsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Create", image: UIImage(systemName: "square.and.pencil"), tag: 1)
        viewController.dataPersistance = dataPersistence
        return viewController
    }()
    
    lazy var searchFlashCardsViewController: UIViewController = {
        let viewController = SearchFlashCardsViewController()
        viewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingGlass"), tag: 2)
        viewController.dataPersistence = dataPersistence
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let baseVCs = [flashCardsViewController, createFlashCardsViewController, searchFlashCardsViewController]
        viewControllers = baseVCs.map{UINavigationController(rootViewController: $0)}
    }
    
    

}
