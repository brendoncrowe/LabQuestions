//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/19/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
    
    static func fetchQuestions(completion: @escaping
                               (Result<[Question], AppError>) -> ()) {
        let labEndpointURL = "https://63c9a2ab904f040a96622f6f.mockapi.io/questions"
        guard let url = URL(string: labEndpointURL) else {
            completion(.failure(.badURL(labEndpointURL)))
            return
        }
        let request = URLRequest(url: url)
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let questions = try JSONDecoder().decode([Question].self, from: data)
                    completion(.success(questions))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func postQuestion(question: PostedQuestion, completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        let labEndpointURL = "https://63c9a2ab904f040a96622f6f.mockapi.io/questions"
        
        guard let url = URL(string: labEndpointURL) else {
            completion(.failure(.badURL(labEndpointURL)))
            return
        }
        
        do { // making a http POST
            
            let data = try JSONEncoder().encode(question)
            // configure url request
            var request = URLRequest(url: url)
            
            // type of http method
            request.httpMethod = "POST"
            
            // type of data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // provided data being sent to web api
            request.httpBody = data
            
            // execute POST request
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.encodingError(error)))
        }
    }
    
    // doing a POST request
    static func postAnswer(postedAnswer: PostedAnswer,
                           completion: @escaping (Result<Bool, AppError>) -> ()) {
        
        let answerEndpoint = "https://63c9a2ab904f040a96622f6f.mockapi.io/answers"
        
        guard let url = URL(string: answerEndpoint) else {
            completion(.failure(.badURL(answerEndpoint)))
            return
        }
        
        // Steps in making a POST request
        
        // Step 1. convert your Swift model (e.g postedAnswer) to Data
        // Use JSONEncoder().encode to convert postedAnswer to Data
        
        do {
            let data = try JSONEncoder().encode(postedAnswer)
            
            // Step 2. Because multiple values will be added to a URLRequest, create a mutable URLRequest and assign it the endPoint url
            
            var request = URLRequest(url: url)
            
            // Step 3. tell web API what type of data is being sent
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            // Step 4. use httpBody on request to add the data, which is being sent to the web API, created from the postAnswer model. Example of what body looks like below
            /*
             {
             "questionId": "19"
             "questionTitle": "Help with issue"
             "questionLabName": "Lab 1"
             "answerDescription": "Do you know the basics of Swift?"
             }
             */
            
            request.httpBody = data
            
            // Step 5. explicitly tell URLSession what type of http method is being used as GET is default
            request.httpMethod = "POST"
            
            NetworkHelper.shared.performDataTask(with: request) { result in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.encodingError(error)))
        }
    }
    
    static func fetchAnswers(completion: @escaping (Result<[Answer], AppError>) -> ()) {
        let apiEndpoint = "https://63c9a2ab904f040a96622f6f.mockapi.io/answers"
        
        guard let url = URL(string: apiEndpoint) else {
            completion(.failure(.badURL(apiEndpoint)))
            return
        }
        
        let request = URLRequest(url: url)
        
        NetworkHelper.shared.performDataTask(with: request) { result in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {
                    let answers = try JSONDecoder().decode([Answer].self, from: data)
                    completion(.success(answers))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
