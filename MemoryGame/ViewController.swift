//
//  ViewController.swift
//  MemoryGame
//
//  Created by Chaoyi Wu on 2024-10-23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var button_easy: UIImageView!
    @IBOutlet weak var button_medium: UIImageView!
    @IBOutlet weak var button_hard: UIImageView!
    
    let segueIdentifier = "showGameBoard"
    var selectedDifficulty: GameDifficulty = .easy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    @IBAction func difficultyButtonTapped(_ sender: UITapGestureRecognizer) {
        if (sender.view as? UIImageView) != nil {
            switch (sender.view?.tag) {
            case 2:
                button_easy.image = UIImage(named: "button_easy")
                button_medium.image = UIImage(named: "button_medium_selected")
                button_hard.image = UIImage(named: "button_hard")
                selectedDifficulty = .medium
                break
            case 3:
                button_easy.image = UIImage(named: "button_easy")
                button_medium.image = UIImage(named: "button_medium")
                button_hard.image = UIImage(named: "button_hard_selected")
                selectedDifficulty = .hard
                break
            default:
                button_easy.image = UIImage(named: "button_easy_selected")
                button_medium.image = UIImage(named: "button_medium")
                button_hard.image = UIImage(named: "button_hard")
                selectedDifficulty = .easy
                break
            }
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier,
           let gameViewController = segue.destination as? GameViewController {
            gameViewController.difficulty = selectedDifficulty
        }
    }
    
}

