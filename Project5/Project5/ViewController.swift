//
//  ViewController.swift
//  Project5
//
//  Created by Przemysław Woźny on 30/11/2023.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")

        // Do any additional setup after loading the view.
        if let startWords = Bundle.main.path(forResource: "start", ofType: ".txt") {
            if let startsWord = try? String(contentsOfFile: startWords) {
                allWords = startsWord.components(separatedBy: "\n")
            }
        }
        
        if usedWords.isEmpty {
            usedWords = ["silkworm"]
        }
        startGame()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))

    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    @objc func restartGame() {
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { action in
            guard let answer = ac.textFields?[0].text else { return }
            self.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        var errorTitle = "That's Correct"
        var errorMessage = "\(answer) can be spelled from \(title)"
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(lowerAnswer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    
        showErrorMessage(errorTitle , errorMessage)
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                guard let title = title?.lowercased() else { return false }
                showErrorMessage("Word not possible", "You can't spell that word from \(title)")
                return false
            }
        }

        return true
    }

    func isOriginal(word: String) -> Bool {
        if word.lowercased() == title?.lowercased() {
            showErrorMessage("Word used is a title", "Please write word that isn't a title.")
            return false
        }
        
        if !usedWords.contains(word) {
            showErrorMessage("Word used already", "Be more original!")
            return false
        }
        
        return true
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        if word.utf16.count < 3 {
            showErrorMessage("To short!", "Please write word that is longer then 3 characters.")
            return false
        }
        
        if misspelledRange.location == NSNotFound {
            showErrorMessage("Word not recognised", "You can't just make them up, you know!")
            return false
        }
        
        return true
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

