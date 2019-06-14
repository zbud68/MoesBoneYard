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
	func rollButtonTouched() {
		if passLineBet.chipsWagered.count > 0 || dontPassBet.chipsWagered.count > 0 {
			rollDice(dice: currentDice)
		} else {
			print("You must place a bet on either 'PassLine' or 'Don't Pass' on the Come Out Roll.  Please place your bet to continue")
		}
	}

    func rollDice(dice: [Dice]) {
        dieTotal = 0
        let currentDice = dice
        animateDice(isComplete: handlerBlock)
        for die in currentDice {
            die.value = Int(arc4random_uniform(6) + 1)
			switch die.value {
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
        dieTotal = die1.value + die2.value
        evaluateRoll()
    }

    func evaluateRoll() {

		if comeOutRoll {
			evaluateComeOutRoll()
		} else {
			for bet in availableBets {
				bet.betState = .On
			}
			evaluatePointRoll()
		}
		displayBets()
	}

	func evaluateComeOutRoll() {
		if passLineBet.chipsWagered.count > 0 {
			currentBet = passLineBet
			passRoll = true
		} else if dontPassBet.chipsWagered.count > 0 {
			currentBet = dontPassBet
			passRoll = false
		}
		print("Dice Total: \(dieTotal)")
		if dieTotal == 7 || dieTotal == 11 {
			if passRoll {
				processBet(bet: passLineBet)
			} else {
				removeBet(betName: dontPassBet.name!)
			}
		} else if dieTotal == 2 || dieTotal == 3 || dieTotal == 12 {
			if passRoll {
				removeBet(betName: passLineBet.name!)
			} else if dieTotal != 12 {
				processBet(bet: dontPassBet)
			}
		} else if points.contains(dieTotal) {
			thePoint = dieTotal
			print("the point is: \(thePoint)")
			thePointBet = getPointBet()
			print("the point bet is: \(thePointBet.name!)")
			print("the point bet chips: \(thePointBet.chipsWagered.count)")
			puckState = .On
			for pointBet in pointsBets {
				pointBet.betState = .On
			}
		}
		handleSingleRollBets()
	}

    func evaluatePointRoll() {
		let pass: BetType? = BetType.Pass
		let dontPass: BetType? = BetType.DontPass
		handleSingleRollBets()

		switch dieTotal {
		case 2:
			processBet(bet: dontComeBet)
			if comeBet.chipsWagered.count > 0 {
				removeBet(betName: comeBet.name!)
			}
		case 3:
			processBet(bet: dontComeBet)
			if comeBet.chipsWagered.count > 0 {
				removeBet(betName: comeBet.name!)
			}
		case 4:
			processBet(bet: fours)
			print("comebet chipswagered count: \(comeBet.chipsWagered.count)")
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: fours, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: fours, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if die1.value == die2.value {
				processBet(bet: hardFourBet)
			}
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 5:
			processBet(bet: fives)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: fives, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: fives, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 6:
			processBet(bet: sixes)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: sixes, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: sixes, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if die1.value == die2.value {
				processBet(bet: hardSixBet)
			}
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 7:
			print("pointsbets count: \(pointsBets.count)")
			for pointBet in pointsBets {
				print("pointbet type: \(pointBet.betType), pointBet state: \(pointBet.betState)")
			}
			processBet(bet: comeBet)
			processBet(bet: dontPassBet)
			for pointBet in pointsBets where pointBet.betType == .DontPass {
				processBet(bet: pointBet)
			}
			if dontPassBet.chipsWagered.count > 0 {
				removeBet(betName: dontPassBet.name!)
			}
			if passLineBet.chipsWagered.count > 0 {
				removeBet(betName: passLineBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				removeBet(betName: dontComeBet.name!)
			}
			for pointBet in pointsBets where pointBet.betType == .Pass {
				removePointsBets(betType: pass!)
			}
			for bet in placedBets where hardWayBets.contains(bet) {
				removeBet(betName: bet.name!)
			}
			puckState = .Off
		case 8:
			processBet(bet: eights)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: eights, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: eights, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if die1.value == die2.value {
				processBet(bet: hardEightBet)
			}
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 9:
			processBet(bet: nines)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: nines, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: nines, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 10:
			processBet(bet: tens)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					chip.betType = .Pass
					placeBet(bet: tens, chip: chip)
					chipTotal += chip.value
				}
				removeBet(betName: comeBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				for chip in dontComeBet.chipsWagered {
					chip.betType = .DontPass
					placeBet(bet: tens, chip: chip)
					chipTotal += chip.value
				}
				dontComeBet.removeAllChildren()
			}
			if die1.value == die2.value {
				processBet(bet: hardTenBet)
			}
			processBet(bet: fieldBet)
			if dieTotal == thePoint {
				if dontPassBet.chipsWagered.count > 0 {
					removeBet(betName: dontPassBet.name!)
				}
				processBet(bet: passLineBet)
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					removePointsBets(betType: dontPass!)
				}
				puckState = .Off
			}
		case 11:
			processBet(bet: comeBet)
			if dontComeBet.chipsWagered.count > 0 {
				removeBet(betName: dontComeBet.name!)
			}
		/*
		case 12:
			if die1.value == die2.value {
				processBet(bet: fieldBet)
			}
		*/
		default:
			break
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
			if bet.chipsWagered.count > 0 {
            	bet.removeAllChildren()
            	bet.chipsWagered.removeAll()
			}
        }
        if let idx = placedBets.firstIndex(where: { $0.name == betName }) {
			print("\(placedBets[idx].name!) was removed")
            placedBets.remove(at: idx)
        }
    }

	func removePointsBets(betType: BetType) {
        print("removing point bets")
		for bet in placedBets {
			if bet.betType == betType && bet.betState == .On && pointsBets.contains(bet) {
				bet.removeAllChildren()
				bet.chipsWagered.removeAll()
			}
		}
   	}

	func placeBet(bet: TableBet, chip: Chip) {
        let currentBet = bet
        let validBet = validatePlacedBet(bet: currentBet)
        let theChip = chip
        if validBet {
			print("current bet: \(currentBet.name!)")
			print("the chip: \(theChip.name!)")
			currentBet.betType = setBetType()
            currentBet.betState = .On
            currentBet.chipsWagered.append(theChip)
            for chip in currentBet.chipsWagered {
				let currentChip = chip
                chipTotal -= currentChip.value
                totalBetThisRoll += currentChip.value
				totalChipsWonOrLost -= currentChip.value
            }
			moveChipToBetLocation(bet: currentBet, chip: theChip)
			placedBets.append(currentBet)
        } else {
            print("invalid bet")
        }
    }

	func processBet(bet: TableBet) {
		if bet.validBet {
			if bet.chipsWagered.count > 0 {
				for chip in bet.chipsWagered {
					chipTotal += chip.value
					chipTotal += Int(Double(chip.value) * bet.odds)
					totalChipsWonOrLost += chip.value
					totalChipsWonOrLost += Int(Double(chip.value) * bet.odds)
				}
			}
			removeBet(betName: bet.name!)
			bet.removeAllChildren()
			bet.chipsWagered.removeAll()
			if let idx = placedBets.firstIndex(where: { $0.name == bet.name! }) {
				placedBets.remove(at: idx)
			}
		}
	}

    func removePlacedBet(bet: TableBet) {
        for placedBet in placedBets where placedBet.contains(touchLocation!) {
            if let idx = placedBets.firstIndex(where: { $0 == placedBet }) {
                placedBets.remove(at: idx)
            }
            placedBet.chipsWagered.removeLast()
            var placedBetChildren = placedBet.children
            placedBetChildren.removeLast()
        }
    }

    func chipTouched(name: String) {
		let chipName = name
		for chip in chips where chip.name == chipName {
			selectedChip = chip
			selectedChipValue = chip.value
			selectedChipTexture = chip.texture!
		}
	}

    func placeGamePuck() {
        if comeOutRoll == true {
            gamePuck.texture = SKTexture(imageNamed: "OffPuck")
            gamePuck.position = gamePuck.homePosition
        } else {
            gamePuck.texture = SKTexture(imageNamed: "OnPuck")
            switch thePoint {
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

	func handlePointBets() {
		for bet in pointsBets where bet.chipsWagered.count > 0 {
			processBet(bet: bet)
		}
	}

    func handleSingleRollBets() {
        for _ in singleRollBets {
			switch dieTotal {
			case 2:
				processBet(bet: snakeEyesBet)
				processBet(bet: fieldBet)
				processBet(bet: anyCrapsBet)
			case 3:
				processBet(bet: craps3Bet)
				processBet(bet: fieldBet)
				processBet(bet: anyCrapsBet)
			case 4:
				processBet(bet: fieldBet)
			case 7:
				processBet(bet: sevenBet)
			case 9:
				processBet(bet: fieldBet)
			case 10:
				processBet(bet: fieldBet)
			case 11:
				processBet(bet: elevenBet)
				processBet(bet: fieldBet)
			case 12:
				processBet(bet: boxCarsBet)
				processBet(bet: fieldBet)
			default:
				break
			}
        }
		for bet in singleRollBets where bet.chipsWagered.count > 0 {
			removeBet(betName: bet.name!)
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
            if pointBet.chipsWagered.count > 0 {
                processBet(bet: pointBet)
            }
        }
    }

	func handlePointRolled(rollType: Bool) {
		if dontPassBet.chipsWagered.count > 0 {
			removeBet(betName: dontPassBet.name!)
		}
		processBet(bet: passLineBet)

		for bet in placedBets where bet != passLineBet && bet != dontPassBet {
			if bet.betType == .Pass {
				processBet(bet: bet)
			} else if bet.betType == .DontPass {
				removeBet(betName: bet.name!)
			}
		}
		puckState = .Off
	}
}
