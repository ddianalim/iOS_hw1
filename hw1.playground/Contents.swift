import SwiftUI

struct Location {
    let name: String
    let description: String
    let weatherHint: String
    let oxygenHint: String
    var exits: [String: String]
    var items: [Item]
    let requiresWeatherCheck: Bool
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
    var hasReachedSummit: Bool = false
    var hasRestedDuringDescent: Bool = false
    var hasUsedOxygen: Bool = false
    
    init() {
        currentLocation = "Basecamp"
        gameState = .atBasecamp
        inventory = []
        locations = [
             "Basecamp": Location(
                 name: "Basecamp",
                 description: "You are at the Everest Basecamp (5300m). The journey begins here. 🥾",
                 weatherHint: "The weather can change rapidly in the mountains.",
                 oxygenHint: "At this altitude, your body is already adjusting to the thin air. Climbers spend weeks here acclimatizing before attempting higher camps.",
                 exits: ["north": "Camp I"],
                 items: [Item(name: "Map", description: "A detailed map of the Everest route. 🗺️")],
                 requiresWeatherCheck: false
             ),
             "Camp I": Location(
                 name: "Camp I",
                 description: "You've reached Camp I. The air is getting thinner. (6100m)",
                 weatherHint: "The route ahead through the Western Cwm is known for its unpredictable weather. A thorough weather check could prevent disaster.",
                 oxygenHint: "The air here contains about 47% of the oxygen available at sea level. Your body is working harder to compensate.",
                 exits: ["south": "Basecamp", "north": "Camp II"],
                 items: [Item(name: "Weather Radio", description: "A device for checking current weather conditions. 📻")],
                 requiresWeatherCheck: true
             ),
             "Camp II": Location(
                 name: "Camp II",
                 description: "You're at Camp II. The summit looks closer, but it's still a long way. (6500m)",
                 weatherHint: "The Lhotse Face ahead is exposed to high winds.",
                 oxygenHint: "At this altitude, you're beginning to feel the effects of hypoxia. Many climbers start using supplemental oxygen from Camp III or IV.",
                 exits: ["south": "Camp I", "north": "Camp III"],
                 items: [],
                 requiresWeatherCheck: false
             ),
             "Camp III": Location(
                 name: "Camp III",
                 description: "Welcome to Camp III. This is the last stop before the death zone. (7300m) ☠️",
                 weatherHint: "You're entering the death zone soon. Weather conditions can deteriorate quickly at this altitude. A final check before the push to Camp IV is essential.",
                 oxygenHint: "You'll need oxygen tanks for each move above this point. Make sure you have enough for the journey up and down.",
                 exits: ["south": "Camp II", "north": "Camp IV"],
                 items: [Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes.")],
                 requiresWeatherCheck: true
             ),
             "Camp IV": Location(
                 name: "Camp IV",
                 description: "You're at Camp IV, the final camp before the summit push. The air is dangerously thin here. To the west, you notice a Sherpa tent where climbers often prepare for the final ascent or recover after summiting. (7900m) ⛺️",
                 weatherHint: "The weather window for a summit attempt is crucial.",
                 oxygenHint: "You are now in the death zone. Your body is slowly dying at this altitude. Use an oxygen tank for every move from here on.",
                 exits: ["south": "Camp III", "north": "South Summit", "west": "Sherpa Tent"],
                 items: [],
                 requiresWeatherCheck: false
             ),
             "Sherpa Tent": Location(
                 name: "Sherpa Tent",
                 description: "You hike to a small tent used by Sherpas. It contains supplies and a comfortable-looking bed. 🛌",
                 weatherHint: "Even from inside the tent, you can hear the wind howling. It would be wise to check the conditions before venturing out.",
                 oxygenHint: "There are oxygen tanks here. Remember, you'll need one for each move at this altitude.",
                 exits: ["east": "Camp IV"],
                 items: [Item(name: "Rope", description: "A sturdy rope, essential for navigating treacherous parts of the climb. 🧵"),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes.")],
                 requiresWeatherCheck: true
             ),
             "South Summit": Location(
                 name: "South Summit",
                 description: "You're at the South Summit. The main summit is tantalizingly close, but the most dangerous part lies ahead. (8748m)",
                 weatherHint: "The final push to the summit is extremely weather-dependent.",
                 oxygenHint: "This is your last chance to get oxygen before the final push. Make sure you have enough for the return journey.",
                 exits: ["south": "Camp IV", "east": "Hillary Step"],
                 items: [Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes."),
                         Item(name: "Oxygen Tank", description: "An extra oxygen tank for high altitudes.")],
                 requiresWeatherCheck: false
             ),
             "Hillary Step": Location(
                 name: "Hillary Step",
                 description: "You're at the Hillary Step, a near-vertical rock face. This is the last major challenge before the summit. 🧗‍♂️",
                 weatherHint: "The exposed nature of the Hillary Step makes it vulnerable to sudden weather changes. Be absolutely sure of the conditions before proceeding.",
                 oxygenHint: "The oxygen level here is only 33% of that at sea level. Every breath is a struggle. Make sure you have enough oxygen for the final push and return.",
                 exits: ["west": "South Summit", "north": "Summit"],
                 items: [],
                 requiresWeatherCheck: true
             ),
             "Summit": Location(
                 name: "Summit",
                 description: "Congratulations! You've reached the summit of Mt. Everest! (8848m) 🎉🏆",
                 weatherHint: "Even at the top, the weather remains a critical factor. Check the conditions for a safe descent - the journey is only half over.",
                 oxygenHint: "You've made it to the top! But remember, you still need oxygen for the descent. Start heading down before your supply runs out.",
                 exits: ["south": "Hillary Step"],
                 items: [],
                 requiresWeatherCheck: false
             )
         ]
    }
    
    /// Runs at the start of every game.
    ///
    /// Use this function to introduce the game to the player.
    ///
    /// - Parameter context: The object you use to write output and end the game.
    mutating func start(context: AdventureGameContext) {
        var welcomeMessage = AttributedString("Welcome to the Mt. Everest Climbing Adventure!")
        welcomeMessage.swiftUI.font = .system(size: 28, weight: .bold, design: .serif)
        welcomeMessage.swiftUI.foregroundColor = .blue
        context.write(welcomeMessage)

        var introMessage = AttributedString("You are an experienced climber attempting to summit Mt. Everest. After weeks of preparation at Base Camp, your body has acclimatized to the high altitude. You've completed several trips up to Camp II and back, allowing your red blood cell count to increase. Now, you're ready to begin your push to the summit from Base Camp. Your journey begins here. Good luck, and be careful!\n")
        introMessage.swiftUI.font = .system(size: 14, weight: .regular, design: .serif)
        introMessage.swiftUI.foregroundColor = .orange
        context.write(introMessage)
        showHelp(context: context)
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
            case "examine":
                if let item = argument {
                    examineItem(name: item, context: context)
                } else {
                    context.write("Please specify the item you want to examine.")
                }
            case .none:
                context.write("Please enter a command.")
            case .some(_):
                context.write("That command doesn't exist. Type 'help' for a list of commands.")
        }
    }
    
    // Functions that implement commands
    mutating func move(direction: String, context: AdventureGameContext) {
        guard let currentLocationInfo = locations[currentLocation] else {
            context.write("Error: Current location not found.")
            return
        }

        guard let nextLocation = currentLocationInfo.exits[direction],
              let nextLocationInfo = locations[nextLocation] else {
            var wrongWayMessage = AttributedString("You can't go that way. Exits: \(currentLocationInfo.exits.keys.joined(separator: ", "))")
            wrongWayMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            wrongWayMessage.swiftUI.foregroundColor = .yellow
            return
        }

        // Check weather if required
        if currentLocationInfo.requiresWeatherCheck && !weatherChecked {
            var avalancheMessage = AttributedString("As you start moving towards \(nextLocation), you hear a loud rumbling. Before you can react, an avalanche engulfs you.")
            avalancheMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            avalancheMessage.swiftUI.foregroundColor = .orange
            context.write(avalancheMessage)
            
            var gameOverWeatherMessage = AttributedString("Game Over: You were caught in an avalanche. Always check weather conditions before proceeding from this location. ❄️☠️")
            gameOverWeatherMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
            gameOverWeatherMessage.swiftUI.foregroundColor = .red
            context.write(gameOverWeatherMessage)
            
            context.endGame()
            return
        }

        // Handle special location interactions
        switch (currentLocation, nextLocation) {
        case ("Hillary Step", "Summit"):
            if !handleHillaryStepClimb(context: context) {
                return
            }
        case ("Summit", _):
            hasReachedSummit = true
            hasRestedDuringDescent = false
        case ("Camp IV", "Camp III"):
            if !handleDescentFromCampIV(context: context) {
                return
            }
        case ("Sherpa Tent", _):
            if hasReachedSummit {
                hasRestedDuringDescent = true
                context.write("You take a moment to rest on the comfortable bed. You can feel your strength returning, preparing you for the descent ahead.")
            }
        default:
            break
        }

        // Move to next location
        currentLocation = nextLocation
        var nextLocationMessage = AttributedString(nextLocationInfo.description)
        nextLocationMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        nextLocationMessage.swiftUI.foregroundColor = .orange
        context.write(nextLocationMessage)
        weatherChecked = false
        checkGameState(context: context)
        
        // Check if player has used oxygen for high-altitude moves
        if isHighAltitude(location: currentLocation) || isHighAltitude(location: nextLocation) {
            if !hasUsedOxygen {
                var oxygenMessage = AttributedString("The air is too thin to move safely. Use an oxygen tank before moving.")
                oxygenMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                oxygenMessage.swiftUI.foregroundColor = .yellow
                context.write(oxygenMessage)
            }
            hasUsedOxygen = false // resets for next move
        }
    }

    // Helper functions
    private func isHighAltitude(location: String) -> Bool {
        return location == "Camp IV" || location.contains("Summit") || location == "Hillary Step"
    }

    private mutating func useOxygenTank(context: AdventureGameContext) -> Bool {
        if let oxygenIndex = inventory.firstIndex(where: { $0.name == "Oxygen Tank" }) {
            inventory.remove(at: oxygenIndex)
            var useOxygenMessage = AttributedString("You use an oxygen tank for this move.")
            useOxygenMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            useOxygenMessage.swiftUI.foregroundColor = .blue
            context.write(useOxygenMessage)
            return true
        } else {
            var noOxygenMessage = AttributedString("You don't have any oxygen tanks left. You can't proceed safely at this altitude.")
            noOxygenMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            noOxygenMessage.swiftUI.foregroundColor = .orange
            context.write(noOxygenMessage)
            
            var gameOverNoOxygenMessage = AttributedString("Game Over: You ran out of oxygen. 😵💨")
            gameOverNoOxygenMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
            gameOverNoOxygenMessage.swiftUI.foregroundColor = .red
            context.write(gameOverNoOxygenMessage)
            
            context.endGame()
            return false
        }
    }

    private mutating func handleHillaryStepClimb(context: AdventureGameContext) -> Bool {
        if !inventory.contains(where: { $0.name == "Rope" }) {
            var climbMessage = AttributedString("You attempt to climb the Hillary Step without a rope. It's an extremely dangerous move. You lose your footing and fall. The fall is fatal.")
            climbMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            climbMessage.swiftUI.foregroundColor = .orange
            context.write(climbMessage)
            
            var gameOverFallMessage = AttributedString("Game Over: Always ensure you have proper equipment before attempting dangerous climbs. 🧗‍♂️💀")
            gameOverFallMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
            gameOverFallMessage.swiftUI.foregroundColor = .red
            context.write(gameOverFallMessage)
            
            context.endGame()
            return false
        } else {
            var ropeMessage = AttributedString("You affix the rope to the remaining 500 meters of the climb. Installing rope lines helps you safely navigate the Hillary Step.")
            ropeMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            ropeMessage.swiftUI.foregroundColor = .blue
            context.write(ropeMessage)
            return true
        }
    }

    private func handleDescentFromCampIV(context: AdventureGameContext) -> Bool {
        if hasReachedSummit && !hasRestedDuringDescent {
            var exhaustionMessage = AttributedString("As you attempt to descend from Camp IV to Camp III, exhaustion overtakes you. Your body, pushed to its limits by the summit climb, gives out. You collapse on the mountain.")
            exhaustionMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            exhaustionMessage.swiftUI.foregroundColor = .orange
            context.write(exhaustionMessage)
            
            var gameOverRestMessage = AttributedString("Game Over: Always rest and recover at the Sherpa Tent before attempting the long descent. 😴💀")
            gameOverRestMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
            gameOverRestMessage.swiftUI.foregroundColor = .red
            context.write(gameOverRestMessage)
            
            context.endGame()
            return false
        }
        return true
    }
    
    mutating func describeLocation(context: AdventureGameContext) {
        if let location = locations[currentLocation] {
            var locationMessage = AttributedString("You're at \(location.name).")

            if !location.items.isEmpty {
                locationMessage += AttributedString(location.weatherHint)
                locationMessage += ("\nYou see the following items:")
                locationMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                locationMessage.swiftUI.foregroundColor = .yellow
                context.write(locationMessage)
                for item in location.items {
                    context.write(" - \(item.name)")
                }
            }
            else {
                locationMessage = AttributedString("You don't see any items here.")
                locationMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                locationMessage.swiftUI.foregroundColor = .yellow
                context.write(locationMessage)
            }
        }
    }
    
    mutating func showInventory(context: AdventureGameContext) {
        var inventoryMessage = AttributedString()
        if inventory.isEmpty {
            inventoryMessage = AttributedString("Your inventory is empty.")
            inventoryMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            inventoryMessage.swiftUI.foregroundColor = .yellow
            context.write(inventoryMessage)
            
        } else {
            inventoryMessage = AttributedString("Your inventory contains:")
            inventoryMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            inventoryMessage.swiftUI.foregroundColor = .yellow
            context.write(inventoryMessage)
            for item in inventory {
                context.write("- \(item.name)")
        }
        }
    }
    
    mutating func showHelp(context: AdventureGameContext) {
        
        var commandsMessage = AttributedString("Available commands:")
        commandsMessage.swiftUI.font = .system(size: 14, weight: .semibold, design: .serif)
        commandsMessage.swiftUI.foregroundColor = .yellow
        context.write(commandsMessage)
        context.write("- north, south, east, west: Move in a direction")
        context.write("- look: Examine your surroundings")
        context.write("- inventory: Check your inventory")
        context.write("- take [item]: Pick up an item")
        context.write("- use [item]: Use an item")
        context.write("- examine [item]: Examine an item closely")
        context.write("- help: Show this help message\n")
        
        var colorExplanationTitle = AttributedString("Color Guide for Game Messages:")
        colorExplanationTitle.swiftUI.font = .system(size: 14, weight: .semibold, design: .serif)
        colorExplanationTitle.swiftUI.foregroundColor = .white
        context.write(colorExplanationTitle)

        var infoColorExplanation = AttributedString(" - New information messages (e.g., \"Your inventory is empty\")")
        infoColorExplanation.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        infoColorExplanation.swiftUI.foregroundColor = .yellow
        context.write(infoColorExplanation)

        var narrativeColorExplanation = AttributedString(" - Narrative messages (e.g., \"It shows the route through the camps\")")
        narrativeColorExplanation.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        narrativeColorExplanation.swiftUI.foregroundColor = .orange
        context.write(narrativeColorExplanation)

        var actionColorExplanation = AttributedString("- Action messages (e.g., \"You use an oxygen tank\")")
        actionColorExplanation.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        actionColorExplanation.swiftUI.foregroundColor = .blue
        context.write(actionColorExplanation)

        var warningColorExplanation = AttributedString(" - Critical warnings and game over messages")
        warningColorExplanation.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        warningColorExplanation.swiftUI.foregroundColor = .red
        context.write(warningColorExplanation)
        
        var victoryColorExplanation = AttributedString("- Summit achievement and victory messages")
        victoryColorExplanation.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        victoryColorExplanation.swiftUI.foregroundColor = .green
        context.write(victoryColorExplanation)
    }
    
    mutating func takeItem(name: String, context: AdventureGameContext) {
        var itemMessage = AttributedString()
        if var location = locations[currentLocation] {
            if let index = location.items.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
                let item = location.items.remove(at: index)
                inventory.append(item)
                locations[currentLocation] = location
                itemMessage = AttributedString("You have taken the \(item.name).")
            } else {
                itemMessage = AttributedString("There's no \(name) here to take.")
            }
            itemMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            itemMessage.swiftUI.foregroundColor = .yellow
            context.write(itemMessage)
        }
    }
    
