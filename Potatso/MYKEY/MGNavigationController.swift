//
//  MGNavigationController.swift
//  Potatso
//
//  Created by 毛立 on 2020/10/19.
//  Copyright © 2020 TouchingApp. All rights reserved.
//

import UIKit

class MGNavigationController: UINavigationController {
    override func loadView() {
        super.loadView()
        navigationBar.isHidden = true
    }
}
