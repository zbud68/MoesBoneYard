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

enum ComeOutBetType {
	case Pass, DontPass
}

class GameScene: SKScene, SKPhysicsContactDelegate {
	let handlerBlock: (Bool) -> Void = {
		if $0 {
			var finished = false
			finished.toggle()
		}
	}

	var currentPointLabel: SKLabelNode = SKLabelNode(fontNamed: "Optima")
	var currentPoint: Int = 0 {
		didSet {
			currentPointLabel.text = String("Current Point: \(currentPoint)")
		}
	}

	var chipTotalLabel: SKLabelNode!
	var chipTotal: Int = 0 {
		didSet {
			previousChipTotal = currentChipTotal
			currentChipTotal = chipTotal
			totalChipsWonOrLost = (previousChipTotal - currentChipTotal)
			chipTotalLabel.text = String(Int(chipTotal))
			print("Chip Total: \(chipTotal)")
		}
	}
/*
	var chipsBetTotalLabel: SKLabelNode = SKLabelNode(fontNamed: "Optima")
	var chipsBetTotal: Int = 0  {
		didSet {
			chipsBetTotalLabel.text = String("Chips Bet: \(chipsBetTotal)")
		}
	}
*/
	var totalAmountWonOrLostLabel: SKLabelNode = SKLabelNode(fontNamed: "Optima")
	var currentRollResults: Int = 0 {
		didSet {
			totalAmountWonOrLostLabel.text = "Amount Won or Lost: \(totalChipsWonOrLost))"
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

	var passBet: Bool = true
	var comeOutBetType = ComeOutBetType.Pass {
		willSet {
			switch newValue {
			case .Pass:
				passBet = true
			case .DontPass:
				passBet = false
			}
		}
	}

	var dieValues: [Int] = [Int]()

	var player: Player = Player(name: "Player 1", chipTotal: 10000, totalAmountBet: 0)

	var touchedNode: SKNode?
	var touchLocation: CGPoint?
	var gameTable: SKNode?
	var gameScene: GameScene?

	var gamePuck: Puck = Puck()
	
	
	//MARK: *********  Possible Bets **********
	var bet: TableBet? = TableBet()

	let craps: [Int] = [2,3]
	let points: [Int] = [4,5,6,8,9,10]
	let wins: [Int] = [7,11]
	let fields: [Int] = [2,3,4,9,10,11,12]
	
	var validBetsPlaced: Bool = false
	var fours: TableBet = TableBet()
	var fives: TableBet = TableBet()
	var sixes: TableBet = TableBet()
	var eights: TableBet = TableBet()
	var nines: TableBet = TableBet()
	var tens: TableBet = TableBet()
	var foursBuyBet: TableBet = TableBet()
	var fivesBuyBet: TableBet = TableBet()
	var sixesBuyBet: TableBet = TableBet()
	var eightsBuyBet: TableBet = TableBet()
	var ninesBuyBet: TableBet = TableBet()
	var tensBuyBet: TableBet = TableBet()
	var comeBet: TableBet = TableBet()
	var dontComeBet: TableBet = TableBet()
	var passLineBet: TableBet = TableBet()
	var dontPassBet: TableBet = TableBet()
	var dontPassBet2: TableBet = TableBet()
	var fieldBet: TableBet = TableBet()
	var sevenBet: TableBet = TableBet()
	var elevenBet: TableBet = TableBet()
	var hardFourBet: TableBet = TableBet()
	var hardSixBet: TableBet = TableBet()
	var hardEightBet: TableBet = TableBet()
	var hardTenBet: TableBet = TableBet()
	var snakeEyesBet: TableBet = TableBet()
	var boxCarsBet: TableBet = TableBet()
	var anyCrapsBet: TableBet = TableBet()
	var craps3Bet: TableBet = TableBet()
	var selectedBet: TableBet!
	//PlacedBets is a Dictionary containing the BetName and the ChipValue placed
	var placedBets: [TableBet] = []
	var singleRollBets: [TableBet] = []
	var crapsRollBets: [TableBet] = []
	var pointsBets: [TableBet] = []
	var pointRollBets: [TableBet] = []
	var availableBets: [TableBet] = []
	var hardWayBets: [TableBet] = []
	var currentBets: [TableBet] = []
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
	var thePointBet = TableBet()

	override func didMove(to view: SKView) {
        setupGameTable()
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
		var currentBet = TableBet()
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
					placeBet(bet: currentBet)
				}
			}

			//for chip in currentBet.chipsWagered {
				//print("chip placed: \(chip.value)")
			//}

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
		currentPointLabel.text = "Current Point: \(currentPoint)"
		chipTotalLabel.text = "\(chipTotal)"
		totalAmountWonOrLostLabel.text = "Amount Won/Lost: \(totalChipsWonOrLost)"
		//chipsBetTotalLabel.text = "Current Point: \(thePoint)"
	}
}
