//
//  CreateFlashCardsView.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class CreateFlashCardsView: UIView {
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a fact title"
        return textField
    }()
    
    lazy var topTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    lazy var bottomTextView: UITextView = {
        let textView = UITextView()
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
        self.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        setupTextFieldConstrainsts()
        setupTopTextViewConstrainsts()
        setupBottomTextViewConstrainsts()
    }
    
    private func setupTextFieldConstrainsts(){
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 8),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05)
        ])
    }
    
    private func setupTopTextViewConstrainsts(){
        addSubview(topTextView)
        topTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topTextView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            topTextView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            topTextView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            topTextView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    private func setupBottomTextViewConstrainsts(){
        addSubview(bottomTextView)
        bottomTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomTextView.centerYAnchor.constraint(equalTo: topTextView.bottomAnchor, constant: self.frame.height * 0.15),
            bottomTextView.heightAnchor.constraint(equalTo: topTextView.heightAnchor),
            bottomTextView.widthAnchor.constraint(equalTo: topTextView.widthAnchor, multiplier: 1),
            bottomTextView.centerXAnchor.constraint(equalTo: topTextView.centerXAnchor)
        ])
    }
    
}
