//
//  CharacterCell.swift
//  Rick&Morty
//
//  Created by Kostiantyn Kaniuka on 17.05.2024.
//

import UIKit
import Kingfisher

class CharacterCell: UITableViewCell {
    static let ListCellId = "characterID"
    
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var characterName: UILabel!

    @IBOutlet weak var characterStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData(data: Character) {
        guard let url = URL(string: data.image) else {
            return
        }
        characterImage.kf.setImage(with: url)
        characterName.text = data.name
        characterStatus.text = data.status
        
    }
    
}

private extension CharacterCell {
    
    func setUpCell() {
        characterImage.image = UIImage(named: "Rick")
        characterImage.layer.cornerRadius = 10
        characterImage.clipsToBounds = true 
        characterName.text = "Name"
        characterStatus.text = "Dead"
        
    }
    
}
