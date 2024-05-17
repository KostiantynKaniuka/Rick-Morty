//
//  DetailViewController.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import UIKit
import Kingfisher

final class DetailViewController: UIViewController {
    
    @IBOutlet private weak var characterImage: UIImageView!
    @IBOutlet private weak var characterName: UILabel!
    @IBOutlet private weak var characterStatus: UILabel!
    @IBOutlet private weak var descriptionText: UITextView!
    
    private let viewModel: DetailViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        navigationController?.navigationBar.isHidden = false 
        navigationController?.navigationBar.tintColor = .systemGreen
    }

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        guard let url = URL(string: viewModel.characterData.image) else {
            return
        }
        characterImage.kf.setImage(with: url)
        characterName.text = viewModel.characterData.name
        characterStatus.text = viewModel.characterData.status
        descriptionText.text = "\(viewModel.characterData.gender) \n \(viewModel.characterData.type)"
        ///I didn't find the value with large descriptions in the documentation of characters or etc., so just put only 2 vales
        ///
        
        characterImage.layer.cornerRadius = 10
        characterImage.clipsToBounds = true
    }
}
