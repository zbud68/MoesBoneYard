//
//  TableBet.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/21/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

enum BetState {
	case On, Off
}

enum BetType {
	case Pass, DontPass
}

class TableBet: SKSpriteNode {
	var betState = BetState.Off {
		willSet {
			switch newValue {
			case .On:
				validBet = true
			case .Off:
				validBet = false
			}
		}
	}

	var betType: BetType = BetType.Pass
	var odds: Double = Double()
	var placedBetPosition: CGPoint = CGPoint()
	var puckPosition: CGPoint = CGPoint()
	var validBet: Bool = true
	var chipsWagered: [Chip] = [Chip]()
}
