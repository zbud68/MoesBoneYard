//
//  GameSetup_Ext.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/17/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

// Extension of the GameScene Class
extension GameScene {
    // Pulls in the Game Table for the GameScene.sks file for use in  code
    func setupGameTable() {
        if let GameTable = self.childNode(withName: "GameTable") as? SKSpriteNode {
            gameTable = GameTable
        } else {
            print("Game Table not found")
        }
        setupChips()
        setupBets()
        setupBetArrays()
        setupButtons()
        setupDice()
        setupPuck()
        setupTotalChipCountLabel()
        setupChipStacks()
        setupCurrentPointLabel()
    }

    func setupChipStacks() {
        if let ChipStack_1 = gameTable?.childNode(withName: "ChipStack_1") as? EasterEgg {
            chipStack_1 = ChipStack_1
            chipStack_1.stackValue = 1
        } else {
            print("Chip Stack 1 not found")
        }
        if let ChipStack_5 = gameTable?.childNode(withName: "ChipStack_5") as? EasterEgg {
            chipStack_5 = ChipStack_5
            chipStack_5.stackValue = 5
        } else {
            print("Chip Stack 5 not found")
        }
        if let ChipStack_10 = gameTable?.childNode(withName: "ChipStack_10") as? EasterEgg {
            chipStack_10 = ChipStack_10
            chipStack_10.stackValue = 10
        } else {
            print("Chip Stack 10 not found")
        }
        if let ChipStack_25 = gameTable?.childNode(withName: "ChipStack_25") as? EasterEgg {
            chipStack_25 = ChipStack_25
            chipStack_25.stackValue = 25
        } else {
            print("Chip Stack 25 not found")
        }
        if let ChipStack_1000 = gameTable?.childNode(withName: "ChipStack_1000") as? EasterEgg {
            chipStack_1000 = ChipStack_1000
            chipStack_1000.stackValue = 1000
        } else {
            print("Chip Stack 1000 not found")
        }

        easterEggs = [chipStack_1, chipStack_5, chipStack_10, chipStack_25, chipStack_1000]
    }

