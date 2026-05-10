import SwiftUI

let itemDict: [String: String] = [
    "Banana": "🍌",
    "Apple": "🍎",
    "Bread": "🍞",
    "Donut": "🍩",
    "Milk": "🥛",
    "Cheese": "🧀",
    "Pizza": "🍕",
    "Coffee": "☕️"
]

let itemEmojis = itemDict.sorted { $0.key < $1.key }

var items: [String] {
    itemEmojis.map { $0.key }
}
