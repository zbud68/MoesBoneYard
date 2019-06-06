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
		if !theBet.chipsWagered.isEmpty {
			let chipValue = theBet.chipsWagered.first!.value
		}
		return theBet
	}
}

