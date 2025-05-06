//
//  ViewController.swift
//  lifecounter
//
//  Created by George Lee on 4/18/25.
//

import UIKit
import Foundation
var history = Items.HistoryArrayShared
class Player {
    var playerName: String
    var lifeTotal: Int
    var currentCustom : Int
    
    init(name: String, lifeTotal: Int = 20) {
        self.playerName = name
        self.lifeTotal = lifeTotal
        
        
        // attempting to set a current life value is quite hard, so just saving the edit in here
        self.currentCustom = 5
    }
    
    func reduceLife() {
        lifeTotal -= 1
        history.addItem("\(playerName) has lost \(1) life")
    }
    func increaseLife() {
        lifeTotal += 1
        history.addItem("\(playerName) has gained \(1) life")
    }
    func customAddLife(_ amount : Int) {
        lifeTotal += amount
        history.addItem("\(playerName) has gained \(currentCustom) life")
    }
        func customReduceLife(_ amount: Int){
            lifeTotal -= amount
            history.addItem("\(playerName) has lost \(amount) life")
        }
        
    }

class EditableButton: UIButton {
    var newValue: Int = 5
}

class ViewController: UIViewController, UITextFieldDelegate {
        var players: [Player] = []
        var playerViews: [UIView] = []
        
        
        let scrollView = UIScrollView()
        let toolbar = UIToolbar()
        var addPlayerButton = UIBarButtonItem()
        var removePlayerButton = UIBarButtonItem()
        var resetButton = UIBarButtonItem()
            
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Initialize with 4 players
            players = [
                Player(name: "Player 1"),
                Player(name: "Player 2"),
                Player(name: "Player 3"),
                Player(name: "Player 4")
            ]
            setupScrollView()
            setupToolBar()
            drawPlayers()
        }
        
        
       @objc func removePlayer() {
            if players.count > 2 {
                players.removeLast()
            }
        }
        
    
    func gameOver(){
        toolbar.items?.removeAll()
        
        let alert = UIAlertController(title: "Game Over!", message: "Press Reset Game to play again!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
        resetButton = UIBarButtonItem(title: "Reset Game", style: .done, target: self, action: #selector(resetGame))
        toolbar.items = [resetButton]
    }
    
    @objc func resetGame(_ sender: UIBarButtonItem) {
        players = [
            Player(name: "Player 1"),
            Player(name: "Player 2"),
            Player(name: "Player 3"),
            Player(name: "Player 4")
        ]
        history.clearTableView()
        drawPlayers()
        toolbar.items?.removeAll()
        toolbar.items = [addPlayerButton, removePlayerButton]
        addPlayerButton.isEnabled = true
    }
    
        func setupScrollView() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(scrollView)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
        
    func setupToolBar(){
        toolbar.frame = CGRect(x:0, y: 0, width: Int(view.frame.width), height: 120)
        toolbar.barTintColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
        view.addSubview(toolbar)
        
        
         addPlayerButton = UIBarButtonItem(title: "Add Player", style: .plain, target: self, action: #selector(toolbarAddPlayer))
         removePlayerButton = UIBarButtonItem(title: "Remove Player", style: .plain, target: self, action: #selector(toolbarRemovePlayer))
        toolbar.items = [addPlayerButton, removePlayerButton]

      
     

    }
    @objc func toolbarAddPlayer(_ sender: UIBarButtonItem) {
        if players.count >= 8 {
            let alert = UIAlertController(title: "Cannot Add Player", message: "You can't have more than 8 players.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let newPlayer = Player(name: "Player \(players.count + 1)")
        players.append(newPlayer)
        drawPlayers()
    }
    
    @objc func toolbarRemovePlayer(_ sender: UIBarButtonItem) {
        if players.count <= 2 {
            let alert = UIAlertController(title: "Cannot Remove Player", message: "You must have at least 2 players.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        players.removeLast()
        drawPlayers()
    }

        
        func drawPlayers() {
            var deadPlayers = Set<Int>()
                for (index, player) in players.enumerated() {
                    if player.lifeTotal <= 0 {
                        deadPlayers.insert(index)
                    }
            }
            var yOffset = 100
            
            for subview in scrollView.subviews {
                  subview.removeFromSuperview()
              }
            
            for (index, player) in players.enumerated() {
                let containerView = UIView(frame: CGRect(x: 20, y: yOffset, width: Int(view.frame.width) - 40, height: 120))
                containerView.backgroundColor = UIColor.systemGray6
                containerView.layer.cornerRadius = 10
                
                let playerLabel = UILabel(frame: CGRect(x: 10, y: 10, width: containerView.frame.width - 20, height: 30))
                playerLabel.text = "\(player.playerName): \(player.lifeTotal)"
                playerLabel.tag = 100 + index
                
                let addButton = UIButton(type: .system)
                addButton.frame = CGRect(x: 10, y: 50, width: 60, height: 30)
                addButton.setTitle("+1", for: .normal)
                addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                addButton.tag = index
                addButton.addTarget(self, action: #selector(addLife(_:)), for: .touchUpInside)
                
                let subtractButton = UIButton(type: .system)
                subtractButton.frame = CGRect(x: 80, y: 50, width: 60, height: 30)
                subtractButton.setTitle("-1", for: .normal)
                subtractButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                subtractButton.tag = index
                subtractButton.addTarget(self, action: #selector(subtractLife(_:)), for: .touchUpInside)
                
                let customAddButton = EditableButton(type: .system)
                customAddButton.frame = CGRect(x: 150, y: 50, width: 80, height: 30)
                customAddButton.newValue = player.currentCustom
                customAddButton.setTitle("+\(customAddButton.newValue)", for: .normal)
                customAddButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                customAddButton.tag = index
                customAddButton.addTarget(self, action: #selector(addCustomLife(_:)), for: .touchUpInside)
                
                let customSubtractButton = EditableButton(type: .system)
                customSubtractButton.frame = CGRect(x: 240, y: 50, width: 80, height: 30)
                customSubtractButton.newValue = player.currentCustom
                customSubtractButton.setTitle("-\(customSubtractButton.newValue)", for: .normal)
                customSubtractButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                customSubtractButton.tag = index
                customSubtractButton.addTarget(self, action: #selector(subtractCustomLife(_:)), for: .touchUpInside)
                
                let addButtomEditField = UITextField()
                addButtomEditField.frame = CGRect(x: 150, y: 80, width: 80, height: 30)
                addButtomEditField.placeholder = "change value"
                addButtomEditField.delegate = self
                addButtomEditField.tag = index
                
                let changePlayerField = UITextField(frame: playerLabel.frame)
                changePlayerField.keyboardType = .default
                changePlayerField.delegate = self
                changePlayerField.tag = index + 1000
                changePlayerField.placeholder = ""
                changePlayerField.backgroundColor = .clear
                changePlayerField.textAlignment = .left
                
                
                if deadPlayers.contains(index) {
                    addButton.isEnabled = false
                    subtractButton.isEnabled = false
                    customAddButton.isEnabled = false
                    customSubtractButton.isEnabled = false
                    addButtomEditField.isEnabled = false
                }
                
                containerView.addSubview(changePlayerField)
                containerView.addSubview(addButtomEditField)
                containerView.addSubview(playerLabel)
                containerView.addSubview(addButton)
                containerView.addSubview(subtractButton)
                containerView.addSubview(customAddButton)
                containerView.addSubview(customSubtractButton)
                
                
                scrollView.addSubview(containerView)
                
                yOffset += 140
            }
            
            scrollView.contentSize = CGSize(width: view.frame.width, height: CGFloat(yOffset))
            
            if deadPlayers.count == players.count - 1 {
                    gameOver()
                }
            
        }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag >= 1000 {
            let  playerIndex = Int(textField.tag) - 1000
            players[playerIndex].playerName = textField.text!
            textField.resignFirstResponder()
            drawPlayers()
            return true
        }
        else {
            let playerIndex = Int(textField.tag)
            players[playerIndex].currentCustom = Int(textField.text!) ?? Int(5)
            
            textField.resignFirstResponder()
            drawPlayers()
            return true
        }
    }
    


        
        // From StackOverFlow, doing this myself is impossible
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.tag >=  1000{
            return true
        }
        else {
            let aSet = CharacterSet(charactersIn: "0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }
    }
        
        @objc func addLife(_ sender: UIButton) {
            let index = sender.tag
            if players.indices.contains(index) {
                let player = players[index]
                player.increaseLife()
                addPlayerButton.isEnabled = false
            }
            drawPlayers()
        }
        
        @objc func subtractLife(_ sender: UIButton) {
            let index = sender.tag
            guard let containerView = sender.superview else { return }
            if players.indices.contains(index) {
                let player = players[index]
                player.reduceLife()
                addPlayerButton.isEnabled = false
            }
            drawPlayers()
        }


        
        @objc func addCustomLife(_ sender: EditableButton){
            let index = sender.tag
            if players.indices.contains(index){
                let player = players[index]
                player.customAddLife(sender.newValue)
                addPlayerButton.isEnabled = false
            }
            drawPlayers()
        }
        
        @objc func subtractCustomLife(_ sender: EditableButton){
            let index = sender.tag
            if players.indices.contains(index){
                let player = players[index]
                player.customReduceLife(sender.newValue)
                addPlayerButton.isEnabled = false
            }
            drawPlayers()
        }
        
    
    
    }

