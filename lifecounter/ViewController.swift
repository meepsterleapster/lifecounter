//
//  ViewController.swift
//  lifecounter
//
//  Created by George Lee on 4/18/25.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    
    // Player One health incrementers
    
    // Health totals
    
    var playerOneHealthValue = 100
    var playerTwoHealthValue = 100
    
    
    
    @IBOutlet weak var playerOneHealth: UILabel!
    
    
    @IBOutlet weak var playerTwoHealth: UILabel!
    
    
    
    // DeathLabel
    
    @IBOutlet weak var deathLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateHealthVal()
        
    }
    
    func updateHealthVal(){
        
        if(playerOneHealthValue <= 0){
            deathLabel.isHidden = false
            deathLabel.text = "Player One Loses!"
        } else if(playerTwoHealthValue <= 0 ){
            deathLabel.isHidden = false
            deathLabel.text = "Player Two Loses!"
        }
        
        playerOneHealth.text = "\(playerOneHealthValue)"
        playerTwoHealth.text = "\(playerTwoHealthValue)"
    
        
    }
    // Player One Updates
    
    @IBAction func playerOneMinus5(_ sender: Any) {
        playerOneHealthValue -= 5
        updateHealthVal( )
    }
    
    @IBAction func playerOneMinus1(_ sender: Any) {
        playerOneHealthValue -= 1
        updateHealthVal( )
    }
    
    @IBAction func playerOnePlus1(_ sender: Any) {
        playerOneHealthValue += 1
        updateHealthVal()
    }
    
    
    @IBAction func playerOnePlus5(_ sender: Any) {
        playerOneHealthValue += 5
        updateHealthVal()
    }
    
    
    
    //Player Two Updates
    @IBAction func playerTwoMinus5(_ sender: Any) {
        playerTwoHealthValue -= 5
        updateHealthVal()
    }
    
    @IBAction func playerTwoMinus1(_ sender: Any) {
        playerTwoHealthValue -= 1
        updateHealthVal()
    }
    
    @IBAction func playerTwoPlus1(_ sender: Any) {
        playerTwoHealthValue += 1
        updateHealthVal()
    }
    
    @IBAction func playerTwoPlus5(_ sender: Any) {
        playerTwoHealthValue += 5
        updateHealthVal()
    }
    
    
}

