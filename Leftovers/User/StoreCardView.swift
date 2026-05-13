import SwiftUI

struct StoreCardRow: View {
    let store: Store
    let columns = [GridItem(.adaptive(minimum: 55))]

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                    Image(systemName: "mappin.and.ellipse")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        .symbolRenderingMode(.multicolor)
                }
                .frame(width: 40, height: 40)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    // Show address; remove raw dictionary from subtitle for a cleaner, more professional look.
                    Text("\(store.address), \(store.city)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            
            Divider()
            
            // Visual Inventory Grid Section
            VStack(alignment: .leading, spacing: 10) {
                Text("AVAILABLE LEFTOVERS")
                    .font(.caption2.bold())
                    .foregroundStyle(.secondary)
                    .tracking(0.5)
                
                if !store.items.isEmpty {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(store.items, id: \.self) { item in
                            let emoji = itemDict[item] ?? "📦"
                            let count = store.quantities[item, default: 0]
                            
                            ZStack(alignment: .topTrailing) {
                                // Emoji tile
                                VStack(spacing: 4) {
                                    Text(emoji)
                                        .font(.system(size: 24))
                                        .frame(width: 50, height: 50)
                                        .background(Color(.systemGroupedBackground))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                    
                                    Text(item)
                                        .font(.caption2)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                }
                                
                                // Quantity badge (always visible, including 0)
                                Text("\(count)")
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.vertical, 2)
                                    .padding(.horizontal, 6)
                                    .background(
                                        Circle()
                                            .fill(Color.blue)
                                    )
                                    .foregroundStyle(.white)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 1)
                                    )
                                    .offset(x: 8, y: -8)
                                    .accessibilityLabel("\(item) quantity \(count)")
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                } else {
                    Text("No active leftovers right now.")
                        .font(.footnote)
                        .italic()
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        .padding(.horizontal)
    }
}
