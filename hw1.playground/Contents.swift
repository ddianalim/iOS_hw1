import SwiftUI

// TODO: Declare any additional structs, classes, enums, or protocols here!

struct Location {
    let name: String
    let description: String
    var exits: [String: String]
    var items: [Item]
}

struct Item {
    let name: String
    let description: String
    var isPickedUp: Bool = false
}

enum GameState {
    case atBasecamp
    case onMountain
    case atSummit
    case descending
    case gameOver
}

protocol GameObject {
    var name: String { get }
    var description: String { get }
}

extension Location: GameObject {}
extension Item: GameObject {}

/// Declare your game's behavior and state in this struct.
///
/// This struct will be re-created when the game resets. All game state should
/// be stored in this struct.
struct EverestGame: AdventureGame {
    /// Returns a title to be displayed at the top of the game.
    ///
    /// You can generate this dynamically based on your game's state.
    var title: String {
        // TODO: Change this title
        return "Climbing Mt. Everest 🏔️"
    }
    
    /// Runs at the start of every game.
    ///
    /// Use this function to introduce the game to the player.
    ///
    /// - Parameter context: The object you use to write output and end the game.
    mutating func start(context: AdventureGameContext) {
        //        playIntroduction()
        context.write("Welcome to the Mt. Everest Climbing Adventure!")
        context.write("You are an experienced climber attempting to summit Mt. Everest.")
        context.write("Your journey begins at Basecamp. Good luck, and be careful!")
        // TODO: write something about acclimitization
    }
    
    /// Runs when the user enters a line of input.
    ///
    /// Generally, you parse the user's command, update game state as necessary, then
    /// write output.
    ///
    /// To display a line to the user, use the `context.write(_)` function and pass in
    /// a ``String``, like this:
    ///
    /// ```swift
    /// context.write("You have been eaten by a grue.")
    /// ```
    ///
    /// If you'd like to end the game (say, if the player dies), call context.endGame().
    /// Note that this does *not* display a game over message - it merely disables
    /// the buttons and forces the user to reset.
    ///
    /// **Sidenote:** context.write() supports AttributedString for rich text formatting.
    /// Consult the [homework instructions](https://www.seas.upenn.edu/~cis1951/assignments/hw/hw1)
    /// for guidance.
    ///
    /// - Parameters:
    ///   - input: The line the user typed.
    ///   - context: The object you use to write output and end the game.
    mutating func handle(input: String, context: AdventureGameContext) {
        // TODO: Parse the input and implement your game logic!
        context.write("You decide to \(input). It's not very effective.")
        // switch statement here
        // context.write("You have been eaten by a grue.")
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
EverestGame.display()
