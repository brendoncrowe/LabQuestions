//
//  LabQuestionsTests.swift
//  LabQuestionsTests
//
//  Created by Brendon Crowe on 1/19/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import XCTest

@testable import LabQuestions

struct CreatedLab: Codable {
  let title: String
  let createdAt: String
}

class LabQuestionsTests: XCTestCase {
  func testPostLabQuestion() {
    // arrange
    let title = "How do we get the image"
    let labName = "Concurrency Lab"
    let description = "Not able to use the svg url, what else can we do to get the image url?"
    let createdAt = String.getISOTimestamp() // getISOTimestamp is an extension on string
    
    let lab = PostedQuestion(title: title, labName: labName, description: description, createdAt: createdAt)
    
    let data = try! JSONEncoder().encode(lab)
    
    let exp = XCTestExpectation(description: "lab posted successfully")
    
    let url = URL(string: "https://63c9a2ab904f040a96622f6f.mockapi.io/questions")!
    
    var request = URLRequest(url: url) // 1. url
    request.httpMethod = "POST" // 2. HTTP method. Set the HTTP method to POST. GET is set by default
    request.httpBody = data // 3. Data being sent to web api
    
    // required to be valid JSON data being uploaded
    // must specify that the data is json
    request.addValue("application/json", forHTTPHeaderField: "Content-Type") // 4. type of data
    
    // act
    NetworkHelper.shared.performDataTask(with: request) { (result) in
      switch result {
      case .failure(let appError):
        XCTFail("failed with error: \(appError)")
      case .success(let data):
        // assert
        let createdLab = try! JSONDecoder().decode(CreatedLab.self, from: data)
        XCTAssertEqual(title, createdLab.title)
        exp.fulfill()
      }
    }
    wait(for: [exp], timeout: 5.0)
  }
}
