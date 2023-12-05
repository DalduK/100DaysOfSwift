//
//  ViewController.swift
//  Project2
//
//  Created by Przemysław Woźny on 27/11/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var topFlag: UIButton!
    @IBOutlet weak var middleFlag: UIButton!
    @IBOutlet weak var bottomFlag: UIButton!
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var askedQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topFlag.layer.borderWidth = 1
        middleFlag.layer.borderWidth = 1
        bottomFlag.layer.borderWidth = 1
        
        topFlag.layer.cornerRadius = 10
        middleFlag.layer.cornerRadius = 10
        bottomFlag.layer.cornerRadius = 10
        
        topFlag.layer.borderColor = UIColor.gray.cgColor
        middleFlag.layer.borderColor = UIColor.gray.cgColor
        bottomFlag.layer.borderColor = UIColor.gray.cgColor
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        // Do any additional setup after loading the view.
        title = score.description
        shuffle()
        askQuestion()
    }
    func shuffle() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func askQuestion(action: UIAlertAction! = nil) {
        topFlag.setImage(UIImage(named: countries[0]), for: .normal)
        middleFlag.setImage(UIImage(named: countries[1]), for: .normal)
        bottomFlag.setImage(UIImage(named: countries[2]), for: .normal)
        title = "points \(score), out of \(askedQuestions) flag to select \(countries[correctAnswer]) "
    }
    
    @IBAction func flagPressed(_ sender: UIButton) {
        var title: String

        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
            askedQuestions += 1
            shuffle()
        } else {
            title = "Wrong, that's the \(countries[sender.tag])"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)
    }
    
    
}

