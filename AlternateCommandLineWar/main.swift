//
//  main.swift
//  AlternateCommandLineWar
//
//  Created by Gordon, Russell on 2020-02-12.
//  Copyright © 2020 Gordon, Russell. All rights reserved.
//

import Foundation

class BeggarThyNeighbor {
    
    // Declare all the vaiables
    var deck : Deck
    var playerHand : Hand
    var computerHand : Hand
    var middle : Hand
    var offense : Hand
    var defense : Hand
    var chances : Int = 0
    var rounds : Int = 0
    var numberOfShowdown : Int = 0
    var GameIsOver = false
    
    // Initializing all the variables
    init() {
        
        // Initialize the deck
        self.deck = Deck()
        
        // Initialize the each player and the bounty
        playerHand = Hand(description: "player")
        computerHand = Hand(description: "computer")
        middle = Hand(description: "middle card(s)")
        
        // Deal out the cards
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            self.playerHand.cards = newCards
        }
        
        if let newCards = self.deck.randomlyDealOut(thisManyCards: 26) {
            self.computerHand.cards = newCards
        }
        
        // Set the middle empty
        self.middle.cards = []
        
        // Assign who is offense and defense
        offense = playerHand
        defense = computerHand
        
        // Play the game
        play()
    }
    
    // Check if the card triggers showdown
    func doesTriggerShowDown(card: Card) -> Int {
        switch middle.cards.last!.rank {
        case.jack:
            chances = 1
            return(chances)
            
        case.queen:
            chances = 2
            return(chances)
            
        case.king:
            chances = 3
            return(chances)
            
        case.ace:
            chances = 4
            return(chances)
            
        default: return(-1)
        }
    }
    
    // When a face card is dealt
    func showDown(from: Hand, against: Hand) {
        
        numberOfShowdown += 1
        
        print("\(middle.cards.last!.simpleDescription()) from \(offense.description) activate showndown against \(defense.description)")
        print("\(defense.description) has \(chances) chances")
        print("- - - - - - - - - - - - - - - - - - -")
        
        while chances != 0 {
            
            if defense.cards.count > 0 {
                
                print("\(defense.description) deals the top card of \(defense.topCard!.simpleDescription())")
                
                middle.cards.append(defense.dealTopCard()!)
                chances -= 1
                if doesTriggerShowDown(card: middle.cards.last!) != -1 {
                    while chances != 0 {
                        switchWhoIsOnOffense()
                        showDown(from: offense, against: defense)
                    }
                } else if chances == 0 {
                    print("The winner of the showdown is \(offense.description)")
                    offense.cards.append(contentsOf: middle.cards)
                    middle.cards.removeAll()
                }
            } else {
                chances = 0
                annouceWinner(Winner: offense.description)
                GameIsOver = true
            }
        }
    }
    
    
    // Play Beggar Thy Neighbour
    func play() {
        
        // Game is about to start
        print("==========")
        print("Game start")
        print("==========")
        
        while offense.cards.count > 0 && GameIsOver == false {
            
            // Track the number of rounds
            rounds += 1
            
            // Report on hand starting
            print("--------------------------------")
            print("Now starting round \(rounds)...")
            playerHand.status(verbose: false)
            computerHand.status(verbose: false)
            middle.status(verbose: false)
            
            print("\(offense.description) deals the top card of \(offense.topCard!.simpleDescription())")
            
            middle.cards.append(offense.dealTopCard()!)
            if doesTriggerShowDown(card: middle.cards.last!) != -1 {
                showDown(from: offense, against: defense)
            } else if offense.cards.count == 0 {
                annouceWinner(Winner: defense.description)
            } else {
                switchWhoIsOnOffense()
            }
        }
    }
    
    // Annouce the winner
    func annouceWinner(Winner: String) {
        print("=================================")
        print("The winner of the game is \(Winner)")
        print("- - - - - - - - - - - - - - - - -")
        print("Total number of rounds played: \(rounds)")
        print("Total number of showdown triggered: \(numberOfShowdown)")
        GameIsOver = true
    }
    
    // Switch the offense and defense position
    func switchWhoIsOnOffense() {
        if offense === playerHand {
            offense = computerHand
            defense = playerHand
        } else {
            offense = playerHand
            defense = computerHand
        }
    }
}


// Creates an instance of a class -- to play the game
BeggarThyNeighbor()
