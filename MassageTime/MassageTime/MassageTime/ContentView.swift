import SwiftUI

// MARK: - HOME

struct ContentView: View {

    @State private var bookings: [Booking] = [
        Booking(
            client: "Anna Larsson",
            date: Date(),
            time: Date(),
            type: "Classic",
            duration: "60 min",
            isCancelled: false
        ),
        Booking(
            client: "Johan Berg",
            date: Date(),
            time: Date(),
            type: "Friskvård",
            duration: "45 min",
            isCancelled: false
        ),
        Booking(
            client: "Elin Larsson",
            date: Date(),
            time: Date(),
            type: "",
            duration: "",
            isCancelled: true
        )
    ]

    @State private var clients: [Client] = [
        Client(
            name: "Anna Larsson",
            phone: "070 123 45 67",
            email: "anna@example.com"
        ),
        Client(
            name: "Johan Berg",
            phone: "070 987 65 43",
            email: "johan@example.com"
        )
    ]

    var todayText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMMM"
        let day = formatter.string(from: Date())
        return "\(NSLocalizedString("today", comment: "")) – \(day)"
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {

                Text(todayText)
                    .font(.headline)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .padding(.top, 8)

                List(bookings) { booking in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(booking.client)
                            .font(.headline)

                        if booking.isCancelled {
                            Text("cancelled")
                                .foregroundColor(.red)
                        } else {
                            Text("\(booking.type) • \(booking.duration)")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)

                NavigationLink {
                    NewBookingView(
                        bookings: $bookings,
                        clients: $clients
                    )
                } label: {
                    Text("new_booking")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("app_title")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        MyClientsView(
                            clients: clients,
                            bookings: bookings
                        )
                    } label: {
                        Text("my_clients")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
