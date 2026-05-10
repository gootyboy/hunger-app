import SwiftUI
import SwiftData

struct UserView: View {
    @Query var stores: [Store]
    @State var searchText = ""

    var filteredStores: [Store] {
        if searchText.isEmpty {
            return stores
        } else {
            return stores.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        if filteredStores.isEmpty {
                            ContentUnavailableView(
                                "No Stores Found",
                                systemImage: "storefront",
                                description: Text("Try searching for a different location name.")
                            )
                            .padding(.top, 40)
                        } else {
                            ForEach(filteredStores, id: \.self) { store in
                                StoreCardRow(store: store)
                            }
                        }
                    }
                    .padding(.top, 12)
                }
            }
            .navigationTitle("Stores")
            .navigationBarTitleDisplayMode(.large)
            
            // 2. FIXED: Use .topBarTrailing to preserve layout hierarchy
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: StoreMapView()) {
                        Image(systemName: "map.circle.fill")
                            .font(.title2) // Keeps standard header icon dimensions
                            .symbolRenderingMode(.hierarchical) // Professional tone shift from .multicolor
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: "Search for a store")
        }
    }
}
