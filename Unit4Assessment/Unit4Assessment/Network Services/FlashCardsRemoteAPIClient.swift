//
//  FlashCardsRemoteAPIClient.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import NetworkHelper

class RemoteFlashCardsHelper {
    static func getRemoteFlashCards(completion: @escaping (Result<[FlashCard], AppError>)->()){
        let endPointURLString = "lhttps://5daf8b36f2946f001481d81c.mockapi.io/api/v2/cards"
        
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result{
            case.failure(let appError):
                completion(.failure(.networkClientError(appError)))
                do{
                    let offlineFlashCards = try LocalFlashCardsService.fetchStocks()
                    let convertedFlashCards =  offlineFlashCards.map{FlashCard(cardTitle: $0.quizTitle, facts: $0.facts, type: .remote)}
                    completion(.success(convertedFlashCards))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            case .success(let data):
                do{
                    let flashCardsTopLevel = try JSONDecoder().decode(FlashCardTopLevelData.self, from: data)
                    let flashCards = flashCardsTopLevel.cards
                    completion(.success(flashCards))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
        
    }
}
