//
//  ArticleCollectionViewCell.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 14/12/2022.
//

import UIKit
import Kingfisher

class ArticleCollectionViewCell: UICollectionViewCell {
    struct ViewModel: ItemViewModel {
        let id: String
        let title: String
        let imageURL: URL?
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.layer.masksToBounds = true
    }
    
    func config(viewModel: ViewModel) {
        titleLabel.text = viewModel.title
        thumbnailImageView.kf.setImage(with: viewModel.imageURL)
    }
}
