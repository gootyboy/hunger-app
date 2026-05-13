import SwiftUI
import SwiftData

struct AddStoreView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State var locationManager = LocationManager()

    @State var storeName = ""
    @State var address = ""
    @State var city = ""
    @State var state = ""
    @State var zipCode = ""
    @State var country = ""
    
    @State var selectedItems: Set<String> = []
    @State var itemQuantities: [String: Int] = [:]

    let columns = [GridItem(.adaptive(minimum: 75))]
    
    var sortedStoreItems: [String] {
        return items
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("STORE INFO")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            
                            TextField("Store Name", text: $storeName)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("SELECT ITEMS (MULTI-SELECT)")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            
                            LazyVGrid(columns: columns, spacing: 15) {
                                ForEach(self.sortedStoreItems, id: \.self) { item in
                                    let isSelected = selectedItems.contains(item)
                                    let emoji = itemDict[item] ?? "?"
                                    
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
                            .padding(.top, 5)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) { // Fixed 'spacing: 12'
                            Text("SELECTED QUANTITIES")
                                .font(.caption.bold())
                                .foregroundStyle(.secondary)
                            
                            // Loop through the selected items from your grid
                            ForEach(Array(selectedItems), id: \.self) { item in
                                let currentCount = itemQuantities[item, default: 1] // Defaults to 1 when first selected
                                
                                HStack {
                                    Text(itemDict[item] ?? "?") // Shows the emoji
                                    Text(item)
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    // The Counter Control (- 0 +)
                                    HStack(spacing: 15) {
                                        Button {
                                            if currentCount > 0 {
                                                itemQuantities[item] = currentCount - 1
                                            }
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .font(.title2)
                                                .foregroundStyle(.blue)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        Text("\(currentCount)")
                                            .font(.body.bold())
                                            .frame(minWidth: 25)
                                            .multilineTextAlignment(.center)
                                        
                                        Button {
                                            itemQuantities[item] = currentCount + 1
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundStyle(.blue)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color(.systemGray6))
                                    .clipShape(Capsule())
                                }
                                Divider()
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("ADDRESS DETAILS")
                                    .font(.caption.bold())
                                    .foregroundStyle(.secondary)

                                Spacer()

                                Button {
                                    locationManager.requestLocation()
                                } label: {
                                    HStack(spacing: 4) {
                                        Image(systemName: "location.fill")
                                            .font(.caption)
                                        Text("Current Location")
                                            .font(.caption.bold())
                                    }
                                    .foregroundStyle(.blue)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 8)
                                    .background(Color.blue.opacity(0.1))
                                    .clipShape(Capsule())
                                }
                                .buttonStyle(.plain)
                            }

                            TextField("Street Address", text: $address)
                                .textFieldStyle(.roundedBorder)
                            TextField("City", text: $city)
                                .textFieldStyle(.roundedBorder)
                            
                            HStack(spacing: 12) {
                                TextField("State", text: $state)
                                    .textFieldStyle(.roundedBorder)
                                TextField("Zip Code", text: $zipCode)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            TextField("Country", text: $country)
                                .textFieldStyle(.roundedBorder)
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)

                        Button(action: saveStore) {
                            Text("Add Store")
                                .frame(maxWidth: .infinity)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        Spacer(minLength: 20)
                    }
                    .padding(.top, 15)
                }
            }
            .navigationTitle("Add Store")
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
            items: Array(selectedItems),
            quantities: itemQuantities
        )
        modelContext.insert(newStore)

        dismiss()
    }
}
