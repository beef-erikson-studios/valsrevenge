//
//  MainGameStates.swift
//  valsrevenge
//
//  Created by Troy Martin on 10/19/24.
//

import GameplayKit

class PauseState : GKState {
    
    /// Switches to the next state, PlayingState.
    ///
    /// - Parameters:
    ///   - stateClass: The state class..
    /// - Returns: The state 'PlayingState'.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayingState.self
    }
}


class PlayingState : GKState {
    
    /// Switches to the next state, PauseState.
    ///
    /// - Parameters:
    ///   - stateClass: The state class..
    /// - Returns: The state 'PauseState'.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PauseState.self
    }
}
