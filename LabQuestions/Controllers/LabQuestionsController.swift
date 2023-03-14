//
//  ViewController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class LabQuestionsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var refreshControl: UIRefreshControl!
    
    private var questions = [Question]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchQuestions()
        configureRefreshControl()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        // programmable target-action using objective-C runtime api
        // self refers to the view controller the action has been added to
        refreshControl.addTarget(self, action: #selector(fetchQuestions), for: .valueChanged)
        
    }
    
    @objc private func fetchQuestions() {
        LabQuestionsAPIClient.fetchQuestions { [weak self] (result) in
            
            // stop when completion finishes
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let questions):
                // sort by most recent Date
                // isoStringToDate() converts an ISO data string to a Date object
                // this is needed in order to sort questions by timestamp, with most recent being at top
                self?.questions = questions.sorted { $0.createdAt.isoStringToDate() > $1.createdAt.isoStringToDate() }
                DispatchQueue.main.async {
                    self?.navigationItem.title = "Lab Questions - (\(questions.count))"
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showQuestionDC" {
            guard let questionDVC = segue.destination as? QuestionDetailController, let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("could not load detail view controller")
            }
            let question = questions[indexPath.row]
            questionDVC.question = question
        } else if segue.identifier == "createQuestion" {
            guard let navController = segue.destination as? UINavigationController, let _ = navController.viewControllers.first as? CreateQuestionController  else {
                fatalError("Could not load create question detail controller")
            }
        }
    }
}

extension LabQuestionsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let question = questions[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = question.title
        content.secondaryText = question.createdAt.convertISODate() + " - \(question.labName)"
        cell.contentConfiguration = content
        return cell
    }

}


extension LabQuestionsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
