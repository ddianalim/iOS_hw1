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
        return "Climbing Mt. Everest 🏔️"
    }
    
    var currentLocation: String
    var gameState: GameState
    var inventory: [Item]
    var locations: [String: Location]
    
    init() {
        currentLocation = "Basecamp"
        gameState = .atBasecamp
        inventory = []
        
        locations = [
            "Basecamp": Location(name: "Basecamp", description: "You are at the Everest Basecamp. The journey begins here.", exits: ["north": "Camp I"], items: [Item(name: "Map", description: "A detailed map of the Everest route.")]),
            "Camp I": Location(name: "Camp I", description: "You've reached Camp I. The air is getting thinner.", exits: ["south": "Basecamp", "north": "Camp II"], items: []),
            "Camp II": Location(name: "Camp II", description: "Welcome to Camp II. The summit looks closer, but it's still a long way.", exits: ["south": "Camp I", "north": "Camp III"], items: [Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes.")]),
            "Camp III": Location(name: "Camp III", description: "Camp III is the last stop before the death zone.", exits: ["south": "Camp II", "north": "Camp IV"], items: []),
            "Camp IV": Location(name: "Camp IV", description: "You're at Camp IV, the final camp before the summit push.", exits: ["south": "Camp III", "north": "Summit"], items: []),
            "Summit": Location(name: "Summit", description: "Congratulations! You've reached the summit of Mt. Everest!", exits: ["south": "Camp IV"], items: [])
            // TODO: add south summit and Hilary Step
        ]
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
        let components = input.lowercased().split(separator: " ")
        let command = components.first.map(String.init)
        // Use optional
        let argument: String? = components.dropFirst().first.map(String.init)

        switch command {
            case "north", "south", "east", "west":
                 move(direction: command!, context: context)
            case "look":
                 describeLocation(context: context)
            case "inventory":
                 showInventory(context: context)
            case "help":
                 showHelp(context: context)
//            case let itemName where command.hasPrefix("take "):
//                 takeItem(name: String(itemName.dropFirst(5)), context: context)
//            case let itemName where command.hasPrefix("use "):
//                 useItem(name: String(itemName.dropFirst(4)), context: context)
            case "take":
                if let item = argument {
                    takeItem(name: item, context: context)
                } else {
                    context.write("What do you want to take?")
                }
            case "use":
                if let item = argument {
                    useItem(name: item, context: context)
                } else {
                    context.write("What do you want to use?")
                }
            case .none:
                context.write("Please enter a command.")
            case .some(_):
                context.write("I don't understand that command. Type 'help' for a list of commands.")
        }
        // checkGameState(context: context)
    }
    
    // Functions that implement commands
    mutating func move(direction: String, context: AdventureGameContext) {
    }
    
    mutating func describeLocation(context: AdventureGameContext) {
    }
    
    mutating func showInventory(context: AdventureGameContext) {
    }
    
    mutating func showHelp(context: AdventureGameContext) {
    }
    
    mutating func takeItem(name: String, context: AdventureGameContext) {
    }
    
    mutating func useItem(name: String, context: AdventureGameContext) {
    }
    
    mutating func checkGameState(context: AdventureGameContext) {
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
EverestGame.display()
