//
//  Alerts.swift
//  TickTacToes
//
//  Created by Sergio Herrera on 8/12/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    var id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                             message: Text("Heyyy you beat the AI"),
                             buttonTitle: Text("Hells yah"))
    
    static let computerWin = AlertItem(title: Text("You Lost!"),
                             message: Text("Great. Machines are taking over..."),
                             buttonTitle: Text("Rematch"))
    
    static let draw = AlertItem(title: Text("Draw"),
                             message: Text("Wack. Cmon beat the AI"),
                             buttonTitle: Text("Try again"))
}
