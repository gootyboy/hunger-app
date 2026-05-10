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
