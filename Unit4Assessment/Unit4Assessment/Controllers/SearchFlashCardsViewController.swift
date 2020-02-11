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
    
    private lazy var collectionView = searchFlashCardsView.collectionView
    
    private var remoteFlashCards = [FlashCard](){
        didSet{
            
        }
    }
    
    override func loadView() {
        view = searchFlashCardsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        collectionView.register(FlashCardCell.self, forCellWithReuseIdentifier: "remoteFlashCardCell")

    }
    
    private func loadRemoteCells(){
        
    }
    
    private func delegatesAndDataSources(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension SearchFlashCardsViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return remoteFlashCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "remoteFlashCardCell", for: indexPath) as? FlashCardCell else{
            fatalError("failed to downcast to FlashCard Cell")
        }
        
        let selectedFlashCard = remoteFlashCards[indexPath.row]
        cell.configureCell(for: selectedFlashCard)
        cell.delegate = self
        cell.backgroundColor = .systemBackground
        return cell
    }
    
    
}

extension SearchFlashCardsViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxSize:CGSize = UIScreen.main.bounds.size
        let spacingBetweenItems: CGFloat = 10
        let numberOfItems:CGFloat = 1
        let itemHeight:CGFloat = maxSize.height * 0.3
        let totalSpacing: CGFloat = (2 * spacingBetweenItems) + (numberOfItems - 1) * spacingBetweenItems
        let itemWidth: CGFloat = (maxSize.width - totalSpacing) / numberOfItems
        return CGSize(width: itemWidth, height: itemHeight)
    }
}

extension SearchFlashCardsViewController: FlashCardButtonDelegate{
    func moreButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard) {
        
    }
    
    func addButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard) {
        
//        do {
//            try dataPersistence.createItem()
//        } catch{
//            showAlert(title: "SAVING ERROR", message: <#T##String?#>)
//        }
    }
}
