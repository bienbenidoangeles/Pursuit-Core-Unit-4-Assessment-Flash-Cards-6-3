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
    
    var dataPersistence:DataPersistence<FlashCard>!
    
    let flashCardsView = FlashCardsView()
    lazy var collectionView = flashCardsView.collectionView
    
    var flashCards = [FlashCard](){
        didSet{
            collectionView.reloadData()
            if flashCards.isEmpty{
                collectionView.backgroundView = EmptyView(title: "Flash Cards", message: "No flash cards have been saved. Why not browse some from the net?")
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    override func loadView() {
        view = flashCardsView
    }
    

  override func viewDidLoad() {
    super.viewDidLoad()
        delegateAndDataSources()
        collectionView.register(FlashCardCell.self, forCellWithReuseIdentifier: "FlashCardCell")
        view.backgroundColor = .systemBackground
        loadSavedArticles()
    }
    
    func delegateAndDataSources(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func loadSavedArticles(){
        do{
            flashCards = try dataPersistence.loadItems()
        } catch {
            showAlert(title: "Loading error", message: "Error: \(error)")
        }
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
        cell.delegate = self
        
        return cell
    }
    
    
}

extension FlashCardsViewController: UICollectionViewDelegateFlowLayout{
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

extension FlashCardsViewController: FlashCardButtonDelegate{
    func moreButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard) {
        let actionSheet = UIAlertController(title: "What would you like to do?", message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete \(flashCard.cardTitle)?", style: .destructive) { (alertAction) in
            self.deleteFlashCard(flashCard)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let actions = [deleteAction, cancelAction]
        actions.forEach { actionSheet.addAction($0)}
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func deleteFlashCard(_ flashCard: FlashCard){
        guard let index = flashCards.firstIndex(of: flashCard) else {
            return
        }
        
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "DELETE ERROR", message: "Error: \(error)")
        }
    }
}

extension FlashCardsViewController: DataPersistenceDelegate{
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        loadSavedArticles()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        loadSavedArticles()
    }
}
