//
//  AnswerViewController.swift
//  LabQuestions
//
//  Created by Brendon Crowe on 1/23/23.
//  Copyright © 2023 Alex Paul. All rights reserved.
//

import UIKit

class AnswerQuestionController: UIViewController {
    
    @IBOutlet weak var answerTextView: UITextView!
    
    var question: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func postAnswer(_ sender: UIBarButtonItem) {
        // disable the post button to prevent multiple post requests
        
        sender.isEnabled = false
        guard let answerText = answerTextView.text, !answerText.isEmpty, let question = question else {
            showAlert(title: "Missing Fields", message: "Answer is required")
            sender.isEnabled = true
            return
        }
        
        // create a PostedAnswer instance
        let postedAnswer = PostedAnswer(questionTitle: question.title, questionId: question.id, questionLabName: question.labName, answerDescription: answerText, createdAt: String.getISOTimestamp())
        
        LabQuestionsAPIClient.postAnswer(postedAnswer: postedAnswer) { [weak self, weak sender] result in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "There was an error submitting your answer \(appError)")
                    sender?.isEnabled = true
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "Your answer was submitted") {
                        alert in
                        self?.dismiss(animated: true)
                    }
                }
            }
        }
    }
}