    func setupBets() {
        if let Fours = gameTable?.childNode(withName: "Fours") as? TableBet {
            fours = Fours
            fours.betState = .Off
            fours.odds = 2
            fours.placedBetPosition = CGPoint(x: 0, y: 0)
            fours.puckPosition = CGPoint(x: -110, y: 125)
            availableBets.append(fours)
        } else {
            print("Fours not found")
        }

        if let Fives = gameTable?.childNode(withName: "Fives") as? TableBet {
            fives = Fives
            fives.betState = .Off
            fives.odds = 1.5
            fives.placedBetPosition = CGPoint(x: 0, y: 0)
            fives.puckPosition = CGPoint(x: -45, y: 125)
            availableBets.append(fives)
        } else {
            print("Fives not found")
        }

        if let Sixes = gameTable?.childNode(withName: "Sixes") as? TableBet {
            sixes = Sixes
            sixes.betState = .Off
            sixes.odds = 1.2
            sixes.placedBetPosition = CGPoint(x: 0, y: 0)
            sixes.puckPosition = CGPoint(x: 20, y: 125)
            availableBets.append(sixes)
        } else {
            print("Sixes not found")
        }

        if let Eights = gameTable?.childNode(withName: "Eights") as? TableBet {
            eights = Eights
            eights.betState = .Off
            eights.odds = 1.2
            eights.placedBetPosition = CGPoint(x: 0, y: 0)
            eights.puckPosition = CGPoint(x: 85, y: 125)
            availableBets.append(eights)
        } else {
            print("Eights not found")
        }

        if let Nines = gameTable?.childNode(withName: "Nines") as? TableBet {
            nines = Nines
            nines.betState = .Off
            nines.odds = 1.5
            nines.placedBetPosition = CGPoint(x: 0, y: 0)
            nines.puckPosition = CGPoint(x: 150, y: 125)
            availableBets.append(nines)
        } else {
            print("Nines not found")
        }

        if let Tens = gameTable?.childNode(withName: "Tens") as? TableBet {
            tens = Tens
            tens.betState = .Off
            tens.odds = 2
            tens.placedBetPosition = CGPoint(x: 0, y: 0)
            tens.puckPosition = CGPoint(x: 215, y: 125)
            availableBets.append(tens)
        } else {
            print("Tens not found")
        }

        if let FoursBuyBet = gameTable?.childNode(withName: "FoursBuyBet") as? TableBet {
            foursBuyBet = FoursBuyBet
            foursBuyBet.betState = .Off
            foursBuyBet.odds = 2
            foursBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(foursBuyBet)
        } else {
            print("FoursBuyBet not found")
        }

        if let FivesBuyBet = gameTable?.childNode(withName: "FivesBuyBet") as? TableBet {
            fivesBuyBet = FivesBuyBet
            fivesBuyBet.betState = .Off
            fivesBuyBet.odds = 1.5
            fivesBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(fivesBuyBet)
        } else {
            print("FivesBuyBet not found")
        }

        if let SixesBuyBet = gameTable?.childNode(withName: "SixesBuyBet") as? TableBet {
            sixesBuyBet = SixesBuyBet
            sixesBuyBet.betState = .Off
            sixesBuyBet.odds = 1.2
            sixesBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(sixesBuyBet)
        } else {
            print("SixesBuyBet not found")
        }

        if let EightsBuyBet = gameTable?.childNode(withName: "EightsBuyBet") as? TableBet {
            eightsBuyBet = EightsBuyBet
            eightsBuyBet.betState = .Off
            eightsBuyBet.odds = 1.2
            eightsBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(eightsBuyBet)
        } else {
            print("EightsBuyBet not found")
        }

        if let NinesBuyBet = gameTable?.childNode(withName: "NinesBuyBet") as? TableBet {
            ninesBuyBet = NinesBuyBet
            ninesBuyBet.betState = .Off
            ninesBuyBet.odds = 1.5
            ninesBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(ninesBuyBet)
        } else {
            print("NinesBuyBet not found")
        }

        if let TensBuyBet = gameTable?.childNode(withName: "TensBuyBet") as? TableBet {
            tensBuyBet = TensBuyBet
            tensBuyBet.betState = .Off
            tensBuyBet.odds = 2
            tensBuyBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(tensBuyBet)
        } else {
            print("TensBuyBet not found")
        }

        if let SnakeEyesBet = gameTable?.childNode(withName: "SnakeEyesBet") as? TableBet {
            snakeEyesBet = SnakeEyesBet
            snakeEyesBet.betState = .Off
            snakeEyesBet.odds = 30
            snakeEyesBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(snakeEyesBet)
        } else {
            print("Snake Eyes not found")
        }

        if let BoxCarsBet = gameTable?.childNode(withName: "BoxCarsBet") as? TableBet {
            boxCarsBet = BoxCarsBet
            boxCarsBet.betState = .Off
            boxCarsBet.odds = 30
            boxCarsBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(boxCarsBet)
        } else {
            print("Box Cars not found")
        }

        if let SevenBet = gameTable?.childNode(withName: "SevenBet") as? TableBet {
            sevenBet = SevenBet
            sevenBet.betState = .Off
            sevenBet.odds = 4
            sevenBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(sevenBet)
        } else {
            print("Seven Bet not found")
        }

        if let ElevenBet = gameTable?.childNode(withName: "ElevenBet") as? TableBet {
            elevenBet = ElevenBet
            elevenBet.betState = .Off
            elevenBet.odds = 15
            elevenBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(elevenBet)
        } else {
            print("Eleven Bet not found")
        }

        if let HardFourBet = gameTable?.childNode(withName: "HardFourBet") as? TableBet {
            hardFourBet = HardFourBet
            hardFourBet.betState = .Off
            hardFourBet.odds = 7
            hardFourBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(hardFourBet)
        } else {
            print("Hard Fours Bet not found")
        }

        if let HardSixBet = gameTable?.childNode(withName: "HardSixBet") as? TableBet {
            hardSixBet = HardSixBet
            hardSixBet.betState = .Off
            hardSixBet.odds = 9
            hardSixBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(hardSixBet)
        } else {
            print("Hard Sixes Bet not found")
        }

        if let HardTenBet = gameTable?.childNode(withName: "HardTenBet") as? TableBet {
            hardTenBet = HardTenBet
            hardTenBet.betState = .Off
            hardTenBet.odds = 7
            hardTenBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(hardTenBet)
        } else {
            print("Hard Fours Bet not found")
        }

        if let HardEightBet = gameTable?.childNode(withName: "HardEightBet") as? TableBet {
            hardEightBet = HardEightBet
            hardEightBet.betState = .Off
            hardEightBet.odds = 9
            hardEightBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(hardEightBet)
        } else {
            print("Hard Eight Bet not found")
        }

        if let AnyCrapsBet = gameTable?.childNode(withName: "AnyCrapsBet") as? TableBet {
            anyCrapsBet = AnyCrapsBet
            anyCrapsBet.betState = .Off
            anyCrapsBet.odds = 7
            anyCrapsBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(anyCrapsBet)
        } else {
            print("Any Craps Bet not found")
        }

        if let Craps3Bet = gameTable?.childNode(withName: "Craps3Bet") as? TableBet {
            craps3Bet = Craps3Bet
            craps3Bet.betState = .Off
            craps3Bet.odds = 15
            craps3Bet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(craps3Bet)
        } else {
            print("Craps 3 Bet not found")
        }

        if let ComeBet = gameTable?.childNode(withName: "ComeBet") as? TableBet {
            comeBet = ComeBet
            comeBet.betState = .Off
            comeBet.odds = 1
            comeBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(comeBet)
        } else {
            print("Come Bet not found")
        }

        if let DontComeBet = gameTable?.childNode(withName: "DontComeBet") as? TableBet {
            dontComeBet = DontComeBet
            dontComeBet.betState = .Off
            dontComeBet.odds = 1
            dontComeBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(dontComeBet)
        } else {
            print("Don't Come Bet not found")
        }

        if let DontPassBet = gameTable?.childNode(withName: "DontPassBet") as? TableBet {
            dontPassBet = DontPassBet
            dontPassBet.betState = .Off
            dontPassBet.odds = 1
            dontPassBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(dontPassBet)
        } else {
            print("Don't Pass Bet not found")
        }

        if let FieldBet = gameTable?.childNode(withName: "FieldBet") as? TableBet {
            fieldBet = FieldBet
            fieldBet.betState = .Off
            fieldBet.odds = 1
            fieldBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(fieldBet)
        } else {
            print("Field Bet not found")
        }

        if let PassLineBet = gameTable?.childNode(withName: "PassLineBet") as? TableBet {
            passLineBet = PassLineBet
            passLineBet.betState = .Off
            passLineBet.odds = 1
            passLineBet.placedBetPosition = CGPoint(x: 0, y: 0)
            availableBets.append(passLineBet)
        } else {
            print("Pass Line Bet Not Found")
        }

        for bet in availableBets {
            bet.zPosition = 10
        }
    }

