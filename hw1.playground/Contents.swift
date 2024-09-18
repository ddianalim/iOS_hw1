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
    var weatherChecked: Bool = false
    
    init() {
        currentLocation = "Basecamp"
        gameState = .atBasecamp
        inventory = []
        
        locations = [
            "Basecamp": Location(name: "Basecamp", description: "You are at the Everest Basecamp. The journey begins here.", exits: ["north": "Camp I"], items: [Item(name: "Map", description: "A detailed map of the Everest route.")]),
            "Camp I": Location(name: "Camp I", description: "You've reached Camp I. The air is getting thinner.", exits: ["south": "Basecamp", "north": "Camp II"], items: [Item(name: "Weather Radio", description: "A device for checking current weather conditions.")]),
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
        context.write("Your journey begins at Basecamp. Good luck, and be careful!\n")
        showHelp(context: context)
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
        let components = input.lowercased().split(separator: " ", maxSplits: 1)
        let command = components.first.map(String.init)
        // Use optional
        let argument: String? = components.count > 1 ? String(components[1]) : nil

        switch command {
            case "north", "south", "east", "west":
                 move(direction: command!, context: context)
            case "look":
                 describeLocation(context: context)
            case "inventory":
                 showInventory(context: context)
            case "help":
                 showHelp(context: context)
            case "take":
                if let item = argument {
                    takeItem(name: item, context: context)
                } else {
                    context.write("Please specify the item you want to take.")
                }
            case "use":
                if let item = argument {
                    useItem(name: item, context: context)
                } else {
                    context.write("Please specify the item you want to use.")
                }
            case .none:
                context.write("Please enter a command.")
            case .some(_):
                context.write("That command doesn't exist. Type 'help' for a list of commands.")
        }
        // checkGameState(context: context)
    }
    
    // Functions that implement commands
    mutating func move(direction: String, context: AdventureGameContext) {
        if let nextLocation = locations[currentLocation]?.exits[direction] {
            if currentLocation == "Camp I" && nextLocation == "Camp II" && !weatherChecked {
                context.write("As you start moving towards Camp II, you hear a loud rumbling. Before you can react, an avalanche engulfs you.")
                context.write("Game Over: You were caught in an avalanche. Always check weather conditions before proceeding at high altitudes.")
                context.endGame()
            } else {
                currentLocation = nextLocation
                if let location = locations[currentLocation] {
                    context.write(location.description)
                }
//                describeLocation(context: context)
                checkGameState(context: context)
            }
        } else {
            context.write("You can't go that way.")
        }
    }
    
    mutating func describeLocation(context: AdventureGameContext) {
        if let location = locations[currentLocation] {
            if !location.items.isEmpty {
                context.write("You see the following items:")
                for item in location.items {
                    context.write("- \(item.name)")
                }
            }
//            context.write("Exits: \(location.exits.keys.joined(separator: ", "))")
            // TODO: use map shows exits?
        }
    }
    
    mutating func showInventory(context: AdventureGameContext) {
        if inventory.isEmpty {
            context.write("Your inventory is empty.")
        } else {
            context.write("Your inventory contains:")
            for item in inventory {
                context.write("- \(item.name)")
            }
        }
    }
    
    mutating func showHelp(context: AdventureGameContext) {
        context.write("Available commands:")
        context.write("- north, south, east, west: Move in a direction")
        context.write("- look: Examine your surroundings")
        context.write("- inventory: Check your inventory")
        context.write("- take [item]: Pick up an item")
        context.write("- use [item]: Use an item")
        context.write("- help: Show this help message")
    }
    
    mutating func takeItem(name: String, context: AdventureGameContext) {
        if var location = locations[currentLocation] {
            if let index = location.items.firstIndex(where: { $0.name.lowercased().contains(name.lowercased()) }) {
                let item = location.items.remove(at: index)
                inventory.append(item)
                locations[currentLocation] = location
                context.write("You have taken the \(item.name).")
            } else {
                context.write("There's no \(name) here to take.")
            }
        }
    }
    
    mutating func useItem(name: String, context: AdventureGameContext) {
        if let index = inventory.firstIndex(where: { $0.name.lowercased().contains(name.lowercased()) }) {
            let item = inventory[index]
            switch item.name {
            case "Map":
                context.write("You consult the map. It shows the route through the camps to the summit. The route to the summit of Mt. Everest starts at Basecamp and progresses through four higher camps: Camp I in the Western Cwm (at 6100m), Camp II at the foot of the Lhotse Face (at 6500m), Camp III on the Lhotse Face (at 7300m), and Camp IV in the Death Zone (at 7900m). From Camp IV, climbers ascend to the South Summit (at 8748m), navigate the treacherous Hillary Step, and finally reach the main summit (at 8848m). The journey is arduous and dangerous, with each section presenting unique challenges due to altitude, weather, and terrain.")
//                if let location = locations[currentLocation] {
//                    context.write("Exits: \(location.exits.keys.joined(separator: ", "))")
//                }
            case "Oxygen Tank":
                if currentLocation == "Camp IV" || currentLocation == "Summit" {
                    context.write("You use the oxygen tank. It helps you breathe in the thin air.")
                    inventory.remove(at: index)
                } else {
                    context.write("You use up one oxygen tank herew.")
                    inventory.remove(at: index)
                }
            case "Weather Radio":
                    weatherChecked = true
                    context.write("You check the weather conditions. The forecast shows stable weather for the next 24 hours.")
            default:
                context.write("You can't use the \(item.name) right now.")
            }
        } else {
            context.write("You don't have a \(name) in your inventory.")
        }
    }
    
    mutating func checkGameState(context: AdventureGameContext) {
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
EverestGame.display()
