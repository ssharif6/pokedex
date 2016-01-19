//
//  PokeCellCollectionViewCell.swift
//  Pokedex
//
//  Created by Shaheen Sharifian on 1/18/16.
//  Copyright © 2016 Shaheen Sharifian. All rights reserved.
//

import UIKit

class PokeCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Pokemon!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
    }
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
