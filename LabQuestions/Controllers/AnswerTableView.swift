//
//  AnswerTableView.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/23/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import UIKit

class AnswerTableView: UITableViewController {
    
    var answers = [Answer]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var question: Question?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAnswers()
    }
    
    private func loadAnswers() {
        guard let question = question else {
            fatalError("no question found")
        }
        LabQuestionsAPIClient.fetchAnswers { [weak self] result in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Failed to fetch answers: \(appError)")
                }
            case .success(let answers):
                self?.answers = answers.filter { $0.questionId == question.id }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath)
        let answer = answers[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = answer.answerDescription
        cell.textLabel?.numberOfLines = 0
        cell.contentConfiguration = content
        return cell
    }
}
