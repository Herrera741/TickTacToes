//
//  ContentView.swift
//  TickTacToes
//
//  Created by Sergio Herrera on 8/12/22.
//

import SwiftUI

struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isGameboardDisabled = false
    @State private var alertItem: AlertItem?
    @State private var isAlertShowing = false
    
    var body: some View {
        
        ZStack {
            Color(UIColor.darkGray).edgesIgnoringSafeArea(.all)
            
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    Text("Tick Tac Toes")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<9) { index in
                            ZStack {
                                Rectangle()
                                    .foregroundColor(.orange)
                                .frame(width: geometry.size.width/3 - 20, height: geometry.size.width/3 - 15)
                                
                                Image(moves[index]?.indicator ?? "")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(.white)
                            }
                            .onTapGesture {
                                if isSquareOccupied(in: moves, forIndex: index) { return }
                                // square is playable so execute statements below
                                moves[index] = Move(player: .human, boardIndex: index)
                                
                                // check for win condition or draw
                                if checkWinCondition(for: .human, in: moves) {
                                    alertItem = AlertContext.humanWin
                                    isAlertShowing = true
                                    return
                                }
                                
                                if checkForDraw(in: moves) {
                                    alertItem = AlertContext.draw
                                    isAlertShowing = true
                                    return
                                }
                                
                                isGameboardDisabled = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    let computerPosition = determineComputerMovePosition(in: moves)
                                    moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                    isGameboardDisabled = false
                                    
                                    if checkWinCondition(for: .computer, in: moves) {
                                        alertItem = AlertContext.computerWin
                                        isAlertShowing = true
                                        return
                                    }
                                    
                                    if checkForDraw(in: moves) {
                                        alertItem = AlertContext.draw
                                        isAlertShowing = true
                                        return
                                    }
                                }
                                
                            }

                        }
                    } // end LazyVGrid
                    Spacer()
                } // end VStack
                .disabled(isGameboardDisabled)
                .padding()
                .alert(isPresented: $isAlertShowing) {
                    Alert(title: alertItem!.title, message: alertItem?.message, dismissButton: .default(alertItem!.buttonTitle, action: { resetGame() }))
                }
            } // end GeometryReader
        } // end ZStack
    } // end body
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        // in moves array check every actual Move (no nils) if index equals
        // current index; if there is a match (true) then square is occupied
        // otherwise (false) square is a playable square
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0, 1, 2],
                                          [3, 4, 5],
                                          [6, 7, 8],
                                          [0, 3, 6],
                                          [1, 4, 7],
                                          [2, 5, 8],
                                          [0, 4, 8],
                                          [2, 4, 6]]
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex  } )
        
        // check if current player has won
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        // no one won yet
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        // check if all gameboard spaces have been played
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let player: Player
    let boardIndex: Int
    var indicator: String {
        return player == .human ? "toe-img" : "tick-img"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
