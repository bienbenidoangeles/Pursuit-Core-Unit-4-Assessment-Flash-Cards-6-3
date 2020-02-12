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
    private lazy var searchBar = searchFlashCardsView.searchBar
    
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
    
    private var searchFlashCards = [FlashCard]()
    
    override func loadView() {
        view = searchFlashCardsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        collectionView.register(FlashCardCell.self, forCellWithReuseIdentifier: "remoteFlashCardCell")
        loadRemoteFlashCards()
        view.backgroundColor = .systemBackground
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        self.searchFlashCardsView.addGestureRecognizer(tapGesture)
    }
    
    private func loadRemoteFlashCards(){
        RemoteFlashCardsHelper.getRemoteFlashCards {[weak self] (result) in
            switch result{
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Network Client Error", message: "Error: \(appError)")
                }
            case .success(let flashCards):
                self?.remoteFlashCards = flashCards
                self?.searchFlashCards = flashCards
            }
        }
    }
    
    private func delegatesAndDataSources(){
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
    }
    
    @objc private func dismissKeyboard(_ sender: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    private func filterFlashCards(for searchText: String){
        guard !searchText.isEmpty else {
            return
        }
        remoteFlashCards =  searchFlashCards.filter{$0.cardTitle.lowercased().contains(searchText.lowercased())}
    }
}

extension SearchFlashCardsViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchTest = searchBar.text else { return }
        filterFlashCards(for: searchTest)
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
        guard let indexPath = collectionView.indexPath(for: collectionViewCell) else {
            return
        }
        
        var selectedFlashcard = remoteFlashCards[indexPath.row]
        selectedFlashcard.type! = .local
        
        
        if dataPersistence.hasItemBeenSaved(selectedFlashcard){
            showAlert(title: "Dupicated Flashcards", message: "You can not add duplicate flash cards")
        } else {
            do {
                // save to documents directory
                try dataPersistence.createItem(selectedFlashcard)
                showAlert(title: "Item was added", message: "Flashcard: \(selectedFlashcard.cardTitle) was added to your deck")
            } catch {
                showAlert(title: "Saving error", message: "Error: \(error)")
            }
        }
    }
    
//    func addButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard) {
//
//    }
}
