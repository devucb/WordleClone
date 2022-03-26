//
//  KeyCell.swift
//  WordleClone
//
//  Created by Utku Can BALKIR on 18.03.2022.
//

import UIKit

class KeyCell: UICollectionViewCell {
    
    static let identifier = "KeyCell"
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.hexStringToUIColor(hex: "#383838")
        setupCell()
    }
    private func setupCell() {
        contentView.addSubview(label)
        addConstraints()
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    func configure(with letter: Character) {
        label.text = String(letter.uppercased())
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
}
