//
//  ViewController.swift
//  Milestone2
//
//  Created by Przemysław Woźny on 24/01/2024.
//

import UIKit

class ViewController: UITableViewController {
    private var shoppingList = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista zakupów 🍏"
        tableView.reloadData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "basicCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForUserShopping))
        addMenu()
    }
    
    func addMenu() {
        let menuHandler: UIActionHandler = { action in
            print(action.title)
            if action.title == "Udostępnij" {
                self.shareTapped()
            } else {
                self.clearList()
            }
        }

        let barButtonMenu = UIMenu(image: UIImage(systemName: "slider.horizontal.3"), children: [
            UIAction(title: NSLocalizedString("Udostępnij", comment: ""), image: UIImage(systemName: "square.and.arrow.up"), handler: menuHandler),
            UIAction(title: NSLocalizedString("Usuń kupione", comment: ""), image: UIImage(systemName: "trash"), handler: menuHandler)
        ])

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: nil)
        navigationItem.leftBarButtonItem?.menu = barButtonMenu
    }

    @objc func promptForUserShopping() {
        let ac = UIAlertController(title: "Dodaj produkt", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Dodaj", style: .default) { action in
            guard let answer = ac.textFields?[0].text else { return }
            self.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ product: String) {
        print(product)
        let prod = Product(name: product)
        let indexPath = IndexPath(row: 0, section: 0)
        shoppingList.insert(prod, at: indexPath.row)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if shoppingList[indexPath.row].isSelected {
            cell?.imageView?.image = UIImage(systemName: "circle")
        } else {
            cell?.imageView?.image = UIImage(systemName: "circle.fill")
        }
        shoppingList[indexPath.row].isSelected.toggle()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row].name
        cell.imageView?.image = UIImage(systemName: "circle")
        return cell
    }
    
    @objc func shareTapped() {
        let data = shoppingList.compactMap { prod in
            prod.name
        }
        
        let list = data.joined(separator: "\n")
        
        let vc = UIActivityViewController(activityItems: [list], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func clearList() {
        shoppingList.removeAll { product in
            product.isSelected == true
        }
        tableView.reloadData()
    }
}

