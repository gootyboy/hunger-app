import SwiftData
import SwiftUI

@Model
class Store {
    var name: String
    var address: String
    var city: String
    var state: String
    var zipCode: String
    var country: String
    var items: [String]
    var quantities: [String: Int]
    var id = UUID()

    init(name: String, address: String, city: String, state: String, zipCode: String, country: String, items: [String], quantities: [String: Int]) {
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.country = country
        self.items = items
        self.quantities = quantities
    }
}
