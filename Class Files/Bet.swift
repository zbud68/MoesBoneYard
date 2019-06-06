//
//  Bet.swift
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

class Bet: SKSpriteNode {
	var odds: Double = Double()
	var placedBetPosition: CGPoint = CGPoint()
	var puckPosition: CGPoint = CGPoint()
	var state: BetState!
	var chipsWagered: [Chip] = [Chip]()
}
