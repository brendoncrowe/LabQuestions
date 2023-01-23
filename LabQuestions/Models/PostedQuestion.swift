//
//  PostedQuestion.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/19/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import Foundation


struct PostedQuestion: Encodable {
    let title: String
    let labName: String
    let description: String
    let createdAt: String // timestamp of the created date of the Question 
}
