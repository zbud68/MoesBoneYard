//
//  Player.swift
//  Moe's Bones
//
//  Created by Mark Davis on 5/17/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import UIKit
import SpriteKit

class Player {
    var name: String!
    var chipTotal: CGFloat!

	init(name: String, chipTotal: CGFloat) {
        self.name = name
        self.chipTotal = chipTotal
    }
}
