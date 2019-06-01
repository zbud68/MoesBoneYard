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
	}

	func rollButtonTouched() {
		rollResult = rollDice(dice: currentDice)

		if rollResult == .Win {
			comeOutRoll = true
		} else if rollResult == .Loss {
			comeOutRoll = true
		} else if rollResult == .Point {
			comeOutRoll = false
		} else if rollResult == .Push {
			comeOutRoll = false
		}
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

	func getPointBet() -> Bet {
		var theBet = Bet()

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
}

