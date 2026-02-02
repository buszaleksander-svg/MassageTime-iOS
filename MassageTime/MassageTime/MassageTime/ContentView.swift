import SwiftUI

// MARK: - MODELS

struct Booking: Identifiable {
    let id = UUID()
    let client: String
    let date: Date
    let time: Date
    let type: String
    let duration: String
    let isCancelled: Bool
}

struct Client: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let phone: String
    let email: String
}

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
                .scrollContentBackground(.hidden)   // ⭐️ usuwa białe tło Listy

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
            .background(Color(.systemGroupedBackground)) // ⭐️ miękkie off-white
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

// MARK: - MY CLIENTS

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

// MARK: - CLIENT PROFILE

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

// MARK: - NEW BOOKING

struct NewBookingView: View {

    @Binding var bookings: [Booking]
    @Binding var clients: [Client]

    @Environment(\.dismiss) var dismiss

    @State private var clientName = ""
    @State private var clientPhone = ""
    @State private var clientEmail = ""

    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var type = ""
    @State private var duration = ""

    let massageTypes = ["Classic", "Relax", "Sports"]
    let durations = ["30 min", "45 min", "60 min"]

    var body: some View {
        VStack {
            Form {

                Section(header: Text("client")) {
                    TextField("client_name", text: $clientName)
                    TextField("phone_number", text: $clientPhone)
                    TextField("email_address", text: $clientEmail)
                }

                Section(header: Text("date")) {
                    DatePicker(
                        "select_date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                }

                Section(header: Text("time")) {
                    DatePicker(
                        "select_time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                }

                Section(header: Text("massage_type")) {
                    Picker("select_type", selection: $type) {
                        ForEach(massageTypes, id: \.self) {
                            Text($0)
                        }
                    }
                }

                Section(header: Text("duration")) {
                    Picker("select_duration", selection: $duration) {
                        ForEach(durations, id: \.self) {
                            Text($0)
                        }
                    }
                }
            }

            Button {
                let newBooking = Booking(
                    client: clientName,
                    date: selectedDate,
                    time: selectedTime,
                    type: type,
                    duration: duration,
                    isCancelled: false
                )

                bookings.append(newBooking)

                if !clients.contains(where: { $0.name.lowercased() == clientName.lowercased() }) {
                    clients.append(
                        Client(
                            name: clientName,
                            phone: clientPhone,
                            email: clientEmail
                        )
                    )
                }

                dismiss()

            } label: {
                Text("save_booking")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding()
            }
        }
        .navigationTitle("new_booking")
    }
}

#Preview {
    ContentView()
}

