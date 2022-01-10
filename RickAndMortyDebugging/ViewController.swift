//
//  ViewController.swift
//  RickAndMortyDebugging
//
//  Created by Kenny Dang on 1/10/22.
//

import UIKit
import Apollo

class ViewController: UIViewController {

    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)

    lazy var collectionView: UICollectionView = {
        let layout = createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RickCollectionViewCell.self,
                                forCellWithReuseIdentifier: RickCollectionViewCell.reuseIdentifier)
        collectionView.backgroundColor = UIColor.white
        return collectionView
    }()

    private var datasource: UICollectionViewDiffableDataSource<Section, Rick>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section, Rick>()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    enum NetworkError: Error {
        case graphqlErrors([Error])
        case missingData
        case parseFailure
    }

    enum Section {
        case main
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        fetchListOfRicks { result in
            switch result {
            case .success(let ricks):
                self.snapshot.appendSections([.main])
                self.snapshot.appendItems(ricks, toSection: .main)
                self.datasource?.apply(self.snapshot)
            case .failure(let error):
                print(error)
            }
        }
    }

    func fetchListOfRicks(completion: @escaping ((Result<[Rick], Error>) -> Void)) {
        apollo.fetch(query: RickCharactersQuery(page: 1)) { result in
            switch result {
            case .success(let graphqlData):
                if let errors = graphqlData.errors {
                    completion(.failure(NetworkError.graphqlErrors(errors)))
                    return
                }

                guard let parsedData = graphqlData.data?.characters?.results?.compactMap({ $0 }) else {
                    completion(.failure(NetworkError.missingData))
                    return
                }

                let parsedItems = parsedData.compactMap({ Rick(id: $0.id ?? "missing id",
                                                                     imageString: $0.image ?? "missing image",
                                                                     name: $0.name ?? "missing name") })

                completion(.success(parsedItems))

            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func configureDataSource() {
        datasource = UICollectionViewDiffableDataSource<Section, Rick>(
            collectionView: self.collectionView, cellProvider: {[weak self](collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RickCollectionViewCell.reuseIdentifier, for: indexPath) as! RickCollectionViewCell                
                cell.nameLabel.text = item.name
                cell.imageView.image = UIImage(data: try! Data(contentsOf: URL(string: item.imageString)!))
                return cell
        })
    }
}
