import SwiftUI
import SwiftData

struct ContentView: View {
    @State var perks = [
        "Distribution",
        "Storage",
        "Food Spoilage",
        "Retail & Restaurant Waste",
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {

                        VStack(alignment: .leading) {
                            Text("How are you joining today?")
                                .font(.title2.bold())
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top, 20)

                        HStack(spacing: 20) {
                            RoleCard(
                                title: "Store Owner",
                                subtitle: "Manage inventory",
                                icon: "storefront.fill",
                                destination: StoreView()
                            )
                            RoleCard(
                                title: "Individual",
                                subtitle: "Find leftovers",
                                icon: "person.fill",
                                destination: UserView()
                            )
                        }
                        .padding(.horizontal)

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "globe.americas.fill")
                                    .foregroundStyle(.blue)
                                Text("World Hunger")
                                    .font(.title3.bold())
                            }
                            Text("Around 1/3 of all the food produced in the world is not eaten.")
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)
                                .font(.footnote.bold())
                            Text("At the same time, many people experience food insecurity. It is most often caused by:")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                                .lineSpacing(4)

                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(perks, id: \.self) { perk in
                                    Label {
                                        Text(perk)
                                            .font(.footnote)
                                            .fontWeight(.medium)
                                    } icon: {
                                        Image(systemName: "circle.fill")
                                            .font(.system(size: 5))
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                            .padding(.leading, 4)
                            
                            Divider()
                            
                            HStack(spacing: 15) {
                                Image(systemName: "fork.knife")
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.blue.gradient)
                                    .clipShape(Circle())

                                Text("This app tries to help solve this problem by reducing the amount of food wastage by distribution.")
                                    .font(.footnote.weight(.medium))
                                    .italic()
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue.opacity(0.05))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .strokeBorder(Color.blue.opacity(0.2), lineWidth: 1.5)
                            )
                            .padding(.horizontal)

                        }
                        .padding(10)
                        .background(Color(.secondarySystemGroupedBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 5)
                        .padding(.horizontal)

                        Spacer(minLength: 30)
                    }
                }
            }
            .navigationTitle("Leftovers")
        }
    }
}

struct RoleCard<Destination: View>: View {
    let title: String
    let subtitle: String
    let icon: String
    let destination: Destination

    var body: some View {
        NavigationLink(destination: destination) {
            VStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.blue.opacity(0.1))
                    
                    Image(systemName: icon)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.blue)
                }
                .frame(width: 70, height: 70)
                
                VStack(spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 25)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(.plain)
    }
}
