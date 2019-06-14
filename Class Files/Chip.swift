//
//  Chip.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/20/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

class Chip: SKSpriteNode {

	var betType: BetType = BetType.Pass
	var value: Int = Int()
	var counted: Bool = false
}
