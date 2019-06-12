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

	func rollButtonTouched() {
		if passLineBet.chipsWagered.count > 0 || dontPassBet.chipsWagered.count > 0 {
			rollDice(dice: currentDice)
		} else {
			print("You must place a bet on either 'PassLine' or 'Don't Pass' on the Come Out Roll.  Please place your bet to continue")
		}
	}
	
	func getTexture(name: String) -> SKTexture {
		let chipName = name
		for chip in chips where chip.name == chipName {
			selectedChipTexture = chip.texture!
			//print("Selected Chip: \(chip.name!)")
			//print("Passed Chip: \(chipName)")
		}
		return selectedChipTexture
	}

	func getPointBet() -> TableBet {
		var theBet = TableBet()
		switch dieTotal {
		case 4:
			theBet = fours
		case 5:
			theBet = fives
		case 6:
			theBet = sixes
		case 8:
			theBet = eights
		case 9:
			theBet = nines
		case 10:
			theBet = tens
		default:
			break
		}
		return theBet
	}

	func setupComeOutRoll() {
		if passLineBet.chipsWagered.count > 0 {
			passLineBet.betState = .On
			comeOutBetType = .Pass
		} else if dontPassBet.chipsWagered.count > 0 {
			dontPassBet.betState = .On
			comeOutBetType = .DontPass
			passLineBet.betState = .Off
		} else {
			noValidBetsPlaced()
		}
	}

	func noValidBetsPlaced() {
		print("No Valid Bets Placed for Come Out Roll. Valid Bets for Come Out Roll are 'PassLineBet or DontPassBet")
	}

	func resetComeOutRoll() {
		comeOutRoll = true
		passLineBet.chipsWagered.removeAll()
		dontPassBet.chipsWagered.removeAll()
		for pointBet in pointsBets {
			pointBet.betState = .Off
			pointBet.chipsWagered.removeAll()
			pointBet.removeAllChildren()
		}
	}

	func setupNewRound() {
		for bet in availableBets {
			bet.removeAllChildren()
			bet.chipsWagered.removeAll()
			bet.betState = .Off
			bet.validBet = true
			resetPlacedBetPositions()
		}
	}

	func displayBets() {
		for placedBet in placedBets {
			let placedBetChildren = placedBet.children
			for child in placedBetChildren {
				print("\(placedBet.name!) child: \(child.name!)")
			}
		}
	}
}

