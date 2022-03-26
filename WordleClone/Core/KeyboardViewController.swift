//
//  KeyboardViewController.swift
//  WordleClone
//
//  Created by Utku Can BALKIR on 18.03.2022.
//

import UIKit


protocol KeyboardViewControllerDelegate: AnyObject {
    func keyboardViewController(
        _ vc: KeyboardViewController, didTapkey letter: Character?, row: Int)
    func confirmUserAnswer(_ vc: KeyboardViewController)
}

class KeyboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    var userAnswer: String = "" {
        didSet {
            if userAnswer.count == 5 {
            confirmButton.isUserInteractionEnabled = true
            }
            else  {confirmButton.isUserInteractionEnabled = false }
            if userAnswer.count != 0 {
                deleteButton.isUserInteractionEnabled = true
            }
            else {
                deleteButton.isUserInteractionEnabled = false
            }
        }
    }
    weak var delegate: KeyboardViewControllerDelegate?
    var letters = ["qwertyuiop", "asdfghjkl", "zxcvbnm"]
    private var keys: [[Character]] = []
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(KeyCell.self, forCellWithReuseIdentifier: KeyCell.identifier)
        return collectionView
    }()
    let bottomView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true

        return stackView
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitle("DELETE", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0.6
        button.layer.backgroundColor = UIColor.hexStringToUIColor(hex: "#780000").cgColor
        button.addTarget(self, action: #selector(deletebuttonClicked), for: .touchUpInside)
        return button
    }()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.isUserInteractionEnabled = false
        button.setTitle("CONFIRM", for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 0.6
        button.layer.backgroundColor = UIColor.hexStringToUIColor(hex: "#005858").cgColor
        button.addTarget(self, action: #selector(confirmButtobClicked), for: .touchUpInside)
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupUI()
        setupKeys()
    }
    private func setupUI() {
        setupCollectionView()
        setupBottomView()
        addConstraints()
    }
    private func setupCollectionView() {
        view.addSubview(collectionView)
    }
    private func setupBottomView() {
        bottomView.addArrangedSubview(deleteButton)
        bottomView.addArrangedSubview(confirmButton)
        view.addSubview(bottomView)
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
        ])
    }
    private func setupKeys() {
        for row in letters {
            let chars = Array(row)
            keys.append(chars)
        }
    }
    @objc func deletebuttonClicked(_ sender: UIButton) {
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
             sender.alpha = 1.0
         }
        delegate?.keyboardViewController(self, didTapkey: nil, row: userAnswer.count - 1 )
        userAnswer = String(userAnswer.dropLast())
            delegate?.keyboardViewController(self, didTapkey: nil, row: userAnswer.count )
    }
    @objc func confirmButtobClicked(_ sender: UIButton) {
        sender.alpha = 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
             sender.alpha = 1.0
         }
        delegate?.confirmUserAnswer(self)
        userAnswer = ""
    }
}

extension KeyboardViewController {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return keys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keys[section].count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeyCell.identifier, for: indexPath) as? KeyCell else {
            fatalError()
        }
        let letter = keys[indexPath.section][indexPath.row]
        cell.configure(with: letter)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10
        return CGSize(width: size, height: size * 1.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var left: CGFloat = 1
        var right: CGFloat = 1
        let margin: CGFloat = 20
        let size: CGFloat = (collectionView.frame.size.width-margin)/10
        let count: CGFloat = CGFloat(collectionView.numberOfItems(inSection: section))
        let inset: CGFloat = (collectionView.frame.size.width - (size * count) - (2  * count)) / 2
        left = inset
        right = inset
        return UIEdgeInsets(top: 2, left: left, bottom: 2, right: right)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let letter = keys[indexPath.section][indexPath.row]
        if userAnswer.count < 5 {
            delegate?.keyboardViewController(self, didTapkey: letter, row: userAnswer.count )
            userAnswer.append(letter)
        }
        
        
    }
}
