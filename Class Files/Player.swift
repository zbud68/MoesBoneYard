//
//  Player.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/24/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

struct Player {
	var name: String!
	var chipTotal: Int!
	var totalAmountBet: Int!

	init(name: String, chipTotal: Int, totalAmountBet: Int) {
		self.name = name
		self.chipTotal = chipTotal
		self.totalAmountBet = totalAmountBet
	}
}


