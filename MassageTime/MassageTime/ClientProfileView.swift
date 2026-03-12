import SwiftUI

struct ClientProfileView: View {

    let client: Client
    let bookings: [Booking]

    var clientBookings: [Booking] {
        bookings.filter { $0.client == client.name }
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            VStack(alignment: .leading, spacing: 4) {
                Text(client.name)
                    .font(.title2)
                    .bold()

                Text(client.phone)
                    .foregroundColor(.gray)

                Text(client.email)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            List(clientBookings) { booking in
                if booking.isCancelled {
                    Text("cancelled")
                        .foregroundColor(.red)
                } else {
                    Text("\(formattedDate(booking.date)) • \(booking.type) • \(booking.duration)")
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("client_profile")
    }
}
