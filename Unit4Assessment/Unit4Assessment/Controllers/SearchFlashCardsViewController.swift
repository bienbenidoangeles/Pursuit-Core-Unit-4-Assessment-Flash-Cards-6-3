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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            if remoteFlashCards.isEmpty{
                collectionView.backgroundView = EmptyView(title: "Remote Flash Cards", message: "No flash cards have been found on the internet. Why not create some?")
            } else {
                DispatchQueue.main.async {
                    self.collectionView.backgroundView = nil
                }
            }
        }
    }
    
    override func loadView() {
        view = searchFlashCardsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        collectionView.register(FlashCardCell.self, forCellWithReuseIdentifier: "remoteFlashCardCell")
        loadRemoteFlashCards()
        view.backgroundColor = .systemBackground
    }
    
    private func loadRemoteFlashCards(){
        RemoteFlashCardsHelper.getRemoteFlashCards { (result) in
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self.showAlert(title: "Network Client Error", message: "Error: \(appError)")
                }
            case .success(let flashCards):
                self.remoteFlashCards = flashCards
            }
        }
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
        guard let indexPath = collectionView.indexPath(for: collectionViewCell) else {
            return
        }
        
        var selectedFlashcard = remoteFlashCards[indexPath.row]
        selectedFlashcard.type! = .local
        showAlert(title: "Item was added", message: "Flashcard: \(selectedFlashcard.cardTitle) was added to your deck")
        
        do {
            try dataPersistence.createItem(selectedFlashcard)
        } catch{
            showAlert(title: "SAVING ERROR", message: "Error: \(error)")
        }
    }
}
