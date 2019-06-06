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
			dieValues.append(Double(die.value))
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
		let dieTotal = getDieTotal()
		self.dieTotal = Int(dieTotal)
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
			evaluatePointRoll()
		}

	}
/*
	func processComeOutRollBets() {
		for placedBet in placedBets {
			var currentPlacedBet = placedBet
			for (bet,chip) in placedBet {
				let currentBet = bet
				let currentChip = chip
				switch currentBet {
				case passLineBet, comeBet:
					if craps.contains(Double(dieTotal)) {
						currentPlacedBet[currentBet] = nil
						removeBet(betName: currentBet.name!)
					}
				case dontPassBet, dontComeBet, anyCrapsBet:
					if craps.contains(Double(dieTotal)) {
						currentPlacedBet[currentBet] = nil
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
						removeBet(betName: currentBet.name!)
					}
				case snakeEyesBet:
					if die1.value == 1 && die2.value == 1 {
						currentPlacedBet[currentBet] = nil
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
						removeBet(betName: currentBet.name!)
					}
				case craps3Bet:
					if (die1.value == 1 || die1.value == 2) && (die2.value == 1 || die2.value == 2) {
						currentPlacedBet[currentBet] = nil
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
						removeBet(betName: currentBet.name!)
					}
				case fieldBet:
					currentPlacedBet[currentBet] = nil
					chipTotal += currentChip.value
					if dieTotal == 2 || dieTotal == 12 {
						chipTotal += (currentChip.value * currentBet.odds) * 2
					} else {
						chipTotal += (currentChip.value * currentBet.odds)
					}
				case fours, fives, sixes, eights, nines, tens, hardSixBet, hardFourBet, hardTenBet, hardEightBet:
					if die1.value == 2 && die2.value == 2 {
						currentPlacedBet[currentBet] = nil
						placedBets.append([currentBet:currentChip])
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
						fallthrough
					} else if die1.value == 3 && die2.value == 3 {
						currentPlacedBet[currentBet] = nil
						placedBets.append([currentBet:currentChip])
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
						fallthrough
					} else if die1.value == 4 && die2.value == 4 {
						currentPlacedBet[currentBet] = nil
						placedBets.append([currentBet:currentChip])
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
					} else if die1.value == 5 && die2.value == 5 {
						currentPlacedBet[currentBet] = nil
						placedBets.append([currentBet:currentChip])
						chipTotal += currentChip.value
						chipTotal += (currentChip.value * currentBet.odds)
					}
				default:
					break
				}
			}
		}
	}
*/

	func evaluateComeOutRoll() {
		for placedBet in placedBets {
			var currentBet = placedBet
			for (bet,chip) in currentBet {
				let theBet = bet
				let theChip = chip
				switch theBet {
				case passLineBet, comeBet:
					if craps.contains(Double(dieTotal)) {
						currentBet[theBet] = nil
						removeBet(betName: theBet.name!)
						comeOutRoll = true
					} else if wins.contains(Double(dieTotal)) {
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: theBet.name!)
						currentBet[theBet] = nil
						comeOutRoll = true
					} else if points.contains(Double(dieTotal)) {
						thePoint = dieTotal
						currentPointBet = getPointBet()
						currentBet[getPointBet()] = currentBet[passLineBet]
						pointBet = [currentPointBet:currentBet[getPointBet()]] as! [Bet : Chip]
						print("currentBetWager: \(currentBet[getPointBet()]!), passLineBetWager: \(currentBet[passLineBet]!)")
						currentBet[passLineBet] = nil
						placeGamePuck()
					}
				case dontPassBet, dontComeBet, anyCrapsBet:
					if craps.contains(Double(dieTotal)) {
						currentBet[theBet] = nil
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: theBet.name!)
					} else {
						removeBet(betName: theBet.name!)
					}
				case snakeEyesBet:
					if die1.value == 1 && die2.value == 1 {
						currentBet[theBet] = nil
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: theBet.name!)
					} else {
						removeBet(betName: theBet.name!)
					}
				case craps3Bet:
					if (die1.value == 1 || die1.value == 2) && (die2.value == 1 || die2.value == 2) {
						currentBet[theBet] = nil
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: theBet.name!)
					} else {
						removeBet(betName: theBet.name!)
					}
				case fieldBet:
					currentBet[theBet] = nil
					chipTotal += theChip.value
					if dieTotal == 2 || dieTotal == 12 {
						chipTotal += (theChip.value * theBet.odds) * 2
					} else {
						chipTotal += (theChip.value * theBet.odds)
					}
				case fours, fives, sixes, eights, nines, tens, hardSixBet, hardFourBet, hardTenBet, hardEightBet:
					if die1.value == 2 && die2.value == 2 {
						currentBet[theBet] = nil
						placedBets.append([theBet:theChip])
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						fallthrough
					} else if die1.value == 3 && die2.value == 3 {
						currentBet[theBet] = nil
						placedBets.append([theBet:theChip])
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						fallthrough
					} else if die1.value == 4 && die2.value == 4 {
						currentBet[theBet] = nil
						placedBets.append([theBet:theChip])
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
					} else if die1.value == 5 && die2.value == 5 {
						currentBet[theBet] = nil
						placedBets.append([theBet:theChip])
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
					}
				default:
					break
				}
			}
		}

	}

	func evaluatePointRoll() {
		//let pointBet = getPointBet()
		var theBet = Bet()
		var theChip = Chip()
		var pointBets = [Bet()]
		var pointBetChips = [Chip()]
		switch dieTotal {
		case thePoint:
			for (bet, chip) in pointBet {
				pointBets.append(bet)
				pointBetChips.append(chip)
			}
			print("Winner: Point Matched")
			gamePuck.texture = SKTexture(imageNamed: "OffPuck")
			gamePuck.position = gamePuck.homePosition
			for bet in pointBets {
				for chip in pointBetChips {
					chipTotal += Double(chip.value)
					chipTotal += (Double(chip.value) * bet.odds)
				}
			}
			passLineBet.removeAllChildren()
			comeOutRoll = true
			thePoint = 0
		case 2,3:
			for placedBet in placedBets {
				for (bet,chip) in placedBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						removeBet(betName: betName!)
					case "DontComeBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						moveChipToBetLocation(bet: theBet, chip: theChip)
						theBet.state = .On
						removeBet(betName: betName!)
					case "AnyCrapsBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
					case "SnakeEyesBet":
						if die1.value == 1 && die2.value == 1 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
						}
					case "Craps3Bet":
						if (die1.value == 1 || die1.value == 3) && (die2.value == 1 || die2.value == 3) {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
						}
					case "FieldBet":
						if dieTotal == 2 || dieTotal == 12 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds) * 2
							removeBet(betName: betName!)
						} else {
							switch dieTotal {
							case 3,4,9,10,11:
								chipTotal += theChip.value
								chipTotal += (theChip.value * theBet.odds)
								removeBet(betName: betName!)
							default:
								break
							}
						}
					default:
						break
					}
				}
			}

		case 4:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Fours":
						chipTotal += theChip.value
						chipTotal += (theChip.value * currentPointBet.odds)
						removeBet(betName: currentPointBet.name!)
						currentBet[currentPointBet] = nil
					case "HardFourBet":
						if die1.value == 2 && die2.value == 2 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
							currentBet[theBet] = nil
						}
					default:
						break
					}
				}
			}
		case 5:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						let children = currentPointBet.children
						if !children.isEmpty {
							for child in children {
								if child == fives {
									chipTotal += theChip.value
									chipTotal += (theChip.value * currentPointBet.odds)
									removeBet(betName: currentPointBet.name!)
								}
							}
						}
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Fives":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					default:
						break
					}
				}
			}
		case 6:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						let children = currentPointBet.children
						if !children.isEmpty {
							for child in children {
								if child == sixes {
									chipTotal += theChip.value
									chipTotal += (theChip.value * currentPointBet.odds)
									removeBet(betName: currentPointBet.name!)
								}
							}
						}
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Sixes":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "HardSixBet":
						if die1.value == 3 && die2.value == 3 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
							currentBet[theBet] = nil
						}
					default:
						break
					}
				}
			}
		case 8:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						let children = currentPointBet.children
						if !children.isEmpty {
							for child in children {
								if child == eights {
									chipTotal += theChip.value
									chipTotal += (theChip.value * currentPointBet.odds)
									removeBet(betName: currentPointBet.name!)
								}
							}
						}
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Eights":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "HardEightBet":
						if die1.value == 4 && die2.value == 4 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
							currentBet[theBet] = nil
						}
					default:
						break
					}
				}
			}
		case 9:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						let children = currentPointBet.children
						if !children.isEmpty {
							for child in children {
								if child == nines {
									chipTotal += theChip.value
									chipTotal += (theChip.value * currentPointBet.odds)
									removeBet(betName: currentPointBet.name!)
								}
							}
						}
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Nines":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					default:
						break
					}
				}
			}
		case 10:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						let children = currentPointBet.children
						if !children.isEmpty {
							for child in children {
								if child == tens {
									chipTotal += theChip.value
									chipTotal += (theChip.value * currentPointBet.odds)
									removeBet(betName: currentPointBet.name!)
								}
							}
						}
						moveChipToBetLocation(bet: theBet, chip: theChip)
						placedBets.append([theBet:theChip])
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "Tens":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "HardTenBet":
						if die1.value == 5 && die2.value == 5 {
							chipTotal += theChip.value
							chipTotal += (theChip.value * theBet.odds)
							removeBet(betName: betName!)
							currentBet[theBet] = nil
						}
					default:
						break
					}
				}
			}

		case 7:
			var currentBet = [Bet:Chip]()
			print("Craps 7")
			comeOutRoll = true
			for placedBet in placedBets {
				currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						moveChipToBetLocation(bet: theBet, chip: theChip)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "SevenBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					default:
						break
					}
				}
			}
			passLineBet.removeAllChildren()
			currentBet[passLineBet] = nil
			gamePuck.texture = SKTexture(imageNamed: "OffPuck")
			gamePuck.position = gamePuck.homePosition

		case 11:
			for placedBet in placedBets {
				var currentBet = placedBet
				for (bet,chip) in currentBet {
					theBet = bet
					theChip = chip
					let betName = theBet.name
					switch betName {
					case "ComeBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "DontComeBet":
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					case "ElevenBet":
						chipTotal += theChip.value
						chipTotal += (theChip.value * theBet.odds)
						removeBet(betName: betName!)
						currentBet[theBet] = nil
					default:
						break
					}
				}
			}

		default:
			break
		}

	}

	func clearBetsButtonTouched() {
		var theBet = Bet()
		var theChip = Chip()
		for placedBet in placedBets {
			for (bet, chip) in placedBet {
				theBet = bet
				theChip = chip
				removeBet(betName: theBet.name!)
			}
		}
		chipTotal += theChip.value
		placedBets.removeAll()
		resetPlacedBetPositions()
	}

	func removeBet(betName: String) {
		for bet in availableBets where bet.name == betName {
			bet.removeAllChildren()
			for bet in placedBets {
				var id = 0
				for (currentBet, _) in bet where currentBet.name == betName {
					placedBets.remove(at: id)
				}
				id += 1
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
		} else {
			if theBet.name == "PassLineBet" || theBet.name == "DontPassBet" {
				result = true
			}
		}
		return result
	}

	func getDieTotal() -> Double {
		var result: Double = 0
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
