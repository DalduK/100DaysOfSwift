//
//  ViewController.swift
//  Milestone3
//
//  Created by Przemysław Woźny on 28/02/2024.
//

import UIKit

class ViewController: UIViewController {
    var answerLabel: UILabel!
    var usedLetterLabel: UILabel!
    var numberOfTries: UILabel!
    var textField: UITextField!
    
    
    var usedLetters = [Character]()
    var wrongLetters = [Character]()
    var levels = [String]()
    var promptWord = ""
    var levelCounter = 0
    
    var wisielec = "WISIELEC"
    var tries = "_ _ _ _ _ _ _ _"
    
    override func loadView() {
        loadLevel()
        promptWords()
        view = UIView()
        view.backgroundColor = .white
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.textAlignment = .right
        answerLabel.text = promptWord
        view.addSubview(answerLabel)
        
        numberOfTries = UILabel()
        numberOfTries.translatesAutoresizingMaskIntoConstraints = false
        numberOfTries.textAlignment = .right
        numberOfTries.text = tries
        view.addSubview(numberOfTries)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Wpisz literę"
        textField.autocapitalizationType = UITextAutocapitalizationType.none
        view.addSubview(textField)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
                
        
        NSLayoutConstraint.activate([
            answerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            answerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
            
            numberOfTries.topAnchor.constraint(equalTo: answerLabel.bottomAnchor, constant: 50),
            numberOfTries.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: numberOfTries.bottomAnchor, constant: 50),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            submit.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func submitTapped() {
        if let str = textField.text, textField.text?.count == 1 {
            if !usedLetters.contains(str.first!) {
                usedLetters.append(str.first!)
            }
        } else {
            alertUser()
        }
        promptWords()
        checkForWrongLetters(word: promptWord)
        answerLabel.text = promptWord
        textField.text = ""
        checkIfWonOrLost()
    }
    
    func alertUser() {
        let ac = UIAlertController(title: "Max 1 letter", message: "Can you retype your answer?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Sure!", style: .default, handler: { _ in self.textField.text = ""}))
        present(ac, animated: true)
    }
    
    func loadLevel() {
        if let levelFileURL = Bundle.main.url(forResource: "file", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                levels = lines
            }
        }
    }
    
    func promptWords() {
        let word = levels[levelCounter].lowercased()
        promptWord = ""
        for letter in word {
            let strLetter = String(letter)
            if usedLetters.contains(strLetter) {
                promptWord += strLetter + " "
            } else {
                promptWord += "? "
            }
        }
    }
    
    func checkForWrongLetters(word: String) {
        for i in usedLetters {
            if !word.contains(i) {
                if !wrongLetters.contains(i) {
                    wrongLetters.append(i)
                    replaceValue()
                }
            }
        }
        print(wrongLetters)
    }
    
    func replaceValue() {
        let value = String(wisielec.removeFirst())
        if let range = tries.range(of: "_")  {
            tries = tries.replacingCharacters(in: range, with: value)
            numberOfTries.text = tries
        }
    }
    
    func checkIfWonOrLost() {
        if !promptWord.contains("?") {
            let ac = UIAlertController(title: "Won", message: "Congrats, Level \(levelCounter) completed.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Go next!", style: .default, handler: { _ in self.goToNextLevel() }))
            present(ac, animated: true)
        } else {
            if wisielec.isEmpty {
                let ac = UIAlertController(title: "Lost", message: "Unlucky, Level \(levelCounter) Failed.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Go next!", style: .default, handler: { _ in self.goToNextLevel() }))
                present(ac, animated: true)
            }
        }
    }
    
    func goToNextLevel() {
        if levelCounter == 19 {
            levelCounter += 1
        } else {
            levelCounter = 0
        }
        wisielec = "WISIELEC"
        tries = "_ _ _ _ _ _ _ _"
        numberOfTries.text = tries
        wrongLetters.removeAll()
        usedLetters.removeAll()
        promptWords()
        answerLabel.text = promptWord

    }


}

