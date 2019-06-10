//
//  GameScene.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/18/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

enum RollResult {
	case Win, Loss, Point, Push
}

enum PuckState {
	case On, Off
}

class GameScene: SKScene, SKPhysicsContactDelegate {
/*	var betState = BetState.Off {
		willSet {
			switch newValue {
			case .On:
				print("betState: \(betState)")
			case .Off:
				print("betState: \(betState)")
			}
		}
	}*/

	let handlerBlock: (Bool) -> Void = {
		if $0 {
			var finished = false
			finished.toggle()
		}
	}

	var chipTotalLabel: SKLabelNode!
	var chipTotal: Int = 0 {
		didSet {
			chipTotalLabel.text = String(Int(chipTotal))
		}
	}

	var chipsBetTotalLabel: SKLabelNode = SKLabelNode(fontNamed: "Optima")
	var chipsBetTotal: Int = 0  {
		didSet {
			chipsBetTotalLabel.text = String(chipsBetTotal)
		}
	}

	var totalAmountWonOrLostLabel: SKLabelNode!
	var totalAmountWonOrLost: Int = 0 {
		didSet {
			totalAmountWonOrLostLabel.text = String(Int(totalAmountWonOrLost))
		}
	}

	var rollResult = RollResult.Push {
		willSet {
			switch newValue {
			case .Win:
				print("Winner!")
			case .Loss:
				print("Craps!")
			case .Point:
				print("The Point is: \(thePoint)")
			case .Push:
				print("Keep Rolling")
			}
		}
	}

	var puckState = PuckState.Off {
		willSet {
			switch newValue {
			case .On:
				gamePuck.texture = gamePuck.onTexture
				placeGamePuck()
			case .Off:
				gamePuck.texture = gamePuck.offTexture
				gamePuck.position = gamePuck.homePosition
			}
		}
	}

	//var totalAmountBet: Int = Int()
	//var chipValue: Int = Int()
	//var numChipsBet: Int = Int()

	var dieValues: [Int] = [Int]()

	var player: Player = Player(name: "Player 1", chipTotal: 10000, totalAmountBet: 0)

	var touchedNode: SKNode?
	var touchLocation: CGPoint?
	var gameTable: SKNode?
	var gameScene: GameScene?

	var gamePuck: Puck = Puck()
	
	
	//MARK: *********  Possible Bets **********
	var bet: Bet? = Bet()

	let craps: [Int] = [2,3]
	let points: [Int] = [4,5,6,8,9,10]
	let wins: [Int] = [7,11]
	let fields: [Int] = [2,3,4,9,10,11,12]
	
	var validBetsPlaced: Bool = false
	var fours: Bet = Bet()
	var fives: Bet = Bet()
	var sixes: Bet = Bet()
	var eights: Bet = Bet()
	var nines: Bet = Bet()
	var tens: Bet = Bet()
	var foursBuyBet: Bet = Bet()
	var fivesBuyBet: Bet = Bet()
	var sixesBuyBet: Bet = Bet()
	var eightsBuyBet: Bet = Bet()
	var ninesBuyBet: Bet = Bet()
	var tensBuyBet: Bet = Bet()
	var comeBet: Bet = Bet()
	var dontComeBet: Bet = Bet()
	var passLineBet: Bet = Bet()
	var dontPassBet: Bet = Bet()
	var dontPassBet2: Bet = Bet()
	var fieldBet: Bet = Bet()
	var sevenBet: Bet = Bet()
	var elevenBet: Bet = Bet()
	var hardFourBet: Bet = Bet()
	var hardSixBet: Bet = Bet()
	var hardEightBet: Bet = Bet()
	var hardTenBet: Bet = Bet()
	var snakeEyesBet: Bet = Bet()
	var boxCarsBet: Bet = Bet()
	var anyCrapsBet: Bet = Bet()
	var craps3Bet: Bet = Bet()
	var selectedBet: Bet!
	//var pointBet: [Bet:Chip] = [:]
	//PlacedBets is a Dictionary containing the BetName and the ChipValue placed
	var placedBets: [[Bet:Chip]] = [[:]]
	//var comeOutRollBets: [Bet] = []
	var singleRollBets: [Bet] = []
	var crapsRollBets: [Bet] = []
	var pointsBets: [[Bet:Chip]] = [[:]]
	var pointRollBets: [Bet] = []
	var availableBets: [Bet] = [Bet]()
	var hardWayBets: [Bet] = []
	//var currentBets: [Bet] = [Bet]()
	//var currentPointBet: Bet = Bet()


