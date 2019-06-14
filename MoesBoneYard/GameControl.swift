//
//  GameControl.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/20/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit

extension GameScene {
    func gameStart() {
        comeOutRoll = true
        resetGame()
        resetPlacedBetPositions()
    }

	func setupNewRound() {
		resetComeOutRoll()
		for bet in availableBets {
			bet.removeAllChildren()
			bet.chipsWagered.removeAll()
			bet.betState = .Off
			bet.validBet = true
			resetPlacedBetPositions()
		}
	}

    func resetGame() {
        for bet in availableBets {
            bet.removeAllChildren()
            bet.chipsWagered.removeAll()
            bet.betState = .On
        }
        placedBets.removeAll()
        comeBet.betState = .Off
        dontComeBet.betState = .Off
        player.chipTotal = 10000
    }

    func resetComeOutRoll() {
        passLineBet.chipsWagered.removeAll()
        dontPassBet.chipsWagered.removeAll()
        for pointBet in pointsBets {
            pointBet.betState = .Off
            pointBet.chipsWagered.removeAll()
            //pointBet.removeAllChildren()
        }
		comeOutRoll = true
    }

	func resetPlacedBetPositions() {
		for bet in availableBets {
			bet.placedBetPosition = CGPoint(x: 0, y: 0)
		}
	}
}
