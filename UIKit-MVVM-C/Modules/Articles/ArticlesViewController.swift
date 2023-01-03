//
//  ViewController.swift
//  MVVM-C
//
//  Created by Huy Nguyen on 14/12/2022.
//

import UIKit
import Combine
import Swinject

protocol ArticlesViewControllerDelegate: AnyObject {
    func articlesViewController(_ sender: ArticlesViewController, didSelect article: Article)
    func articlesViewControllerIsDeiniting(_ sender: ArticlesViewController)
}

class ArticlesViewController: UIViewController, ViewModelContainer {
    static func instantiate(viewModel: ArticlesViewModel) -> ArticlesViewController {
        let viewController = UIStoryboard(name: "Article", bundle: nil).instantiateInitialViewController() as! ArticlesViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    var viewModel: ArticlesViewModel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ArticlesViewControllerDelegate?
    
    var dataSource: UICollectionViewDiffableDataSource<String, String>!
    
    private var cancellable = Set<AnyCancellable>()
    
    deinit {
        delegate?.articlesViewControllerIsDeiniting(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        
        createLayout()
        createDataSource()
        bind()
    }

    func bind() {
        viewModel.$cellModels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cellModels in
                self?.applySnapshot(cellModels: cellModels)
            }
            .store(in: &cancellable)
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self else { return nil }
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ArticleCollectionViewCell.self), for: indexPath) as? ArticleCollectionViewCell,
               let cellModel = self.viewModel.cellModels.first(where: { $0.id == itemIdentifier })
            {
                cell.config(viewModel: cellModel)
                return cell
            }
            
            return nil
        })
    }
    
    private func createLayout() {
        let itemSize1 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let item1 = NSCollectionLayoutItem(layoutSize: itemSize1)
        
        let itemSize2 = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .estimated(200))
        let item2 = NSCollectionLayoutItem(layoutSize: itemSize2)
        
        let group2Size = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group2  = NSCollectionLayoutGroup.horizontal(layoutSize: group2Size, subitems: [item2, item2])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(400))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item1, group2])
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        collectionView.collectionViewLayout = layout
    }
    
    private func applySnapshot(cellModels: [ArticleCollectionViewCell.ViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        snapshot.appendSections([""])
        
        let ids = cellModels.map({ $0.id })
        snapshot.appendItems(ids)
        
        dataSource.apply(snapshot)
    }
}

// MARK: - UICollectionViewDelegate
extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let article = viewModel.articles[indexPath.item]
        delegate?.articlesViewController(self, didSelect: article)
    }
}