	//MARK: **********  Scoring Variables  **********
	var selectedChipValue: Int = Int(5)
	var totalBetThisRoll: Int = Int(0)
	var previousChipTotal: Int = Int(10000)
	var currentChipTotal: Int = Int(10000)
	var totalChipsWonOrLost: Int = Int(0)


	//MARK: **********  Chip Variables  **********
	var chipsLocation: SKSpriteNode = SKSpriteNode()
	var chips: [Chip] = [Chip]()
	var chip_1: Chip = Chip()
	var chip_5: Chip = Chip()
	var chip_10: Chip = Chip()
	var chip_25: Chip = Chip()
	var chip_50: Chip = Chip()
	var chip_100: Chip = Chip()
	var chip_500: Chip = Chip()
	var chip_1000: Chip = Chip()

	var chip_1_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_5_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_25_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_50_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_100_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_500_PlaceHolder: SKSpriteNode = SKSpriteNode()
	var chip_1000_PlaceHolder: SKSpriteNode = SKSpriteNode()

	var chipStack_1: EasterEgg!
	var chipStack_5: EasterEgg!
	var chipStack_10: EasterEgg!
	var chipStack_25: EasterEgg!
	var chipStack_1000: EasterEgg!
	var easterEggs: [EasterEgg]!
	var easterEggFound: Bool = false

	var selectedChipTexture: SKTexture = SKTexture()
	var selectedChip: Chip = Chip()


	//MARK: **********  Buttons Variables  **********
	var rollButton: SKSpriteNode = SKSpriteNode()
	var clearBetsButton: SKSpriteNode = SKSpriteNode()
	var shopButton: SKSpriteNode = SKSpriteNode()
	var settingsButton: SKSpriteNode = SKSpriteNode()
	var helpButton: SKSpriteNode = SKSpriteNode()
	var homeButton: SKSpriteNode = SKSpriteNode()


	//MARK: *********  Dice Roll Variables  **********
	var comeOutRoll: Bool = true
	var currentDice: [Dice] = [Dice]()
	var die1: Dice = Dice()
	var die2: Dice = Dice()

	var dieTotal = Int()
	var thePoint: Int = Int()
	var thePointBet = Bet()
	//var theCurrentPointBet: [Bet:Int] = [Bet():0]
	
	override func didMove(to view: SKView) {
        setupGameTable()
		chipsBetTotal = 0
		chipsBetTotalLabel.text = String(chipsBetTotal)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		//The following lines get the location of the touch in relation to the position in the scene
		if let touch = touches.first {
			let positionInScene = touch.location(in: self)
			touchLocation = positionInScene
			touchedNode = atPoint(positionInScene)
			//Process the touches received by the user
			handleTouches(TouchedNode: touchedNode!)
		}
	}

	func handleTouches(TouchedNode: SKNode) {
		var currentBet = Bet()
		var nodeName = ""
		let touchedNode = TouchedNode
		if let name = touchedNode.name {
			nodeName = name
			for chip in chips where chip.name == nodeName {
				selectedChip = chip
				selectedChipValue = chip.value
				selectedChipTexture = chip.texture!
			}
			for bet in availableBets {
				currentBet = bet
				if nodeName == currentBet.name {
					//currentBet.chipsWagered.append(selectedChip)
					let placedBet = [currentBet:selectedChip]
					//placedBets.append(placedBet)
					placeBet(bet: placedBet)
					//chipsBetTotal += selectedChip.value
				}
			}
			for chip in currentBet.chipsWagered {
				print("chip placed: \(chip.value)")
			}

			for egg in easterEggs {
				if nodeName == egg.name {
					let currentEgg = egg
					let stackValue = egg.stackValue
					if currentEgg.name == nodeName && stackValue == selectedChip.value {
						currentEgg.status = .On
					} else {
						currentEgg.status = .Off
					}
				}
			}

			switch nodeName {
			case "RollButton":
				print("Roll Button Touched")
				rollButtonTouched()
			case "ClearBetsButton":
				clearBetsButtonTouched()
				print("Clear Bets Button")
			default:
				break
			}
		}
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

	override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		wasEasterEggFound()
		if easterEggFound {
			removeEasterEggs()
		}
		chipTotalLabel.text = String(Int(chipTotal))
		chipsBetTotalLabel.text = String(Int(chipsBetTotal))
	}
}