    mutating func useItem(name: String, context: AdventureGameContext) {
        if let index = inventory.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            let item = inventory[index]
            switch item.name {
                case "Map":
                    var mapMessage = AttributedString("You consult the map.")
                    mapMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                    mapMessage.swiftUI.foregroundColor = .blue
                    context.write(mapMessage)  
                    mapMessage = AttributedString("It shows the route through the camps to the summit. The route to the summit of Mt. Everest starts at Basecamp and progresses through four higher camps: Camp I in the Western Cwm (at 6100m), Camp II at the foot of the Lhotse Face (at 6500m), Camp III on the Lhotse Face (at 7300m), and Camp IV in the Death Zone (at 7900m). From Camp IV, climbers ascend to the South Summit (at 8748m), navigate the treacherous Hillary Step, and finally reach the main summit (at 8848m). The journey is arduous and dangerous, with each section presenting unique challenges due to altitude, weather, and terrain. 🗺️ \nAt the bottom of the map, you see the following text:\n")
                    mapMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                    mapMessage.swiftUI.foregroundColor = .orange
                    context.write(mapMessage)
                    var importantMessage = AttributedString("NOTE: At high altitudes (Camp IV and above), you must use an oxygen tank before each move.\n")
                    importantMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
                    importantMessage.swiftUI.foregroundColor = .red
                    context.write(importantMessage)
                case "Oxygen Tank":
                    if isHighAltitude(location: currentLocation) {
                        var useOxygenMessage = AttributedString("You use the oxygen tank. It helps you breathe in the thin air.")
                        useOxygenMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                        useOxygenMessage.swiftUI.foregroundColor = .blue
                        context.write(useOxygenMessage)
                        inventory.remove(at: index)
                        hasUsedOxygen = true
                    } else {
                        var saveOxygenMessage = AttributedString("You don't need to use the oxygen tank here. Save it for higher altitudes.")
                        saveOxygenMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                        saveOxygenMessage.swiftUI.foregroundColor = .yellow
                        context.write(saveOxygenMessage)
                    }
                case "Weather Radio":
                weatherChecked = true
                    var checkWeatherMessage = AttributedString("You check the weather conditions. The forecast shows stable weather for the next 24 hours.")
                    checkWeatherMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                    checkWeatherMessage.swiftUI.foregroundColor = .blue
                    context.write(checkWeatherMessage)
                    
                    var safetyMessage = AttributedString("You've successfully checked the weather and can proceed safely.")
                    safetyMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                    safetyMessage.swiftUI.foregroundColor = .yellow
                    context.write(safetyMessage)
                default:
                    var cannotUseMessage = AttributedString("You can't use the \(item.name) right now.")
                    cannotUseMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                    cannotUseMessage.swiftUI.foregroundColor = .yellow
                    context.write(cannotUseMessage)
            }
        } else {
            var noItemMessage = AttributedString("You don't have a \(name) in your inventory.")
            noItemMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
            noItemMessage.swiftUI.foregroundColor = .yellow
            context.write(noItemMessage)
        }
    }
    
    mutating func checkGameState(context: AdventureGameContext) {
        switch currentLocation {
        case "Summit":
            if gameState != .atSummit {
                gameState = .atSummit
                var summitMessage = AttributedString("You take in the breathtaking view from the top of the world! 😲🌎")
                summitMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                summitMessage.swiftUI.foregroundColor = .green
                context.write(summitMessage)

                var descentMessage = AttributedString("As you bask in your achievement, you can't help but think about the challenging descent ahead. The journey is only half over, and you'll need all your strength for the way down. 💪")
                descentMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                descentMessage.swiftUI.foregroundColor = .orange
                context.write(descentMessage)
            }
        case "Hillary Step":
            if gameState == .atSummit {
                gameState = .descending
                var descentMessage = AttributedString("You've started your descent from the summit. Be careful on your way down.")
                descentMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                descentMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                descentMessage.swiftUI.foregroundColor = .orange
                context.write(descentMessage)            }
        case "Camp IV":
            if !inventory.contains(where: { $0.name == "Oxygen Tank" }) {
                var deathZoneMessage = AttributedString("You're in the death zone without a full oxygen tank. The lack of oxygen is fatal.")
                deathZoneMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
                deathZoneMessage.swiftUI.foregroundColor = .orange
                context.write(deathZoneMessage)
                
                var gameOverOxygenMessage = AttributedString("Game Over: You didn't survive the climb.")
                gameOverOxygenMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
                gameOverOxygenMessage.swiftUI.foregroundColor = .red
                context.write(gameOverOxygenMessage)
                context.endGame()
            }
        case "Basecamp":
            if gameState == .descending {
                var victoryMessage = AttributedString("You've successfully returned to Basecamp. Congratulations on your Everest expedition! 🎊🏅")
                victoryMessage.swiftUI.font = .system(size: 16, weight: .bold, design: .serif)
                victoryMessage.swiftUI.foregroundColor = .green
                context.write(victoryMessage)
                context.endGame()
            }
        default:
            if gameState == .atSummit {
                gameState = .descending
            }
        }
    }
    
    mutating func examineItem(name: String, context: AdventureGameContext) {
        var itemMessage = AttributedString()
        if let index = inventory.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            let item = inventory[index]
            itemMessage = AttributedString(item.description)
        } else if let location = locations[currentLocation],
              let index = location.items.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            let item = location.items[index]
            itemMessage = AttributedString(item.description)
        } else {
            itemMessage = AttributedString("You don't see a \(name) here. 🔍")
        }
        itemMessage.swiftUI.font = .system(size: 13, weight: .regular, design: .serif)
        itemMessage.swiftUI.foregroundColor = .yellow
        context.write(itemMessage)
    }
}

// Leave this line in - this line sets up the UI you see on the right.
// Update this if you rename your AdventureGame implementation.
EverestGame.display()
