//
//  Answers.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/23/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import Foundation


struct Answer: Decodable {
    
    let createdAt: String
    let name: String
    let questionTitle: String
    let questionLabName: String
    let questionId: String
    let answerDescription: String
    let avatar: String
    let id: String
}
