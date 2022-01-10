//
//  RickCollectionViewCell.swift
//  RickAndMortyDebugging
//
//  Created by Kenny Dang on 1/10/22.
//

import UIKit

class RickCollectionViewCell: UICollectionViewCell {
    let imageView = configure(UIImageView()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFill        
    }

    let nameLabel = configure(UILabel()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Placeholder Name"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubviews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addSubviews() {
        addSubview(imageView)
        addSubview(nameLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        ])
    }
}
