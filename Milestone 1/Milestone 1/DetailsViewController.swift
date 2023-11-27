//
//  DetailsViewController.swift
//  Milestone 1
//
//  Created by Przemysław Woźny on 27/11/2023.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var flagImage: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        title = selectedImage?.split(separator: "@")[0].description
        loadImageView(selectedImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.hidesBarsOnTap = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
                
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.hidesBarsOnTap = false
    }
    
    private func loadImageView(_ path: String?) {
        if let path {
            let image = UIImage(named: path)
            flagImage.image = image
        }
    }
    
    @objc private func shareTapped() {
        guard let image = UIImage(named: selectedImage ?? "") else { return }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
}
