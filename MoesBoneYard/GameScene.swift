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
	var betState = BetState.Off {
		willSet {
			switch newValue {
			case .On:
				print("betState: \(betState)")
			case .Off:
				print("betState: \(betState)")
			}
		}
	}

	let handlerBlock: (Bool) -> Void = {
		if $0 {
			var finished = false
			finished.toggle()
		}
	}

	var chipTotalLabel: SKLabelNode!
	var chipTotal: Double = 0 {
		didSet {
			chipTotalLabel.text = String(Int(chipTotal))
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
			case .Off:
				gamePuck.texture = gamePuck.offTexture
			}
		}
	}

	var totalAmountBet: Int = Int()
	var chipValue: Int = Int()
	var numChipsBet: Int = Int()

	var dieValues: [Double] = [Double]()

	var player: Player = Player(name: "Player 1", chipTotal: 10000)

	var touchedNode: SKNode?
	var touchLocation: CGPoint?
	var gameTable: SKNode?
	var gameScene: GameScene?

	var gamePuck: Puck = Puck()
	
	
	//MARK: *********  Possible Bets **********
	var bet: Bet? = Bet()

	let craps: [Double] = [2,3,12]
	let points: [Double] = [4,5,6,8,9,10]
	let wins: [Double] = [7,11]
	
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
	var foursBets: [Chip] = []
	var fivesBets: [Chip] = []
	var sixesBets: [Chip] = []
	var eightsBets: [Chip] = []
	var ninesBets: [Chip] = []
	var tensBets: [Chip] = []
	var selectedBet: Bet!
	var pointBet: [Bet:Chip] = [:]
	//PlacedBets is a Dictionary containing the BetName and the ChipValue placed
	var placedBets: [[Bet:Chip]] = [[:]]
	var comeOutRollBets: [[Bet:Chip]] = [[:]]
	var singleRollBets: [[Bet:Chip]] = [[:]]
	var pointsBets: [[Bet:Chip]] = [[:]]
	var pointRollBets: [[Bet:Chip]] = [[:]]
	var crapsBets: [[Bet:Chip]] = [[:]]
	var availableBets: [Bet] = [Bet]()
	//var currentBets: [Bet] = [Bet]()
	var currentPointBet: Bet = Bet()


	//MARK: **********  Scoring Variables  **********
	var selectedChipValue: Double = Double(5)
	var totalBetThisRoll: Double = Double(0)


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
	var thePoint = Int()
	var thePointBet = Bet()
	
	override func didMove(to view: SKView) {
		setupTotalChipCountLabel()
        setupGameTable()
		gameStart()
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
				let currentBet = bet
				if nodeName == currentBet.name {
					currentBet.chipsWagered.append(selectedChip)
					currentBet.state = .On
					let placedBet = [currentBet:selectedChip]
					placedBets.append(placedBet)
					placeBet(bet: placedBet)
				}
				for chip in currentBet.chipsWagered {
					print(chip.value)
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

   override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		chipTotalLabel.text = String(Int(chipTotal))
	}
}
