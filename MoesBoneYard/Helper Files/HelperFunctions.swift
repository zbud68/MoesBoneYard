//
//  HelperFunctions.swift
//  MoesBoneYard
//
//  Created by Mark Davis on 6/11/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

extension GameScene {
	func animateDice(isComplete: (Bool) -> Void) {
		let rollDie1 = SKAction(named: "RollDie1")!
		let rollDie2 = SKAction(named: "RollDie2")!
		let wait = SKAction.wait(forDuration: 0.15)

		let diceRoll1 = SKAction.run {
			self.die1.run(rollDie1)
		}

		let diceRoll2 = SKAction.run {
			self.die2.run(rollDie2)
		}

		let setFace = SKAction.run {
			self.die1.texture = self.die1.currentTexture
			self.die2.texture = self.die2.currentTexture
		}

		let dieRollSeq = SKAction.sequence([diceRoll1, wait, diceRoll2])
		let setDieFace = SKAction.sequence([setFace])

		let seq = SKAction.sequence([dieRollSeq, setDieFace])
		run(seq)
		isComplete(true)
	}

	func getTexture(name: String) -> SKTexture {
		let chipName = name
		for chip in chips where chip.name == chipName {
			selectedChipTexture = chip.texture!
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
	
	func noValidBetsPlaced() {
		print("No Valid Bets Placed for Come Out Roll. Valid Bets for Come Out Roll are 'PassLineBet or DontPassBet")
	}

	func displayBets() {
		for placedBet in placedBets {
			for chip in placedBet.chipsWagered {
				print("\(placedBet.name!) Chips Wagered: \(chip.name!)")
			}
		}
	}

	func validatePlacedBet(bet: TableBet) -> Bool {
		var result = Bool()
		if comeOutRoll {
			if bet != comeBet && bet != dontComeBet {
				result = true
			} else {
				result = false
			}
		} else {
			result = true
		}
		return result
	}

	func moveChipToBetLocation(bet: TableBet, chip: Chip) {
		let currentBet = bet
		let currentChip = chip
		var newPosition = CGPoint()

		switch dieTotal {
		case 4:
			newPosition = fours.placedBetPosition
		case 5:
			newPosition = fives.placedBetPosition
		case 6:
			newPosition = sixes.placedBetPosition
		case 8:
			newPosition = eights.placedBetPosition
		case 9:
			newPosition = nines.placedBetPosition
		case 10:
			newPosition = tens.placedBetPosition
		default:
			break
		}

		newPosition = CGPoint(x: newPosition.x + 0.25, y: newPosition.y + 1)
		let placedChip = SKSpriteNode(texture: currentChip.texture, size: CGSize(width: 24, height: 24))
		placedChip.position = newPosition
		placedChip.name = currentChip.name
		currentBet.placedBetPosition = newPosition
		currentBet.addChild(placedChip)
		placedChip.zPosition = currentBet.zPosition
		currentBet.zPosition += 1
		currentBet.betState = .On
	}

	func calcCurrentRollResults() {
		currentRollResults = (currentChipTotal - previousChipTotal)
		previousChipTotal = currentChipTotal
	}

	func wasEasterEggFound() {
		easterEggFound = false
		var foundEggs: [EasterEgg] = []
		for egg in easterEggs {
			let currentEgg = egg
			if currentEgg.status == .On {
				foundEggs.append(currentEgg)
			}
		}
		if foundEggs.count == 5 {
			easterEggFound = true
		}
	}

	func removeEasterEggs() {
		print("CONGRATS!!! You found uncovered a secret stash of chips\nHeres 1 Million Chips, Enjoy!")
		for egg in easterEggs {
			egg.status = .Off
		}
		easterEggs.removeAll()
		easterEggFound = false
		chipTotal += 1000000
	}

	func setBetType() -> BetType {
		var betType: BetType! = .Pass
		if passLineBet.chipsWagered.count > 0 || comeBet.chipsWagered.count > 0 {
			betType = .Pass
		} else if dontPassBet.chipsWagered.count > 0 || dontComeBet.chipsWagered.count > 0 {
			betType = .DontPass
		}
		return betType
	}
}
