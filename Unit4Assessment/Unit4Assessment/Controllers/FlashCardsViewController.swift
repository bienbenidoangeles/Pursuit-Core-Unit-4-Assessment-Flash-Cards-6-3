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
    lazy var searchBar = flashCardsView.searchBar
    
    var flashCards = [FlashCard](){
        didSet{
            collectionView.reloadData()
            if flashCards.isEmpty{
                collectionView.backgroundView = EmptyView(title: "Flash Cards", message: "No flash cards have been found. Why not browse some from the net?")
            } else {
                collectionView.backgroundView = nil
            }
        }
    }
    
    var searchFlashCards = [FlashCard]()
    
    var searchQuery = ""{
        didSet{
            flashCards = searchFlashCards.filter{$0.cardTitle.lowercased().contains(searchQuery.lowercased())}
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
        loadSavedFlashCards()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.flashCardsView.addGestureRecognizer(tapGesture)
    }
    
    func delegateAndDataSources(){
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
    }
    
    private func loadSavedFlashCards(){
        do{
            flashCards = try dataPersistence.loadItems()
            searchFlashCards = try dataPersistence.loadItems()
            //print(flashCards)
        } catch {
            showAlert(title: "Loading error", message: "Error: \(error)")
        }
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }}

extension FlashCardsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         guard !searchText.isEmpty else {
            loadSavedFlashCards()
            return
        }
            searchQuery = searchText
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
        //selectedFlashCard.type! = .local
        cell.configureCell(for: selectedFlashCard)
        cell.delegate = self
        cell.backgroundColor = .systemBackground
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
//    func addButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard) {
//        
//    }
    
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
        
        //print(index)
        
        do {
            try dataPersistence.deleteItem(at: index)
        } catch {
            showAlert(title: "DELETE ERROR", message: "Error: \(error)")
        }
    }
}

extension FlashCardsViewController: DataPersistenceDelegate{
    func didSaveItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        loadSavedFlashCards()
    }
    
    func didDeleteItem<T>(_ persistenceHelper: DataPersistence<T>, item: T) where T : Decodable, T : Encodable, T : Equatable {
        loadSavedFlashCards()
    }
}
