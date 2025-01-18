//
//  CoffeCupModel.swift
//  iOSGroup11
//
//  Created by Sara Ljung on 2024-03-04.
//

import Foundation
import SwiftUI

enum CoffeeLevels: Int, CaseIterable{
    case empty = 0
    case level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13, full
    
    var imageCup: String{
        switch self{
        case .empty:
            return "cup0"
        case .level1:
            return "cup1"
        case .level2:
            return "cup2"
        case .level3:
            return "cup3"
        case .level4:
            return "cup4"
        case .level5:
            return "cup5"
        case .level6:
            return "cup6"
        case .level7:
            return "cup7"
        case .level8:
            return "cup8"
        case .level9:
            return "cup9"
        case .level10:
            return "cup10"
        case .level11:
            return "cup11"
        case .level12:
            return "cup12"
        case .level13:
            return "cup13"
        case .full:
            return "cup14"
        }
    }
    static func level(for fillLevel: Int) -> CoffeeLevels{
        return CoffeeLevels(rawValue: fillLevel) ?? .empty
    }
}
