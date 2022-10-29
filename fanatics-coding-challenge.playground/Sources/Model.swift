import Foundation

public enum Gender: String, Codable {
    case male
    case female
}

public enum Status: String, Codable {
    case active
    case inactive
}

public struct User: Codable {
    public let id: Int
    public var name: String
    public var email: String
    public var gender: Gender
    public var status: Status
}

extension User: CustomStringConvertible {
    public var description: String {
        return """
                \n
                --- USER (id: \(id)) ---
                    name: \(name)
                    email: \(email)
                    gender: \(gender)
                    status: \(status)
                """
    }
}

extension User: Comparable {
    public static func < (lhs: User, rhs: User) -> Bool {
        return lhs.name.lowercased() < rhs.name.lowercased()
    }
}

extension User {
    public init(id: Int, name: String, email: String, gender: String, status: String) {
        self.id = id
        self.name = name
        self.email = email
        self.gender = Gender(rawValue: gender)!
        self.status = Status(rawValue: status)!
    }
}
