//
//  PostedAnswer.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/23/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import Foundation


struct PostedAnswer: Encodable {
    let questionTitle: String
    let questionId: String // needed for searching all answers to a question 
    let questionLabName: String
    let answerDescription: String
    let createdAt: String
}

