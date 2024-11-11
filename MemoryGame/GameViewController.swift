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
    var cardArts = [String]()
    var cards = [GameCard]()
    var facedUpCards = 0
    @IBOutlet weak var CardCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        print("selected game mode: " + difficulty.rawValue)
        cardTotal = getCardTotal(difficulty: difficulty)
        print("total number of cards: " + String(cardTotal))
        
        var numbers = getNumberOfRandomNum(number: cardTotal/2, lower: 1, upper: 12)
        for num in numbers {
            cardArts.append(defaultIconName + String(num))
            cardArts.append(defaultIconName + String(num))
        }
        cardArts.shuffle()
        for i in 0..<cardTotal {
            cards.append(GameCard(position: i, isMatched: false, isFaceUp: false))
        }
        
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
}

extension GameViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Tapped on card at index \(indexPath.row)")
            
        // Check if the card is already matched or face up
        if cards[indexPath.row].isFaceUp || cards[indexPath.row].isMatched {
            return
        }
            
        // Face up the tapped card and update the view
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
            facedUpCards += 1
        cards[indexPath.row].isFaceUp = true
        cell.CardArtView.image = UIImage(named: cardArts[indexPath.row])
            
        // Additional game logic for matching or handling face-up cards
        if facedUpCards >= 3 {
            print("too many cards facing up")
            for i in 0..<cards.count {
                if i != indexPath.row && !cards[i].isMatched && cards[i].isFaceUp {
                    cards[i].isFaceUp = false
                    let indexPath = IndexPath(row: i, section: 0)
                    if let cellToChange = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell {
                        cellToChange.CardArtView.image = UIImage(named: "background_card")
                    }
                }
            }
            facedUpCards = 1
        } else {
            for i in 0..<cards.count {
                if i != indexPath.row && cards[i].isFaceUp && cardArts[i] == cardArts[indexPath.row] {
                    print("match found")
                    cards[indexPath.row].isMatched = true
                    cards[i].isMatched = true
                    facedUpCards = 0
                }
            }
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = CGFloat(getWidth(difficulty: difficulty))
        let collectionViewWidth = collectionView.bounds.width - 20
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let spaceBetweenCells = flowLayout.minimumInteritemSpacing * (columns - 1)
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
        
        return CGSize(width: width, height: height)
    }
}
