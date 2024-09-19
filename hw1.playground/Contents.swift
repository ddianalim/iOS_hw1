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

struct EverestGame: AdventureGame {
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
                 description: "You are at the Everest Basecamp (5300m). The journey begins here. 🏕️🥾",
                 weatherHint: "The weather can change rapidly in the mountains.",
                 oxygenHint: "At this altitude, your body is already adjusting to the thin air. Climbers spend weeks here acclimatizing before attempting higher camps.",
                 exits: ["north": "Camp I"],
                 items: [Item(name: "Map", description: mapDescription)],
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
    let mapDescription = """
    A detailed map of the Everest route. 🗺️
    ---------------------------------------
          🏔️ Summit (8848m)
            |
            | Hillary Step (8790m)
            |
        🏔️ South Summit (8748m)
            |
            |
    ⛺ Camp IV (7900m)---🛌 Sherpa Tent
            |
            |
    ⛺ Camp III (7300m)
            |
            |
     ⛺ Camp II (6500m)
            |
            |
     ⛺ Camp I (6100m)
            |
            |
      🏕️ Base Camp (5300m)
    ---------------------------------------
    Legend:
    🏔️ : Summit points
    ⛺ : Camps
    🛌 : Sherpa Tent
    🏕️ : Base Camp
    |  : Climbing route
    """
    
    mutating func start(context: AdventureGameContext) {
        context.write(formattedString("Welcome to the Mt. Everest Climbing Adventure!", .title, .semibold))
        context.write(formattedString("You are an experienced climber attempting to summit Mt. Everest. After weeks of preparation at Base Camp, your body has acclimatized to the high altitude. You've completed several trips up to Camp II and back, allowing your red blood cell count to increase. Now, you're ready to begin your push to the summit from Base Camp. 🏕️ Your journey begins here. Good luck, and be careful!\n", .info))
        showHelp(context: context)
    }
    
