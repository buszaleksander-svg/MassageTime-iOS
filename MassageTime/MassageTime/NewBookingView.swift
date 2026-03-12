import SwiftUI

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
