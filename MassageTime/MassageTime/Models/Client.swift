import Foundation

struct Client: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let phone: String
    let email: String
}
