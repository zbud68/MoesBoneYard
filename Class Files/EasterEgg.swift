//
//  EasterEgg.swift
//  MoesBoneYard
//
//  Created by Mark Davis on 6/9/19.
//  Copyright © 2019 Mark Davis. All rights reserved.
//

import SpriteKit
import UIKit

enum Status {
	case On, Off
}

class EasterEgg: Chip {
	var stackValue: Int = Int()
	var status: Status = .Off
}
