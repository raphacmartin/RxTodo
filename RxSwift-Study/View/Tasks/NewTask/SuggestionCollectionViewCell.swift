//
//  SuggestionCollectionViewCell.swift
//  RxSwift-Study
//
//  Created by Raphael Martin on 24/02/23.
//

import UIKit

final class SuggestionCollectionViewCell: UICollectionViewCell {
    // MARK: UI Components
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("🔥")
    }
}

// MARK: View Code methods
extension SuggestionCollectionViewCell: ViewCodeBuildable {
    func setupHierarchy() {
        contentView.addSubview(descriptionLabel)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: 50),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}

// MARK: Public API
extension SuggestionCollectionViewCell {
    public func configure(description: String) {
        descriptionLabel.text = description
    }
}
