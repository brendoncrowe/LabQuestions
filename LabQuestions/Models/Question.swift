//
//  Question.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/19/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let id: String
    let createdAt: String
    let avatar: String
    let name: String
    let description: String
    let labName: String
    let title: String
}
