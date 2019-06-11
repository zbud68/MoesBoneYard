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
		print("Dice Total: \(dieTotal)")
		for bet in availableBets where bet.chipsWagered.count > 0 {
			print("current bet: \(bet.name!)")
			for chip in bet.chipsWagered {
				print("chips wagered: \(chip.value)")
			}
		}
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
			print("Come Out Roll")
			comeOutRoll = false
			evaluateComeOutRoll()
		} else {
			print("Point Roll")
			if dieTotal == thePoint {
				print("Point Matched")
				thePointBet = getPointBet()
				handleWinningPointRoll()
				thePoint = 0
			}
			print("comebetchipswageredcount: \(comeBet.chipsWagered.count)")
			if comeBet.chipsWagered.count > 0 {
				switch dieTotal {
				case 7,11:
					processBet(bet: comeBet)
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
		var currentBet: TableBet!
		var theChip: Chip!
		for placedBet in placedBets {
			currentBet = placedBet
			for chip in currentBet.chipsWagered {
				theChip = chip
				if dieTotal == 7 || dieTotal == 11 {
					if passLineBet.chipsWagered.count > 0 {
						processBet(bet: currentBet)
						comeOutRoll = true
					} else if dontPassBet.chipsWagered.count > 0 {
						removeBet(betName: currentBet.name!)
					}
				} else if dieTotal == 2 || dieTotal == 3 || dieTotal == 12 {
					if passLineBet.chipsWagered.count > 0 {
						removeBet(betName: currentBet.name!)
						comeOutRoll = true
					} else if dontPassBet.chipsWagered.count > 0 {
						processBet(bet: currentBet)
						comeOutRoll = true
					}
				} else if points.contains(dieTotal) {
					thePoint = dieTotal
					currentPoint = thePoint
					puckState = .On
				}
				switch currentBet {
				case snakeEyesBet:
					if dieTotal == 2 {
						processBet(bet: currentBet)
					} else {
						removeBet(betName: currentBet.name!)
					}
					fallthrough
				case craps3Bet:
					if dieTotal == 3 {
						processBet(bet: currentBet)
					} else {
						removeBet(betName: currentBet.name!)
					}
					fallthrough
				case fieldBet:
					chipTotal += theChip.value
					if dieTotal == 2 || dieTotal == 12 {
						chipTotal += Int(Double(theChip.value) * currentBet.odds) * 2
					} else {
						processBet(bet: currentBet)
					}
					fallthrough
				case hardSixBet, hardFourBet, hardTenBet, hardEightBet:
					handleHardWayBets()
					fallthrough
				case sevenBet:
					if dieTotal == 7 {
						processBet(bet: currentBet)
					}
					fallthrough
				case boxCarsBet:
					if dieTotal == 12 {
						processBet(bet: currentBet)
					}
					fallthrough
				case elevenBet:
					if dieTotal == 11 {
						processBet(bet: currentBet)
					}
				default:
					break
				}
			}
		}
	}

	func evaluatePointRoll() {
		var currentBet: TableBet!
		var theChip: Chip!
		for placedBet in placedBets {
			for chip in placedBet.chipsWagered {
				theChip = chip
			}
		}
		if dieTotal == 7 {
			if dontPassBet.chipsWagered.count > 0 {
				processBet(bet: dontPassBet)
				removeBet(betName: dontPassBet.name!)
			} else if passLineBet.chipsWagered.count > 0 {
				removeBet(betName: passLineBet.name!)
			}
			removePointsBets()
			comeOutRoll = true
			puckState = .Off
		} else if points.contains(dieTotal){
			handlePointRollBets()
		} else {
			for placedBet in placedBets {
				currentBet = placedBet
				for chip in currentBet.chipsWagered {
					theChip = chip
					switch currentBet {
					case comeBet:
						if craps.contains(dieTotal) {
							removeBet(betName: currentBet.name!)
						} else if wins.contains(dieTotal) {
							processBet(bet: currentBet)
						} else if points.contains(dieTotal) {
							switch thePoint {
							case 4:
								if fours.chipsWagered.count > 0 {
									processBet(bet: fours)
								}
								if comeBet.chipsWagered.count > 0 {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: fours, chip: chip)
									}
								}
							case 5:
								if fives.chipsWagered.count > 0 {
									processBet(bet: fives)
								}
								if comeBet.chipsWagered.count > 0 {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: fives, chip: chip)
									}
								}
							case 6:
								if sixes.chipsWagered.count > 0 {
									processBet(bet: sixes)
								}
								if comeBet.chipsWagered.count > 0 {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: sixes, chip: chip)
									}
								}
							case 8:
								if eights.chipsWagered.count > 0 {
									processBet(bet: eights)
								}
								if comeBet.chipsWagered.count > 0 {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: eights, chip: chip)
									}
								}
							case 9:
								if nines.chipsWagered.count > 0 {
									processBet(bet: nines)
								}
								if comeBet.chipsWagered.count > 0 {
									for chip in comeBet.chipsWagered {
										moveChipToBetLocation(bet: nines, chip: chip)
									}
								}
							case 10:
								if tens.chipsWagered.count > 0 {
									processBet(bet: tens)
								}
								if comeBet.chipsWagered.count > 0 {
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
							processBet(bet: anyCrapsBet)
						} else {
							removeBet(betName: currentBet.name!)
						}
					case snakeEyesBet:
						if dieTotal == 2 {
							processBet(bet: snakeEyesBet)
						} else {
							removeBet(betName: currentBet.name!)
						}
					case craps3Bet:
						if dieTotal == 3 {
							processBet(bet: craps3Bet)
						} else {
							removeBet(betName: currentBet.name!)
						}
					case fieldBet:
						if dieTotal == 2 || dieTotal == 12 {
							chipTotal += theChip.value
							chipTotal += Int(Double(theChip.value) * currentBet.odds) * 2
							removeBet(betName: currentBet.name!)
							if let idx = placedBets.firstIndex(where: { $0.name == currentBet.name! }) {
								placedBets.remove(at: idx)
							}
							currentBet.chipsWagered.removeAll()
						} else {
							processBet(bet: fieldBet)
						}
					case hardSixBet, hardFourBet, hardTenBet, hardEightBet:
						handleHardWayBets()
					case sevenBet:
						if dieTotal == 7 {
							processBet(bet: sevenBet)
						}
						removeBet(betName: currentBet.name!)
					case boxCarsBet:
						if dieTotal == 12 {
							processBet(bet: boxCarsBet)
						}
						removeBet(betName: currentBet.name!)
					case elevenBet:
						if dieTotal == 11 {
							processBet(bet: elevenBet)
						}
						removeBet(betName: currentBet.name!)
					default:
						break
					}
				}
			}
		}
	}

	func clearBetsButtonTouched() {
		for placedBet in placedBets {
			for chip in placedBet.chipsWagered {
				chipTotal += chip.value
			}
		}
		placedBets.removeAll()
		resetPlacedBetPositions()
	}

	func removeBet(betName: String) {
		for bet in placedBets where bet.name == betName {
			bet.removeAllChildren()
			bet.chipsWagered.removeAll()
		}
		if let idx = placedBets.firstIndex(where: { $0.name == betName }) {
			placedBets.remove(at: idx)
		}
	}

	func removePointsBets() {
		print("removing point bets")
		fours.removeAllChildren()
		fours.chipsWagered.removeAll()
		fives.removeAllChildren()
		fives.chipsWagered.removeAll()
		sixes.removeAllChildren()
		sixes.chipsWagered.removeAll()
		eights.removeAllChildren()
		eights.chipsWagered.removeAll()
		nines.removeAllChildren()
		nines.chipsWagered.removeAll()
		tens.removeAllChildren()
		tens.chipsWagered.removeAll()
		foursBuyBet.removeAllChildren()
		foursBuyBet.chipsWagered.removeAll()
		fivesBuyBet.removeAllChildren()
		fivesBuyBet.chipsWagered.removeAll()
		sixesBuyBet.removeAllChildren()
		sixesBuyBet.chipsWagered.removeAll()
		eightsBuyBet.removeAllChildren()
		eightsBuyBet.chipsWagered.removeAll()
		ninesBuyBet.removeAllChildren()
		ninesBuyBet.chipsWagered.removeAll()
		tensBuyBet.removeAllChildren()
		tensBuyBet.chipsWagered.removeAll()
	}

	func placeBet(bet: TableBet) {
		let currentBet = bet
		let validBet = validatePlacedBet(bet: currentBet)
		var theChip = selectedChip
		if validBet {
			currentBet.betState = .On
			currentBet.chipsWagered.append(theChip)
			for chip in currentBet.chipsWagered {
				theChip = chip
				chipTotal -= theChip.value
				totalBetThisRoll += theChip.value
				for bet in availableBets where bet.name == currentBet.name {
					selectedBet = bet
				}
				placedBets.append(currentBet)
				moveChipToBetLocation(bet: currentBet, chip: theChip)
			}
		} else {
			print("invalid bet")
		}
	}

	func validatePlacedBet(bet: TableBet) -> Bool {
		var result = Bool()
		if comeOutRoll == false {
			if bet.name == "PassLineBet" || bet.name == "DontPassBet" {
				result = false
			} else {
				result = true
			}
		} else if bet.name == "ComeBet" || bet.name == "DontComeBet" {
			result = false
		} else {
			result = true
		}
		return result
	}

	func chipTouched(name: String) {
		for chip in chips where chip.name == name {
			selectedChip = chip
			selectedChipValue = selectedChip.value
			selectedChipTexture = selectedChip.texture!
		}
	}

	func moveChipToBetLocation(bet: TableBet, chip: Chip) {
		let currentBet = bet
		let currentChip = chip
		var newPosition = CGPoint()

		switch dieTotal {
		case 4:
			fours.betState = .On
			newPosition = fours.placedBetPosition
			fours.chipsWagered.append(currentChip)
		case 5:
			fives.betState = .On
			newPosition = fives.placedBetPosition
			fives.chipsWagered.append(currentChip)
		case 6:
			sixes.betState = .On
			newPosition = sixes.placedBetPosition
			sixes.chipsWagered.append(currentChip)
		case 8:
			eights.betState = .On
			newPosition = eights.placedBetPosition
			eights.chipsWagered.append(currentChip)
		case 9:
			nines.betState = .On
			newPosition = nines.placedBetPosition
			nines.chipsWagered.append(currentChip)
		case 10:
			tens.betState = .On
			newPosition = tens.placedBetPosition
			tens.chipsWagered.append(currentChip)
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
		currentBet.betState = .On
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
		thePointBet = getPointBet()
		switch thePoint {
		case 4:
			if passLineBet.chipsWagered.count > 0 {
				fours.chipsWagered = passLineBet.chipsWagered
				placedBets.append(fours)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fours, chip: chip)
					fours.chipsWagered.append(chip)
				}
			}
			processBet(bet: fours)
			print("\(fours.name!) bet wins")
		case 5:
			if passLineBet.chipsWagered.count > 0 {
				fives.chipsWagered = passLineBet.chipsWagered
				placedBets.append(fives)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fives, chip: chip)
					fives.chipsWagered.append(chip)
				}
			}
			processBet(bet: fives)
			print("\(fives.name!) bet wins")
		case 6:
			if passLineBet.chipsWagered.count > 0 {
				sixes.chipsWagered = passLineBet.chipsWagered
				placedBets.append(sixes)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: sixes, chip: chip)
					sixes.chipsWagered.append(chip)
				}
			}
			processBet(bet: sixes)
			print("\(sixes.name!) bet wins")
		case 8:
			if passLineBet.chipsWagered.count > 0 {
				eights.chipsWagered += passLineBet.chipsWagered
				placedBets.append(eights)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: eights, chip: chip)
					eights.chipsWagered.append(chip)
				}
			}
			processBet(bet: eights)
			print("\(eights.name!) bet wins")
		case 9:
			if passLineBet.chipsWagered.count > 0 {
				nines.chipsWagered += passLineBet.chipsWagered
				placedBets.append(nines)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: nines, chip: chip)
					nines.chipsWagered.append(chip)
				}
			}
			processBet(bet: nines)
			print("\(nines.name!) bet wins")
		case 10:
			if passLineBet.chipsWagered.count > 0 {
				tens.chipsWagered += passLineBet.chipsWagered
				placedBets.append(tens)
			}
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: tens, chip: chip)
					tens.chipsWagered.append(chip)
				}
			}
			processBet(bet: tens)
			print("\(tens.name!) bet wins")
		default:
			break
		}
		if comeBet.chipsWagered.count > 0 {
			moveChipToBetLocation(bet: thePointBet, chip: comeBet.chipsWagered.first!)
			removeBet(betName: comeBet.name!)
		}
		thePointBet.chipsWagered.removeAll()
		passLineBet.removeAllChildren()
		passLineBet.chipsWagered.removeAll()
		comeBet.removeAllChildren()
		comeBet.chipsWagered.removeAll()
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

	func handlePointRollBets() {
		for pointBet in pointsBets {
			print("point bet chips count: \(pointBet.chipsWagered.count)")
			if pointBet.chipsWagered.count > 0 {
				processBet(bet: pointBet)
			}
		}
		for pointBet in pointsBets {
			for chip in pointBet.chipsWagered {
				if comeBet.chipsWagered.count > 0 {
					moveChipToBetLocation(bet: comeBet, chip: chip)
					removeBet(betName: comeBet.name!)
				}
			}
		}
	}

	func getCurrentPointBet() -> TableBet {
		var theBet: TableBet!
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

	func processBet(bet: TableBet) {
		print("bet Name: \(bet.name!), bet.chipsWagered count: \(bet.chipsWagered.count)")
		if bet.chipsWagered.count > 0 {
			for chip in bet.chipsWagered {
				print("chip: \(chip.name!)")
				chipTotal += chip.value
				chipTotal += Int(Double(chip.value) * bet.odds)
			}
			removeBet(betName: bet.name!)
			bet.removeAllChildren()
			bet.chipsWagered.removeAll()
			if let idx = placedBets.firstIndex(where: { $0.name == bet.name! }) {
				placedBets.remove(at: idx)
			}
		}
	}

	func calcCurrentRollResults() {
		currentRollResults = (currentChipTotal - previousChipTotal)
		previousChipTotal = currentChipTotal
	}
}