    func setupBetArrays() {
        singleRollBets = [snakeEyesBet, boxCarsBet, craps3Bet, elevenBet, sevenBet, fieldBet, anyCrapsBet]
        pointRollBets = [fours, fives, sixes, eights, nines, tens]
        hardWayBets = [hardFourBet, hardSixBet, hardEightBet, hardTenBet]
		buyBets = [foursBuyBet, fivesBuyBet, sixesBuyBet, eightsBuyBet, ninesBuyBet, tensBuyBet]
    }

    func setupChips() {
        if let ChipsLocation = gameTable?.childNode(withName: "ChipsLocation") as? SKSpriteNode {
            chipsLocation = ChipsLocation
        } else {
            print("Chips Location Not Found")
        }

        if let Chip_1 = chipsLocation.childNode(withName: "Chip_1") as? Chip {
            chip_1 = Chip_1
            chip_1.value = 1
            chip_1.name = "Chip_1"
            chips.append(chip_1)
        } else {
            print("$1 Chips not found")
        }

        if let Chip_5 = chipsLocation.childNode(withName: "Chip_5") as? Chip {
            chip_5 = Chip_5
            chip_5.value = 5
            chip_5.name = "Chip_5"

            chips.append(chip_5)
        } else {
            print("$5 Chips not found")
        }

        if let Chip_10 = chipsLocation.childNode(withName: "Chip_10") as? Chip {
            chip_10 = Chip_10
            chip_10.value = 10
            chip_10.name = "Chip_10"
            chips.append(chip_10)
        } else {
            print("$10 Chips not found")
        }

        if let Chip_25 = chipsLocation.childNode(withName: "Chip_25") as? Chip {
            chip_25 = Chip_25
            chip_25.value = 25
            chip_25.name = "Chip_25"
            chips.append(chip_25)
        } else {
            print("$25 Chips not found")
        }

        if let Chip_50 = chipsLocation.childNode(withName: "Chip_50") as? Chip {
            chip_50 = Chip_50
            chip_50.value = 50
            chip_50.name = "Chip_50"
            chips.append(chip_50)
        } else {
            print("$50 Chips not found")
        }

        if let Chip_100 = chipsLocation.childNode(withName: "Chip_100") as? Chip {
            chip_100 = Chip_100
            chip_100.value = 100
            chip_100.name = "Chip_100"
            chips.append(chip_100)
        } else {
            print("$100 Chips not found")
        }

        if let Chip_500 = chipsLocation.childNode(withName: "Chip_500") as? Chip {
            chip_500 = Chip_500
            chip_500.value = 500
            chip_500.name = "Chip_500"
            chips.append(chip_500)
        } else {
            print("$500 Chips not found")
        }

        if let Chip_1000 = chipsLocation.childNode(withName: "Chip_1000") as? Chip {
            chip_1000 = Chip_1000
            chip_1000.value = 1000
            chip_1000.name = "Chip_1000"
            chips.append(chip_1000)
        } else {
            print("$1000 Chips not found")
        }

        for chip in chips {
            chip.zPosition = 15
        }
        selectedChip = chip_10
    }

