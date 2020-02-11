//
//  ViewController.swift
//  Unit4Assessment
//
//  Created by Alex Paul on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class FlashCardsViewController: UIViewController {
    
    var dataPersistance:DataPersistence<FlashCard>!
    
    let flashCardsView = FlashCardsView()
    
    override func loadView() {
        view = flashCardsView
    }
    

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }


}

