import SwiftUI
import SwiftData

struct StoreView: View {
    var body: some View {
        VStack {
            NavigationStack {
                NavigationLink(destination: AddStoreView()) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Add Store")
                    }
                }
            }
        }
        .scaledToFit()
        .navigationTitle("Store View")
        .buttonStyle(.borderedProminent)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets())
    }
}

struct AddStoreView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var locationManager = LocationManager()

    @State private var storeName = ""
    @State private var address = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = ""
    

    @State var selectedItems: Set<String> = []
    let items = ["Banana", "Apple", "Bread", "Donut", "Milk", "Cheese", "Pizza", "Coffee"]

    let columns = [GridItem(.adaptive(minimum: 75))]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Store Info")) {
                    TextField("Store Name", text: $storeName)
                }
                
                Section(header: Text("Select Items (Multi-select)")) {
                    LazyVGrid(columns: columns, spacing: 15) {
                        ForEach(items, id: \.self) { item in
                            let isSelected = selectedItems.contains(item)
                            let emoji = itemEmojis[item] ?? "?"
                            
                            VStack(spacing: 8) {
                                ZStack(alignment: .topTrailing) {
                                    Text(emoji)
                                        .font(.system(size: 40))
                                        .frame(width: 70, height: 70)
                                        .background(isSelected ? Color.blue.opacity(0.15) : Color(.systemGray6))
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                    
                                    if isSelected {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundStyle(.blue)
                                            .background(Circle().fill(.white))
                                            .offset(x: 5, y: -5)
                                            .transition(.scale)
                                    }
                                }
                                
                                Text(item)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                            }
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    if selectedItems.contains(item) {
                                        selectedItems.remove(item)
                                    } else {
                                        selectedItems.insert(item)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.vertical, 10)
                }

                Section(header: Text("Address Details")) {
                    TextField("Street Address", text: $address)
                    TextField("City", text: $city)
                    HStack {
                        TextField("State", text: $state)
                        Divider()
                        TextField("Zip Code", text: $zipCode)
                    }
                    TextField("Country", text: $country)
                }

                Button(action: saveStore) {
                    Text("Add Store")
                        .frame(maxWidth: .infinity)
                        .fontWeight(.bold)
                }
                .buttonStyle(.borderedProminent)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())
            }
            .navigationTitle("Add Store")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        locationManager.requestLocation()
                    } label: {
                        Label("Current Location", systemImage: "location.circle.fill")
                    }
                }
            }
            .task(id: locationManager.userAddress) {
                fillAddressFromLocation()
            }
        }
    }

    private func fillAddressFromLocation() {
        self.address = locationManager.userAddress
        self.city = locationManager.userCity
        self.state = locationManager.userState
        self.zipCode = locationManager.userZip
        self.country = locationManager.userCountry
    }

    private func saveStore() {
        let newStore = Store(
            name: storeName,
            address: address,
            city: city,
            state: state,
            zipCode: zipCode,
            country: country,
            items: Array(selectedItems)
        )
        modelContext.insert(newStore)
    }
}

