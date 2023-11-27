//
//  DetailViewController.swift
//  Project1
//
//  Created by Przemysław Woźny on 27/11/2023.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var selectedImage: String?
    var numberInList: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = numberInList
        loadImageView(selectedImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        navigationItem.largeTitleDisplayMode = .never
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc private func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    private func loadImageView(_ path: String?) {
        if let path {
            let image = UIImage(named: path)
            imageView.image = image
        }
    }
}
