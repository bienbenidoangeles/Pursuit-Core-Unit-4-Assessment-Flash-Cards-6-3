//
//  Unit4AssessmentTests.swift
//  Unit4AssessmentTests
//
//  Created by Alex Paul on 2/11/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import XCTest
@testable import Unit4Assessment
import NetworkHelper

class Unit4AssessmentTests: XCTestCase {
    
    let jsonDataOri = """
    [
    {
      "id": "1",
      "quizTitle": "What is the difference between Synchronous & Asynchronous task",
      "facts": [
        "Synchronous: waits until the task have completed",
        "Asynchronous: completes a task in the background and can notify you when complete"
      ]
    },
    {
      "id": "2",
      "quizTitle": "What is Enum or Enumerations",
      "facts": [
        "contains a group of related values",
        "enumerations define a finite number of states, and can bundle associated values with each individual state, you can use them to model the state of your app and its internal processes"
      ]
    }
    ]
    """.data(using: .utf8)!

    func testJSONDataToBeReturned() {
        
        //arrange
        
        let jsonData = jsonDataOri
        
        let expectedTitle = "What is the difference between Synchronous & Asynchronous task"
        
        //act
        do {
            let flashCardTopLevel = try JSONDecoder().decode([LocalFlashCards].self, from: jsonData)
            //assert
            let supTitle = flashCardTopLevel.first?.quizTitle ?? ""
            XCTAssertEqual(expectedTitle, supTitle)
        } catch {
            XCTFail("Failed to decode")
        }
    }
    
    func testLocalAPIClient(){
        //arrange
        let expectedTitle = "What is the difference between Synchronous & Asynchronous task"

        //act
        do{
            let localFlashCards = try LocalFlashCardsService.fetchStocks()
            let supTitle = localFlashCards.first!.quizTitle
            XCTAssertEqual(expectedTitle, supTitle)
        } catch {
            XCTFail("Failed to decode")
        }
    }
    
    func testRemoteAPIClient(){
        //arrange
        let exp = XCTestExpectation(description: "Data was returned")
        var flashCards1 = [FlashCard]()
        
        //act
        RemoteFlashCardsHelper.getRemoteFlashCards(completion: { (result) in
                switch result{
                case .failure(let appError):
                    break
                case .success(let flashCards):
                    flashCards1 = flashCards
                    exp.fulfill()
                }
            }
        )
        
        wait(for: [exp], timeout: 5)
        //assert
        XCTAssertGreaterThan(flashCards1.count, 5)
        
    }

}
