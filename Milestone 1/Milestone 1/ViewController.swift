//
//  ViewController.swift
//  Milestone 1
//
//  Created by Przemysław Woźny on 27/11/2023.
//

import UIKit

class ViewController: UITableViewController {
    var flags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        // Do any additional setup after loading the view.
        title = "Country flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        for item in items {
            if item.hasSuffix("@2x.png") {
                flags.append(item)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
            return
        }
        
        vc.selectedImage = flags[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell
        let label = flags[indexPath.row].split(separator: "@")
        cell?.label.text = label[0].description
        cell?.flagImage.image = UIImage(named: flags[indexPath.row])
        return cell ?? UITableViewCell()
    }


}

