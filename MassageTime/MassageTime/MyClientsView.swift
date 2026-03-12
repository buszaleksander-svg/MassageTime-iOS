import SwiftUI

struct MyClientsView: View {

    let clients: [Client]
    let bookings: [Booking]

    var body: some View {
        List(clients) { client in
            HStack {
                VStack(alignment: .leading) {
                    Text(client.name)
                        .font(.headline)
                    Text(client.phone)
                        .foregroundColor(.gray)
                }

                Spacer()

                NavigationLink {
                    ClientProfileView(
                        client: client,
                        bookings: bookings
                    )
                } label: {
                    Text("view")
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("my_clients")
    }
}
