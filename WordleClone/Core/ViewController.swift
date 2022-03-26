//
//  ViewController.swift
//  WordleClone
//
//  Created by Utku Can BALKIR on 18.03.2022.
//

import UIKit

class ViewController: UIViewController, BoardViewControllerDataSource, KeyboardViewControllerDelegate {
    var words = ["after"]
    var answer = ""
    var isUserClickedButton = false
    var userAttempt = 0
    private var guesses: [[Character?]] = Array(
        repeating: Array(repeating: nil,count: 5),
        count: 6)
    let keyboardVC = KeyboardViewController()
    let boardVC = BoardViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.hexStringToUIColor(hex: "#171917")
        setupUI()
        loadWords()
        answer = self.words.randomElement() ?? "after"
    }
    private func setupUI() {
        setupKeyboardView()
        setupBoardView()
        addConstraints()
    }
    private func setupKeyboardView() {
        addChild(keyboardVC)
        keyboardVC.delegate = self
        keyboardVC.didMove(toParent: self)
        keyboardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardVC.view)
    }
    private func setupBoardView() {
        addChild(boardVC)
        boardVC.datasource = self
        boardVC.didMove(toParent: self)
        boardVC.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardVC.view)
    }
    private func addConstraints() {
        NSLayoutConstraint.activate([
            boardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            boardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            boardVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            boardVC.view.bottomAnchor.constraint(equalTo: keyboardVC.view.topAnchor),
            boardVC.view.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
        
            keyboardVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardVC.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    private func gameResult(_ isAnswerCorrect: Bool) {
        let meesage = isAnswerCorrect ? "Winner winner chicken dinner" : "Oops! Wrong answer. Correct answer is \(answer.uppercased())"
        let alert = UIAlertController(title: "Result" , message: meesage, preferredStyle: .alert)
        let action = UIAlertAction(title: "Close", style: .cancel) { _ in
            self.resetGame()
        }
        alert.addAction(action)
        alert.modalPresentationStyle = .overFullScreen
        self.present(alert, animated: true, completion: nil)
    }
    @objc private func resetGame() {
        userAttempt = 0
        guesses = Array(
            repeating: Array(repeating: nil,count: 5),
            count: 6)
        self.boardVC.collectionView.reloadData()
        self.boardVC.collectionView.performBatchUpdates({ [weak self] in
            let visibleItems = self?.boardVC.collectionView.indexPathsForVisibleItems ?? []
            self?.boardVC.collectionView.reloadItems(at: visibleItems)
            }, completion: { (_) in
                self.answer = self.words.randomElement() ?? "after"
            })
    }
    func keyboardViewController(_ vc: KeyboardViewController, didTapkey letter: Character?, row: Int) {
        guesses[userAttempt][row] = letter
        let item = IndexPath.init(item: row, section: userAttempt)
        boardVC.collectionView.reloadItems(at: [item])
    }
    func confirmUserAnswer(_ vc: KeyboardViewController ) {
        isUserClickedButton = true
        let section = IndexSet.init(integer: userAttempt)
        boardVC.collectionView.reloadSections(section)
        isUserClickedButton = false
        if userAttempt < 6 {
            let str: String = currentGuesses[userAttempt].compactMap{ str in String(str ?? " ")}.joined()
            if str == answer {
                gameResult(true)
                return
            }
           userAttempt += 1
        }
        if userAttempt == 6 {
            gameResult(false)
        }
    }
    var currentGuesses: [[Character?]] {
        return guesses
    }
    func boxColor(section: Int, row: Int ) -> UIColor? {
        let indexedAnswer = Array(answer)
        guard let letter = guesses[section][row], self.isUserClickedButton, indexedAnswer.contains(letter) else { return nil }
        if indexedAnswer[row] == letter {
            return UIColor.hexStringToUIColor(hex: "#0089dd")
        }
        return UIColor.hexStringToUIColor(hex: "#dd8f00")
    }
    private func loadWords() {
        guard let filepath = Bundle.main.url(forResource: "words", withExtension: "txt")
                    else {
                        return
                }
                do {
        
                    let content = try String(contentsOf: filepath, encoding: .utf8)
                    self.words = content.components(separatedBy: "\n")
                } catch {
                    print ("File Read Error")
                    return
                }
        
    }
}

extension UIColor {

    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}