    func setupButtons() {
        if let RollButton = gameTable?.childNode(withName: "RollButton") as? SKSpriteNode {
            rollButton = RollButton
        } else {
            print("Roll Button not found")
        }

        if let ClearBetsButton = gameTable?.childNode(withName: "ClearBetsButton") as? SKSpriteNode {
            clearBetsButton = ClearBetsButton
        } else {
            print("Clear Bets Button not found")
        }

        if let ShopButton = gameTable?.childNode(withName: "ShopButton") as? SKSpriteNode {
            shopButton = ShopButton
        } else {
            print("shop button not found")
        }

        if let SettingsButton = gameTable?.childNode(withName: "SettingsButton") as? SKSpriteNode {
            settingsButton = SettingsButton
        } else {
            print("Settings button not found")
        }

        if let HelpButton = gameTable?.childNode(withName: "HelpButton") as? SKSpriteNode {
            helpButton = HelpButton
        } else {
            print("Help Button not found")
        }

        if let HomeButton = gameTable?.childNode(withName: "HomeButton") as? SKSpriteNode {
            homeButton = HomeButton
        } else {
            print("Home Button not found")
        }
    }

    func setupDice() {
        if let Die1 = gameTable?.childNode(withName: "Die1") as? Dice {
            die1 = Die1
            die1.currentTexture = die1.texture!
        } else {
            print("Die 1 not found")
        }

        if let Die2 = gameTable?.childNode(withName: "Die2") as? Dice {
            die2 = Die2
            die2.currentTexture = die2.texture!
        } else {
            print("Die 2 not found")
        }
        currentDice = [die1, die2]
    }

    func setupPuck() {
        if let GamePuck = gameTable?.childNode(withName: "GamePuck") as? Puck {
            gamePuck = GamePuck
        } else {
            print("Game Puck not found")
        }
        gamePuck.name = "GamePuck"
        gamePuck.texture = SKTexture(imageNamed: "OffPuck")
        gamePuck.zPosition = 10
        gamePuck.zRotation = 0
        gamePuck.position = CGPoint(x: -265, y: 117)
        gamePuck.size = CGSize(width: 36, height: 36)
        gamePuck.homePosition = gamePuck.position
    }

    func setupTotalChipCountLabel() {
        chipTotalLabel = SKLabelNode(fontNamed: "Optima")
        chipTotalLabel.fontColor = UIColor.yellow
        chipTotalLabel.fontSize = 16
        chipTotalLabel.horizontalAlignmentMode = .center
        chipTotalLabel.verticalAlignmentMode = .center
        chipTotalLabel.position = CGPoint(x: -225, y: 164)
        chipTotalLabel.zPosition = 20
        chipTotal = player.chipTotal
        chipTotalLabel.text = String(chipTotal)
        gameTable?.addChild(chipTotalLabel)
    }

    func setupTotalAmountWonOrLostLabel() {
        totalAmountWonOrLostLabel.fontColor = UIColor.yellow
        totalAmountWonOrLostLabel.fontSize = 16
        totalAmountWonOrLostLabel.horizontalAlignmentMode = .center
        totalAmountWonOrLostLabel.verticalAlignmentMode = .center
        totalAmountWonOrLostLabel.position = CGPoint(x: -300, y: -175)
        totalAmountWonOrLostLabel.zPosition = 20
        totalAmountWonOrLostLabel.text = "Amount Won/Lost: \(totalChipsWonOrLost)"
        gameTable?.addChild(totalAmountWonOrLostLabel)
    }

    func setupCurrentPointLabel() {
        currentPointLabel.fontColor = UIColor.yellow
        currentPointLabel.fontSize = 16
        currentPointLabel.horizontalAlignmentMode = .center
        currentPointLabel.verticalAlignmentMode = .center
        currentPointLabel.position = CGPoint(x: -200, y: -175)
        currentPointLabel.zPosition = 20
        currentPoint = 0
        currentPointLabel.text = String("Current Point: \(currentPoint)")
        gameTable?.addChild(currentPointLabel)
    }
}
