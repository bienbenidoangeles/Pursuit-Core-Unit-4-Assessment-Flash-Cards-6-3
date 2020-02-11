//
//  FlashCardCell.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

protocol FlashCardButtonDelegate: AnyObject {
    func moreButtonPressed(_ collectionViewCell: FlashCardCell, flashCard: FlashCard)
}

class FlashCardCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var factLabel :UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var editButton: UIButton = {
       let editButton = UIButton()
        editButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return editButton
    }()
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
       let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(cellWasLongPressed))
        return gesture
    }()
    
    var existingFlashCard: FlashCard!
    
    weak var delegate: FlashCardButtonDelegate!
    
    private var isBackOfCardShowing = false
    
    @objc
    private func editButtonPressed(){
        delegate.moreButtonPressed(self, flashCard: existingFlashCard)
    }
    
    @objc private func cellWasLongPressed(_ gesture: UITapGestureRecognizer){
        if gesture.state == .began || gesture.state == .changed {
            return
        }
        isBackOfCardShowing.toggle()
        animate()
    }
    
    private func animate(){
        let duration = 1.0
        
        if isBackOfCardShowing {
            UIView.transition(with: self, duration: duration, options: [.transitionFlipFromRight], animations: {
                self.factLabel.alpha = 1
                self.titleLabel.alpha = 0
            }, completion: nil)
        } else {
            UIView.transition(with: self, duration: duration, options: [.transitionFlipFromLeft], animations: {
                self.factLabel.alpha = 0
                self.titleLabel.alpha = 1
            }, completion: nil)
        }
    }

    public func configureCell(for card: FlashCard){
        existingFlashCard = card
        titleLabel.text = card.cardTitle
        factLabel.text = card.facts.joined(separator: ". ")
    }
            
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setupEditButtonConstrainsts()
        setupTitleLabelConstrainsts()
        setupFactsLabelConstrainsts()
    }
    
    private func setupEditButtonConstrainsts(){
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: topAnchor),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            editButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            editButton.widthAnchor.constraint(equalTo: editButton.heightAnchor)
        ])
    }
    
    private func setupTitleLabelConstrainsts(){
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupFactsLabelConstrainsts(){
        addSubview(factLabel)
        factLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            factLabel.topAnchor.constraint(equalTo: editButton.bottomAnchor),
            factLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            factLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            factLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
}
