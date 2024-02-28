//
//  ViewController.swift
//  Project7
//
//  Created by Przemysław Woźny on 07/02/2024.
//

import UIKit

class ViewController: UITableViewController  {
    var petitions = [Petition]()
    var filteredPetition = [Petition]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let camera = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(presentAlert))
        self.navigationItem.rightBarButtonItem = camera
        
        let filtr = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(promptForFiltr))
        self.navigationItem.leftBarButtonItem = filtr
        
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
            self.showError()
        }
    }
    
    @objc func presentAlert() {
        let ac = UIAlertController(title: "Data", message: "The Data comes from We The People API of the Whitehouse.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Thanks!", style: .default))
        present(ac, animated: true)
    }
    
    
    @objc func promptForFiltr() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]
            self.filteredPetition = self.petitions.filter({ petition in
                petition.title.lowercased().contains(answer.text?.lowercased() ?? "")
            })
            self.reloadData()
        }
        
        let clear = UIAlertAction(title: "Clear", style: .default) { _ in
            self.filteredPetition = self.petitions
            // do something interesting with "answer" here
            self.reloadData()
        }

        ac.addAction(submitAction)
        ac.addAction(clear)

        present(ac, animated: true)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetition = petitions
            self.reloadData()
        }
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetition.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetition[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = filteredPetition[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

