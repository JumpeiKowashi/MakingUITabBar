//
//  ColorModeViewModel.swift
//  MakingUITabBar
//
//  Created by Jumpei Kowashi on 2022/09/18.
//

import UIKit

class ColorModeViewModel {
    
    @Published var backgroundColor: UIColor = .white
    @Published var textColor: UIColor = .black
    
    init () {}
    
    func changeColor() {
        backgroundColor = backgroundColor == .white ? .black : .white
        textColor = textColor == .white ? .black : .white
    }
}
