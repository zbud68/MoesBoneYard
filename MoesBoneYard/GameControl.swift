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

	func getPointBet() -> Bet {
		var theBet = Bet()
		switch dieTotal {
		case 4:
			theBet = fours
			//theCurrentPointBet = [fours:4]
		case 5:
			theBet = fives
			//theCurrentPointBet = [fives:5]
		case 6:
			theBet = sixes
			//theCurrentPointBet = [sixes:6]
		case 8:
			theBet = eights
			//theCurrentPointBet = [eights:8]
		case 9:
			theBet = nines
			//theCurrentPointBet = [nines:9]
		case 10:
			theBet = tens
			//theCurrentPointBet = [tens:10]
		default:
			break
		}
		return theBet
	}
}

