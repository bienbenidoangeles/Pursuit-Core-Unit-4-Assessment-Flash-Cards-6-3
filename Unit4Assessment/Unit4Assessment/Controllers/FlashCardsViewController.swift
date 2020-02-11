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
    lazy var collectionView = flashCardsView.collectionView
    
    var flashCards = [FlashCard](){
        didSet{
            
        }
    }
    
    override func loadView() {
        view = flashCardsView
    }
    

  override func viewDidLoad() {
    super.viewDidLoad()
        delegateAndDataSources()
        collectionView.register(FlashCardCell.self, forCellWithReuseIdentifier: "FlashCardCell")
    }
    
    func delegateAndDataSources(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension FlashCardsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flashCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FlashCardCell", for: indexPath) as? FlashCardCell else{
            fatalError("failed to downcast to FlashCard Cell")
        }
        
        let selectedFlashCard = flashCards[indexPath.row]
        cell.configureCell(for: selectedFlashCard)
        
        return cell
    }
    
    
}

extension FlashCardsViewController: UICollectionViewDelegateFlowLayout{
    
}
