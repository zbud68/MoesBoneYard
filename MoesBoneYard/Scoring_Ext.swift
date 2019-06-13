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
		}
		handleSingleRollBets()
	}

    func evaluatePointRoll() {
		switch dieTotal {
		case 2:
			processBet(bet: dontComeBet)
			processBet(bet: snakeEyesBet)
			processBet(bet: anyCrapsBet)
			processBet(bet: fieldBet)
			if comeBet.chipsWagered.count > 0 {
				removeBet(betName: comeBet.name!)
			}
		case 3:
			processBet(bet: dontComeBet)
			processBet(bet: craps3Bet)
			processBet(bet: anyCrapsBet)
			processBet(bet: fieldBet)
			if comeBet.chipsWagered.count > 0 {
				removeBet(betName: comeBet.name!)
			}
		case 4:
			processBet(bet: fours)
			processBet(bet: fieldBet)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fours, chip: chip)
					fours.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if die1.value == die2.value {
				processBet(bet: hardFourBet)
			}
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 5:
			processBet(bet: fives)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: fives, chip: chip)
					fives.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 6:
			processBet(bet: sixes)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: sixes, chip: chip)
					sixes.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if die1.value == die2.value {
				processBet(bet: hardSixBet)
			}
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 7:
			processBet(bet: sevenBet)
			processBet(bet: comeBet)
			processBet(bet: dontPassBet)
			for pointBet in pointsBets where pointBet.betType == .DontPass {
				processBet(bet: pointBet)
			}
			if passLineBet.chipsWagered.count > 0 {
				removeBet(betName: passLineBet.name!)
			}
			if dontComeBet.chipsWagered.count > 0 {
				removeBet(betName: dontComeBet.name!)
			}
			for pointBet in pointsBets where pointBet.betType == .Pass {
				removeBet(betName: pointBet.name!)
			}
			puckState = .Off
		case 8:
			processBet(bet: eights)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: eights, chip: chip)
					eights.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if die1.value == die2.value {
				processBet(bet: hardEightBet)
			}
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 9:
			processBet(bet: nines)
			processBet(bet: fieldBet)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: nines, chip: chip)
					nines.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 10:
			processBet(bet: tens)
			if comeBet.chipsWagered.count > 0 {
				for chip in comeBet.chipsWagered {
					moveChipToBetLocation(bet: tens, chip: chip)
					tens.chipsWagered.append(chip)
				}
				removeBet(betName: comeBet.name!)
			}
			if die1.value == die2.value {
				processBet(bet: hardTenBet)
			}
			processBet(bet: fieldBet)
			if dieTotal == thePoint {
				for pointBet in pointsBets where pointBet.chipsWagered.count > 0 {
					pointBet.betState = .Off
				}
			}
		case 11:
			processBet(bet: elevenBet)
			processBet(bet: fieldBet)
			processBet(bet: comeBet)
			if dontComeBet.chipsWagered.count > 0 {
				removeBet(betName: dontComeBet.name!)
			}
		case 12:
			processBet(bet: boxCarsBet)
			if die1.value == die2.value {
				processBet(bet: fieldBet)
			}
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
            bet.removeAllChildren()
            bet.chipsWagered.removeAll()
        }
        if let idx = placedBets.firstIndex(where: { $0.name == betName }) {
			print("\(placedBets[idx].name!) was removed")
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
			currentBet.betType = setBetType()
            currentBet.betState = .On
            currentBet.chipsWagered.append(theChip)
            for chip in currentBet.chipsWagered {
                theChip = chip
                chipTotal -= theChip.value
                totalBetThisRoll += theChip.value
            }
			moveChipToBetLocation(bet: currentBet, chip: theChip)
			placedBets.append(currentBet)
        } else {
            print("invalid bet")
        }
    }

	func processBet(bet: TableBet) {
		if bet.validBet {
			bet.betState = .Off
			if bet.chipsWagered.count > 0 {
				for chip in bet.chipsWagered {
					chipTotal += chip.value
					chipTotal += Int(Double(chip.value) * bet.odds)
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
