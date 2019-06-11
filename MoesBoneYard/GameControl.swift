//
//  GameControl.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/20/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit

extension GameScene {
	func rollButtonTouched() {
		rollDice(dice: currentDice)
	}
	
	func getTexture(name: String) -> SKTexture {
		let chipName = name
		for chip in chips where chip.name == chipName {
			selectedChipTexture = chip.texture!
			print("Selected Chip: \(chip.name!)")
			print("Passed Chip: \(chipName)")
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
		}
	}
}

