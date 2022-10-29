import Foundation

public enum UsersRequestMock: RequestProtocol {
    case getUsersWith(page: Int, perPage: Int)
    case getUserBy(id: Int)
    case updateUser(id: Int, user: User)
    case deleteUser(id: Int)

    public var path: String {
        switch self {
        case .getUsersWith(_, _):
            return Bundle.main.path(forResource: "UsersMock", ofType: "json") ?? ""
        case let .getUserBy(_):
            return Bundle.main.path(forResource: "UserMock", ofType: "json") ?? ""
        case let .updateUser(_, _):
            return ""
        case let .deleteUser(_):
            return ""
        }
    }

    public var requestType: RequestType {
        switch self {
        case .getUserBy(_):
            return .GET
        case .getUsersWith(_, _):
            return .GET
        case .updateUser(_,_):
            return .PUT
        case .deleteUser(_):
            return .DELETE
        }
    }

    public var urlParams: [String : String?] {
        switch self {
        case let .getUsersWith(page, perPage):
            var params = ["page": String(page)]
            params["per_page"] = String(perPage)
            return params
        default:
            return [:]
        }
    }
}
