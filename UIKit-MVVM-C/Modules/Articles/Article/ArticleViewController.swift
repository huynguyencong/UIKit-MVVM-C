//
//  ArticleViewController.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 15/12/2022.
//

import UIKit
import Combine
import Swinject
import Kingfisher

class ArticleViewController: UIViewController, ViewModelContainer {
    static func instantiate(viewModel: ArticleViewModel) -> ArticleViewController {
        let viewController = UIStoryboard(name: "Article", bundle: nil).instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    var viewModel: ArticleViewModel!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.layer.masksToBounds = true

        bind()
    }
    
    func bind() {
        viewModel.$article
            .compactMap({ $0?.title }).assign(to: \.text, on: self.titleLabel)
            .store(in: &cancellables)
        
        viewModel.$article.sink { [weak self] article in
            self?.thumbnailImageView.kf.setImage(with: article?.imageURL)
        }
        .store(in: &cancellables)
    }

}
