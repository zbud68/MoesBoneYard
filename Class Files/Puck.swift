//
//  Puck.swift
//  Moe's Bone Yard
//
//  Created by Mark Davis on 5/25/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

class Puck: SKSpriteNode {
	var homePosition: CGPoint = CGPoint()
	var onTexture: SKTexture = SKTexture(imageNamed: "OnPuck")
	var offTexture: SKTexture = SKTexture(imageNamed: "OffPuck")
}
