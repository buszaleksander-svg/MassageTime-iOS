import Foundation

struct Booking: Identifiable {
    let id = UUID()
    let client: String
    let date: Date
    let time: Date
    let type: String
    let duration: String
    let isCancelled: Bool
}
