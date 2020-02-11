//
//  SearchFlashCardsViewController.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class SearchFlashCardsViewController: UIViewController {
    
    var dataPersistence: DataPersistence<FlashCard>!
    
    let searchFlashCardsView = SearchFlashCardsView()
    
    override func loadView() {
        view = searchFlashCardsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
