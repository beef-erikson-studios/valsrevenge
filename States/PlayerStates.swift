//
//  PlayerStates.swift
//  valsrevenge
//
//  Created by Troy Martin on 9/30/24.
//

import GameplayKit

// Player has a key
class PlayerHasKeyState: GKState {
    
    /// Determines if a state can be entered.
    ///
    /// - Parameters:
    ///   - stateClass: The state class the player is attempting to enter.
    /// - Returns: Bool returning if the state entering is valid or not.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayerHasKeyState.self ||
               stateClass == PlayerHasNoKeyState.self
    }
    
    /// Enters PlayerHasKeyState.
    ///
    /// - Parameters:
    ///   - previousState: The current state before entering.
    override func didEnter(from previousState: GKState?) {
        print("Entering PlayerHasKeyState")
    }
    
    /// Exits the PlayerHasKeyState.
    ///
    /// - Parameters:
    ///   - nextState: State to enter next.
    override func willExit(to nextState: GKState) {
        print("Exiting PlayerHasKeyState")
    }
    
    /// Updates the state.
    ///
    /// - Parameters:
    ///   - deltaTime: The current delta time.
    override func update(deltaTime seconds: TimeInterval) {
        print("Updating PlayerHasKeyState")
    }
}

// Player does not have a key
class PlayerHasNoKeyState: GKState {
    
    /// Determines if the state can be entered.
    ///
    /// - Parameters:
    ///   - stateClass: The state class the player is trying to enter.
    /// - Returns: Bool returning if the state entering is valid or not.
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == PlayerHasKeyState.self ||
               stateClass == PlayerHasNoKeyState.self
    }
    
    /// Enters PlayerHasNoKeyState.
    ///
    /// - Parameters:
    ///   - previousState: The current state before entering.
    override func didEnter(from previousState: GKState?) {
        print("Entering PlayerHasNoKeyState")
    }
    
    /// Exits the PlayerHasNoKeyState.
    ///
    /// - Parameters:
    ///   - nextState: State to enter next.
    override func willExit(to nextState: GKState) {
        print("Exiting PlayerHasNoKeyState")
    }
    
    /// Updates the state.
    ///
    /// - Parameters:
    ///   - deltaTime: The current delta time.
    override func update(deltaTime seconds: TimeInterval) {
        print("Updating PlayerHasNoKeyState")
    }
}
