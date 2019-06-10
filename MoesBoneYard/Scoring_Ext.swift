//
//  Scoring_Ext.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/19/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

extension GameScene {
	func rollDice(dice: [Dice]) {
		dieTotal = 0
		dieValues.removeAll()
		let currentDice = dice
		animateDice(isComplete: handlerBlock)
		for die in currentDice {
			die.value = Int(arc4random_uniform(6)+1)
			dieValues.append(die.value)
			for value in dieValues {
				switch value {
				case 1:
					die.texture = SKTexture(imageNamed: "Die1")
					die.currentTexture = die.texture!
				case 2:
					die.texture = SKTexture(imageNamed: "Die2")
					die.currentTexture = die.texture!
				case 3:
					die.texture = SKTexture(imageNamed: "Die3")
					die.currentTexture = die.texture!
				case 4:
					die.texture = SKTexture(imageNamed: "Die4")
					die.currentTexture = die.texture!
				case 5:
					die.texture = SKTexture(imageNamed: "Die5")
					die.currentTexture = die.texture!
				case 6:
					die.texture = SKTexture(imageNamed: "Die6")
					die.currentTexture = die.texture!
				default:
					break
				}
			}
		}
		dieTotal = die1.value + die2.value
		evaluateRoll()
	}

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
		self.run(seq)
		isComplete(true)
	}

	func evaluateRoll() {
		if comeOutRoll {
			comeOutRoll = false
			evaluateComeOutRoll()
		} else {
			if dieTotal == thePoint {
				thePointBet = getPointBet()
				handleWinningPointRoll()
			} else if !comeBet.children.isEmpty {
				switch dieTotal {
				case 4,5,6,8,9,10:
					let theBet = getCurrentPointBet()
					moveChipToBetLocation(bet: theBet, chip: selectedChip)
					removeBet(betName: comeBet.name!)
					comeBet.removeAllChildren()
				default:
					break
				}
			}
			evaluatePointRoll()
		}
	}

	func evaluateComeOutRoll() {
		var currentBet: [Bet:Chip]!
		var theBet: Bet!
		var theChip: Chip!

		for placedBet in placedBets {
			currentBet = placedBet
			for (bet,chip) in currentBet {
				theBet = bet
				theChip = chip
				if dieTotal == 7 || dieTotal == 11 {
					if !passLineBet.chipsWagered.isEmpty {
						chipTotal += theChip.value
						processBet(bet: passLineBet)
						comeOutRoll = true
					} else if !dontPassBet.chipsWagered.isEmpty {
						removeBet(betName: dontPassBet.name!)
						currentBet[dontPassBet] = nil
						dontPassBet.chipsWagered.removeAll()
					}
				} else if dieTotal == 2 || dieTotal == 3 || dieTotal == 12 {
					if !passLineBet.chipsWagered.isEmpty {
						removeBet(betName: passLineBet.name!)
						currentBet[passLineBet] = nil
						passLineBet.chipsWagered.removeAll()
						comeOutRoll = true
					} else if !dontPassBet.chipsWagered.isEmpty {
						chipTotal += theChip.value
						processBet(bet: dontPassBet)
						comeOutRoll = true
					}
				} else if points.contains(dieTotal) {
					thePoint = dieTotal
					puckState = .On
				}
				switch theBet {
				case snakeEyesBet:
					if dieTotal == 2 {
						processBet(bet: snakeEyesBet)
					} else {
						removeBet(betName: theBet.name!)
					}
					fallthrough
				case craps3Bet:
					if dieTotal == 3 {
						processBet(bet: craps3Bet)
					} else {
						removeBet(betName: theBet.name!)
					}
					fallthrough
				case fieldBet:
					chipTotal += theChip.value
					if dieTotal == 2 || dieTotal == 12 {
						chipTotal += Int(Double(theChip.value) * theBet.odds) * 2
					} else {
						processBet(bet: fieldBet)
					}
					currentBet[theBet] = nil
					fallthrough
				case hardSixBet, hardFourBet, hardTenBet, hardEightBet:
					handleHardWayBets()
					fallthrough
				case sevenBet:
					if dieTotal == 7 {
						processBet(bet: sevenBet)
					}
					fallthrough
				case boxCarsBet:
					if dieTotal == 12 {
						processBet(bet: boxCarsBet)
					}
					fallthrough
				case elevenBet:
					if dieTotal == 11 {
						processBet(bet: elevenBet)
					}
					fallthrough
				default:
					break
				}
			}
		}
	}

	func evaluatePointRoll() {
		var currentBet: [Bet:Chip]!
		var theBet: Bet!
		var theChip: Chip!
		if dieTotal == 7 {
			removePointsBets()
			/*for pointBet in pointsBets {
				currentBet = pointBet
				for (bet,_) in pointBet {
					theBet = bet
					//theChip = chip
					theBet.chipsWagered.removeAll()
					currentBet[theBet] = nil
					theBet.removeAllChildren()
					removeBet(betName: theBet.name!)
				}
			}*/
			comeOutRoll = true
			removeBet(betName: passLineBet.name!)
			passLineBet.chipsWagered.removeAll()
			passLineBet.removeAllChildren()
			puckState = .Off
		} else if points.contains(dieTotal){
			handlePointRollBets()
		} else {
			for placedBet in placedBets {
				currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					switch theBet {
					case comeBet:
						if craps.contains(dieTotal) {
							removeBet(betName: theBet.name!)
						} else if wins.contains(dieTotal) {
							chipTotal += theChip.value
							processBet(bet: theBet)
						} else if points.contains(dieTotal) {
							switch thePoint {
							case 4:
								if !fours.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: fours)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: fours, chip: chip)
									}
								}
							case 5:
								if !fives.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: fives)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: fives, chip: chip)
									}
								}
							case 6:
								if !sixes.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: sixes)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: sixes, chip: chip)
									}
								}
							case 8:
								if !eights.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: eights)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: eights, chip: chip)
									}
								}
							case 9:
								if !nines.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: nines)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: nines, chip: chip)
									}
								}
							case 10:
								if !tens.chipsWagered.isEmpty {
									chipTotal += theChip.value
									processBet(bet: tens)
								}
								if !comeBet.chipsWagered.isEmpty {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: tens, chip: chip)
									}
								}
							default:
								break
							}
						}
					case anyCrapsBet:
						if craps.contains(dieTotal) {
							chipTotal += theChip.value
							processBet(bet: anyCrapsBet)
						} else {
							removeBet(betName: theBet.name!)
						}
					case snakeEyesBet:
						if dieTotal == 2 {
							chipTotal += theChip.value
							processBet(bet: snakeEyesBet)
						} else {
							removeBet(betName: theBet.name!)
						}
					case craps3Bet:
						if dieTotal == 3 {
							chipTotal += theChip.value
							processBet(bet: craps3Bet)
						} else {
							removeBet(betName: theBet.name!)
						}
					case fieldBet:
						if dieTotal == 2 || dieTotal == 12 {
							chipTotal += theChip.value
							chipTotal += Int(Double(theChip.value) * theBet.odds) * 2
							removeBet(betName: theBet.name!)
						} else {
							chipTotal += theChip.value
							processBet(bet: fieldBet)
						}
						currentBet[theBet] = nil
					case hardSixBet, hardFourBet, hardTenBet, hardEightBet:
						handleHardWayBets()
					case sevenBet:
						if dieTotal == 7 {
							chipTotal += theChip.value
							processBet(bet: sevenBet)
						}
						removeBet(betName: theBet.name!)
					case boxCarsBet:
						if dieTotal == 12 {
							chipTotal += theChip.value
							processBet(bet: boxCarsBet)
						}
						removeBet(betName: theBet.name!)
					case elevenBet:
						if dieTotal == 11 {
							chipTotal += theChip.value
							processBet(bet: elevenBet)
						}
						removeBet(betName: theBet.name!)
					default:
						break
					}
				}
			}
		}
	}

	func clearBetsButtonTouched() {
		var currentBet: [Bet:Chip]!
		var theBet: Bet!
		var theChip: Chip!
		for placedBet in placedBets {
			currentBet = placedBet
			for (bet,chip) in currentBet {
				theBet = bet
				theChip = chip
				currentBet[theBet] = nil
				chipTotal += theChip.value
				placedBets.removeAll()
			}
		}
		for bet in availableBets {
			theBet = bet
			removeBet(betName: theBet.name!)
			theBet.chipsWagered.removeAll()
		}
		resetPlacedBetPositions()
	}

	func removeBet(betName: String) {
		var currentBet: [Bet:Chip]!
		var theBet: Bet!
		for bet in availableBets where bet.name == betName {
			bet.removeAllChildren()
			for placedBet in placedBets {
				currentBet = placedBet
				var id = 0
				for (bet, _) in currentBet where bet.name == betName {
					theBet = bet
					theBet.chipsWagered.removeAll()
					currentBet[theBet] = nil
					placedBets.remove(at: id)
				}
				id += 1
			}
		}
	}

	func removePointsBets() {
		var currentBet: [Bet:Chip]!
		var theBet: Bet!
		for pointBet in pointsBets {
			currentBet = pointBet
			for (bet,_) in currentBet {
				theBet = bet
				removeBet(betName: theBet.name!)
			}
		}
	}

	func placeBet(bet: [Bet:Chip]) {
		let currentBet = bet
		var theBet = Bet()
		var theChip = Chip()

		let validBet = validatePlacedBet(bet: currentBet)
		for (bet, chip) in currentBet {
			theBet = bet
			theChip = chip
		}

		if validBet {
			chipTotal -= theChip.value
			for bet in availableBets where bet.name == theBet.name {
				selectedBet = bet
				print("Selected Bet: \((selectedBet.name)!)")
				print("Selected Chip: \(theChip.value)")
				selectedBet.chipsWagered.append(theChip)
			}
			placedBets.append(currentBet)
			moveChipToBetLocation(bet: theBet, chip: theChip)
		} else {
			print("invalid bet")
		}
	}

	func validatePlacedBet(bet: [Bet:Chip]) -> Bool {
		let currentBet = bet
		var theBet = Bet()

		for (bet, _) in currentBet {
			theBet = bet
		}

		var result = Bool()
		if !comeOutRoll {
			if theBet.name == "PassLineBet" || theBet.name == "DontPassBet" {
				result = false
			} else {
				result = true
			}
		} else if theBet.name == "ComeBet" || theBet.name == "DontComeBet" {
			result = false
		} else {
			result = true
		}
		return result
	}

	func getDieTotal() -> Int {
		var result: Int = 0
		for value in dieValues {
			result += value
		}
		return result
	}

	func chipTouched(name: String) {
		let chipName = name
		for chip in chips where chip.name == chipName {
			selectedChip = chip
			selectedChipValue = selectedChip.value
			selectedChipTexture = selectedChip.texture!
			print("Selected Chip: \(selectedChip.value)")
		}
	}

	func moveChipToBetLocation(bet:
		Bet, chip: Chip) {

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
		let placedBet = SKSpriteNode(texture: currentChip.texture, size: CGSize(width: 24, height: 24))
		placedBet.position = newPosition
		placedBet.name = currentBet.name
		currentBet.placedBetPosition = newPosition
		currentBet.addChild(placedBet)
		placedBet.zPosition = currentBet.zPosition
		currentBet.zPosition += 1

		print("dieTotal: \(dieTotal), currentBet: \(currentBet.name!), currentChip: \(currentChip.name!)")
	}

	func resetPlacedBetPositions() {
		for bet in availableBets {
			bet.placedBetPosition = CGPoint(x: 0, y: 0)
		}
	}

	func placeGamePuck() {
		if comeOutRoll == true {
			gamePuck.texture = SKTexture(imageNamed: "OffPuck")
			gamePuck.position = gamePuck.homePosition
		} else {
			gamePuck.texture = SKTexture(imageNamed: "OnPuck")
			switch dieTotal {
			case 4:
				gamePuck.position = fours.puckPosition
			case 5:
				gamePuck.position = fives.puckPosition
			case 6:
				gamePuck.position = sixes.puckPosition
			case 8:
				gamePuck.position = eights.puckPosition
			case 9:
				gamePuck.position = nines.puckPosition
			case 10:
				gamePuck.position = tens.puckPosition
			default:
				break
			}
		}
	}

	func handleWinningPointRoll() {
		print("Winner you matched the Point: \(thePoint)")
		switch thePoint {
		case 4:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fours, chip: chip)
				}
			}
		case 5:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fives, chip: chip)
				}
			}
		case 6:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: sixes, chip: chip)
				}
			}
		case 8:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: eights, chip: chip)
				}
			}
		case 9:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: nines, chip: chip)
				}
			}
		case 10:
			for chip in passLineBet.chipsWagered {
				print("chip wagered: \(chip.name!)")
				chipTotal += chip.value
				processBet(bet: passLineBet)
			}
			if !comeBet.chipsWagered.isEmpty {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: tens, chip: chip)
				}
			}
		default:
			break
		}
		if !comeBet.chipsWagered.isEmpty {
			removeBet(betName: comeBet.name!)
		}
		comeOutRoll = true
		puckState = .Off
	}

	func handleSingleRollBets() {
		for bet in singleRollBets {
			processBet(bet: bet)
		}
	}

	func handleCrapsRollBets() {
		for bet in crapsRollBets {
			processBet(bet: bet)
		}
	}

	func handleHardWayBets() {
		for _ in hardWayBets {
			if die1.value == die2.value {
				switch dieTotal {
				case 4:
					processBet(bet: hardFourBet)
				case 6:
					processBet(bet: hardSixBet)
				case 8:
					processBet(bet: hardEightBet)
				case 10:
					processBet(bet: hardTenBet)
				default:
					break
				}
			}
		}
	}

	func handlePointRollBets() {
		//var currentBet: [Bet:Chip]!
		var theBet: Bet!
		var theChip: Chip!
		for pointBet in pointsBets {
			//currentBet = pointBet
			for (bet,chip) in pointBet {
				theBet = bet
				theChip = chip
				if !comeBet.chipsWagered.isEmpty {
					moveChipToBetLocation(bet: comeBet, chip: theChip)
					removeBet(betName: comeBet.name!)
				}
				if theBet == thePointBet {
					chipTotal += theChip.value
					processBet(bet: theBet)
					removeBet(betName: theBet.name!)
				}
			}
		}
	}

	func getCurrentPointBet() -> Bet {
		var theBet: Bet!
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

	func processBet(bet: Bet) {
		currentChipTotal = chipTotal
		let theBet = bet
		if !theBet.children.isEmpty {
			for chip in theBet.chipsWagered {
				chipTotal += Int(Double(chip.value) * theBet.odds)
				calculateTotalAmountWonOrLost()
				removeBet(betName: theBet.name!)
				theBet.chipsWagered.removeAll()
			}
		}
	}

	func calculateTotalAmountWonOrLost() {
		totalAmountWonOrLost = (currentChipTotal - previousChipTotal)
		previousChipTotal = currentChipTotal
	}
}