    mutating func handle(input: String, context: AdventureGameContext) {
        let components = input.lowercased().split(separator: " ", maxSplits: 1)
        let command = components.first.map(String.init)
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
                    context.write(formattedString("Please specify the item you want to take.", .error))
                }
            case "use":
                if let item = argument {
                    useItem(name: item, context: context)
                } else {
                    context.write(formattedString("Please specify the item you want to use.", .error))
                }
            case "examine":
                if let item = argument {
                    examineItem(name: item, context: context)
                } else {
                    context.write(formattedString("Please specify the item you want to examine.", .error))
                }
            case .none:
                context.write(formattedString("Please enter a command.", .error))
            case .some(_):
                context.write(formattedString("That command doesn't exist. Type 'help' for a list of commands.", .error))
        }
    }
    
    mutating func move(direction: String, context: AdventureGameContext) {
        guard let currentLocationInfo = locations[currentLocation] else {
            context.write(formattedString("Error: Current location not found.", .error))
            return
        }

        guard let nextLocation = currentLocationInfo.exits[direction],
              let nextLocationInfo = locations[nextLocation] else {
            context.write(formattedString("You can't go that way. Exits: \(currentLocationInfo.exits.keys.joined(separator: ", "))", .error))
            return
        }

        if currentLocationInfo.requiresWeatherCheck && !weatherChecked {
            context.write(formattedString("As you start moving towards \(nextLocation), you hear a loud rumbling. Before you can react, an avalanche engulfs you.", .narrative))
            context.write(formattedString("Game Over: You were caught in an avalanche. Always check weather conditions before proceeding from this location. ❄️☠️", .gameOver))
            context.endGame()
            return
        }

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
                context.write(formattedString("You take a moment to rest on the comfortable bed. You can feel your strength returning, preparing you for the descent ahead.", .narrative))
            }
        default:
            break
        }

        currentLocation = nextLocation
        context.write(formattedString(nextLocationInfo.description, .narrative))
        weatherChecked = false
        checkGameState(context: context)
        
        if isHighAltitude(location: currentLocation) || isHighAltitude(location: nextLocation) {
            if !hasUsedOxygen {
                context.write(formattedString("The air is too thin to move safely. Use an oxygen tank before moving.", .warning))
            }
            hasUsedOxygen = false
        }
    }

    private func isHighAltitude(location: String) -> Bool {
        return location == "Camp IV" || location.contains("Summit") || location == "Hillary Step"
    }

    private mutating func useOxygenTank(context: AdventureGameContext) -> Bool {
        if let oxygenIndex = inventory.firstIndex(where: { $0.name == "Oxygen Tank" }) {
            inventory.remove(at: oxygenIndex)
            context.write(formattedString("You use an oxygen tank for this move.", .action))
            return true
        } else {
            context.write(formattedString("You don't have any oxygen tanks left. You can't proceed safely at this altitude.", .narrative))
            context.write(formattedString("Game Over: You ran out of oxygen. 😵💨", .gameOver))
            context.endGame()
            return false
        }
    }

    private mutating func handleHillaryStepClimb(context: AdventureGameContext) -> Bool {
        if !inventory.contains(where: { $0.name == "Rope" }) {
            context.write(formattedString("You attempt to climb the Hillary Step without a rope. It's an extremely dangerous move. You lose your footing and fall. The fall is fatal.", .narrative))
            context.write(formattedString("Game Over: Always ensure you have proper equipment before attempting dangerous climbs. 🧗‍♂️💀", .gameOver))
            context.endGame()
            return false
        } else {
            context.write(formattedString("You affix the rope to the remaining 500 meters of the climb. Installing rope lines helps you safely navigate the Hillary Step.", .action))
            return true
        }
    }

    private func handleDescentFromCampIV(context: AdventureGameContext) -> Bool {
        if hasReachedSummit && !hasRestedDuringDescent {
            context.write(formattedString("As you attempt to descend from Camp IV to Camp III, exhaustion overtakes you. Your body, pushed to its limits by the summit climb, gives out. You collapse on the mountain.", .narrative))
            context.write(formattedString("Game Over: Always rest and recover at the Sherpa Tent before attempting the long descent. 😴💀", .gameOver))
            context.endGame()
            return false
        }
        return true
    }
    
    mutating func describeLocation(context: AdventureGameContext) {
        if let location = locations[currentLocation] {
            var message = "You're at \(location.name).\n"
            message += location.weatherHint

            if !location.items.isEmpty {
                message += "\nYou see the following items:"
                context.write(formattedString(message, .info))
                for item in location.items {
                    context.write(formattedString(" - \(item.name)", .info))
                }
            } else {
                message += "\nYou don't see any items here."
                context.write(formattedString(message, .info))
            }
        }
    }
    
    mutating func showInventory(context: AdventureGameContext) {
        if inventory.isEmpty {
            context.write(formattedString("Your inventory is empty.", .info))
        } else {
            context.write(formattedString("Your inventory contains:", .info))
            for item in inventory {
                context.write(formattedString("- \(item.name)", .info))
            }
        }
    }
    
    mutating func showHelp(context: AdventureGameContext) {
        context.write(formattedString("Available commands:", .subtitle, .semibold))
        let commands = """
         - north, south, east, west: Move in a direction
         - look: Examine your surroundings
         - inventory: Check your inventory
         - take [item]: Pick up an item
         - use [item]: Use an item
         - examine [item]: Examine an item closely
         - help: Show this help message
        """
        context.write(formattedString(commands, .info))
        
        context.write(formattedString("Color Guide for Game Messages:", .subtitle, .semibold))
        context.write(formattedString(" - New information messages (e.g., \"Your inventory is empty\")", .info))
        context.write(formattedString(" - Narrative messages (e.g., \"It shows the route through the camps\")", .narrative))
        context.write(formattedString(" - Action messages (e.g., \"You use an oxygen tank\")", .action))
        context.write(formattedString(" - Critical warnings and game over messages", .error))
        context.write(formattedString(" - Summit achievement and victory messages", .success))
    }
    
    mutating func takeItem(name: String, context: AdventureGameContext) {
        if var location = locations[currentLocation] {
            if let index = location.items.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
                let item = location.items.remove(at: index)
                inventory.append(item)
                locations[currentLocation] = location
                context.write(formattedString("You have taken the \(item.name).", .action))
            } else {
                context.write(formattedString("There's no \(name) here to take.", .error))
            }
        }
    }
    
    mutating func useItem(name: String, context: AdventureGameContext) {
        if let index = inventory.firstIndex(where: { $0.name.lowercased() == name.lowercased() }) {
            let item = inventory[index]
            switch item.name {
                case "Map":
                    context.write(formattedString("You consult the map.", .action))
                    let mapInfo = """
                    It shows the route through the camps to the summit. The route to the summit of Mt. Everest starts at Basecamp and progresses through four higher camps: Camp I in the Western Cwm (at 6100m), Camp II at the foot of the Lhotse Face (at 6500m), Camp III on the Lhotse Face (at 7300m), and Camp IV in the Death Zone (at 7900m). From Camp IV, climbers ascend to the South Summit (at 8748m), navigate the treacherous Hillary Step, and finally reach the main summit (at 8848m). The journey is arduous and dangerous, with each section presenting unique challenges due to altitude, weather, and terrain. 🗺️
                    At the bottom of the map, you see the following text:
                    """
                    context.write(formattedString(mapInfo, .narrative))
                    context.write(formattedString("NOTE: At high altitudes (Camp IV and above), you must use an oxygen tank before each move.", .warning))
                case "Oxygen Tank":
                    if isHighAltitude(location: currentLocation) {
                        context.write(formattedString("You use the oxygen tank. It helps you breathe in the thin air.", .action))
                        inventory.remove(at: index)
                        hasUsedOxygen = true
                    } else {
                        context.write(formattedString("You don't need to use the oxygen tank here. Save it for higher altitudes.", .info))
                    }
                case "Weather Radio":
                    weatherChecked = true
                    context.write(formattedString("You check the weather conditions. The forecast shows stable weather for the next 24 hours.", .action))
                    context.write(formattedString("You've successfully checked the weather and can proceed safely.", .info))
                default:
                    context.write(formattedString("You can't use the \(item.name) right now.", .info))
            }
        } else {
            context.write(formattedString("You don't have a \(name) in your inventory.", .error))
        }
    }
    
    mutating func checkGameState(context: AdventureGameContext) {
        switch currentLocation {
        case "Summit":
            if gameState != .atSummit {
                gameState = .atSummit
                context.write(formattedString("You take in the breathtaking view from the top of the world! 😲🌎", .success))
                context.write(formattedString("As you bask in your achievement, you can't help but think about the challenging descent ahead. The journey is only half over, and you'll need all your strength for the way down. 💪", .narrative))
            }
        case "Hillary Step":
            if gameState == .atSummit {
                gameState = .descending
                context.write(formattedString("You've started your descent from the summit. Be careful on your way down.", .narrative))
            }
        case "Camp IV":
            if !inventory.contains(where: { $0.name == "Oxygen Tank" }) {
                context.write(formattedString("You're in the death zone without a full oxygen tank. The lack of oxygen is fatal.", .narrative))
                context.write(formattedString("Game Over: You didn't survive the climb.", .gameOver))
                context.endGame()
            }
        case "Basecamp":
            if gameState == .descending {
                context.write(formattedString("You've successfully returned to Base Camp. Congratulations on your Everest expedition! 🎊🏅", .success))
                context.endGame()
            }
        default:
            if gameState == .atSummit {
                gameState = .descending
            }
        }
    }
    
    mutating func examineItem(name: String, context: AdventureGameContext) {
        if let item = inventory.first(where: { $0.name.lowercased() == name.lowercased() }) {
            context.write(formattedString(item.description, .info))
        } else if let location = locations[currentLocation],
                  let item = location.items.first(where: { $0.name.lowercased() == name.lowercased() }) {
            context.write(formattedString(item.description, .info))
        } else {
            context.write(formattedString("You don't see a \(name) here. 🔍", .error))
        }
    }

    // Helper function for formatting strings
    private func formattedString(_ text: String, _ style: TextStyle, _ weight: Font.Weight = .regular) -> AttributedString {
        var attributedString = AttributedString(text)
        attributedString.swiftUI.font = .system(size: style.fontSize, weight: weight, design: .serif)
        attributedString.swiftUI.foregroundColor = style.color
        return attributedString
    }
}

// Enum for text styles
private enum TextStyle {
    case title
    case narrative
    case info
    case action
    case warning
    case error
    case gameOver
    case success
    case subtitle

    var fontSize: CGFloat {
        switch self {
        case .title: return 28
        case .subtitle: return 16
        case .gameOver, .success: return 16
        default: return 13
        }
    }

    var color: Color {
        switch self {
        case .title: return .blue
        case .narrative: return .orange
        case .info: return .yellow
        case .action: return .blue
        case .warning: return .yellow
        case .error: return .red
        case .gameOver: return .red
        case .success: return .green
        case .subtitle: return .white
        }
    }
    }

    // This line sets up the UI
    EverestGame.display()
