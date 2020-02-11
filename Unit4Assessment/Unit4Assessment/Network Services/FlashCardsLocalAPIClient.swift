//
//  FlashCardsLocalAPIClient.swift
//  Unit4Assessment
//
//  Created by Bienbenido Angeles on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation

public enum ServiceError: Error {
  case resourcePathDoesNotExist
  case contentsNotFound
  case decodingError(Error)
}

class LocalFlashCardsService {
  public static func fetchStocks() throws -> [LocalFlashCards] {
    guard let path = Bundle.main.path(forResource: "localJSONData", ofType: "json") else {
      throw ServiceError.resourcePathDoesNotExist
    }
    guard let json = FileManager.default.contents(atPath: path) else {
      throw ServiceError.contentsNotFound
    }
    do {
      let stocks = try JSONDecoder().decode([LocalFlashCards].self, from: json)
      return stocks
    } catch {
      throw ServiceError.decodingError(error)
    }
  }
}
