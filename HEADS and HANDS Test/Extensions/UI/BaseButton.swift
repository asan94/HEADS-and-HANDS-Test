//
//  BaseButton.swift
//  HEADS and HANDS Test
//
//  Created by Аметов Асан on 29.06.17.
//  Copyright © 2017 Asan Ametov. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
            layer.borderWidth = 0.5
        }
    }
   
}
