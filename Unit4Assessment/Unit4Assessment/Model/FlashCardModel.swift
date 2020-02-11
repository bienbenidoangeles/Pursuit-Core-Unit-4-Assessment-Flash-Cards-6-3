//
//  FlashCardModel.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

struct FlashCardTopLevelData: Codable & Equatable {
    let cards: [FlashCard]
}

struct FlashCard: Codable & Equatable {
    let cardTitle: String
    let facts: [String]
}