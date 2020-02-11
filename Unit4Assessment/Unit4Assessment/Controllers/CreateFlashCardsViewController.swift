//
//  CreateFlashCardsViewController.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import DataPersistence

class CreateFlashCardsViewController: UIViewController {
    
    let createFlashCardsView = CreateFlashCardsView()
    lazy var titleTextField = createFlashCardsView.textField
    lazy var factTopTextView = createFlashCardsView.topTextView
    lazy var factBottomTextView = createFlashCardsView.bottomTextView

    var dataPersistence:DataPersistence<FlashCard>!
    
    var flashCard: FlashCard!
    
    override func loadView() {
        view = createFlashCardsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegatesAndDataSources()
        addBarButtonItems()
    }
    
    private func delegatesAndDataSources(){
        createFlashCardsView.topTextView.delegate = self
        createFlashCardsView.bottomTextView.delegate = self
    }
    
    private func addBarButtonItems(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(createButtonPressed))
    }
    
    @objc
    private func createButtonPressed(_ sender: UIBarButtonItem){
        guard let title = titleTextField.text else {
            showAlert(title: "Missing Fields", message: "No Title was entered")
            return
        }
        
        guard let fact1 = factTopTextView.text else {
            showAlert(title: "Missing Fields", message: "Fact 1 was not entered")
            return
        }
        
        guard let fact2 = factBottomTextView.text else {
            showAlert(title: "Missing Fields", message: "Fact 2 was not entered")
            return
        }
        
        flashCard = FlashCard(cardTitle: title, facts: [fact1, fact2])
        
        if dataPersistence.hasItemBeenSaved(flashCard){
            showAlert(title: "Dupicated Flashcards", message: "Create a unique flash card")
        } else {
            do {
                // save to documents directory
                try dataPersistence.createItem(flashCard)
                showAlert(title: "SAVING...", message: "Save successfull")
            } catch {
                showAlert(title: "SAVING...", message: "Save failed")
            }
        }
    }

}

extension CreateFlashCardsViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter flashcard fact" && textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
}


