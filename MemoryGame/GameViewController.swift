//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Chaoyi Wu on 2024-10-23.
//

import UIKit

class GameViewController: UIViewController {

    var difficulty: GameDifficulty = .easy
    var cardTotal: Int = getCardTotal(difficulty: .easy)
    var cards = [String]()
    @IBOutlet weak var CardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        print("selected game mode: " + difficulty.rawValue)
        cardTotal = getCardTotal(difficulty: difficulty)
        print("total number of cards: " + String(cardTotal))
        
        var numbers = getNumberOfRandomNum(number: cardTotal/2, lower: 1, upper: 12)
        for num in numbers {
            cards.append(defaultIconName + String(num))
            cards.append(defaultIconName + String(num))
        }
        cards.shuffle()
        print(cards)
        
        CardCollectionView.dataSource = self
        CardCollectionView.delegate = self
    }
    
    func getNumberOfRandomNum(number: Int, lower: Int, upper: Int) -> Array<Int> {
        var numbers = [Int]()
        for _ in 1 ... number {
            var num = Int.random(in: lower...upper)
            while (numbers.contains(num)){
                num = Int.random(in: lower...upper)
            }
            numbers.append(num)
        }
        return numbers
    }

}

extension GameViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardTotal
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        cell.CardArtView.image = UIImage(named: "background_card")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = CGFloat(getWidth(difficulty: difficulty))
        let collectionViewWidth = collectionView.bounds.width - 20
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
        print("flowLayout minimum inter item spacing: " + String(Float(flowLayout.minimumInteritemSpacing)))
        let adjustedWidth = collectionViewWidth - spaceBetweenCells
        var width: CGFloat = adjustedWidth / columns
        switch difficulty {
            case .easy:
                width -= 35
                break
            case .medium:
                width -= 30
                break
            default:
                break
        }
        let height: CGFloat = width + 10
        
        print("width: " + String(Float(width)), " height: " + String(Float(height)))
        return CGSize(width: width, height: height)
    }
}
