import Foundation

public enum UsersRequest: RequestProtocol {
    case getUsersWith(page: Int, perPage: Int)
    case getUserBy(id: Int)
    case updateUser(id: Int, user: User)
    case deleteUser(id: Int)

    public var path: String {
        switch self {
        case .getUsersWith(_, _):
            return "/public/v2/users"
        case let .getUserBy(id):
            return "/public/v2/users/\(id)"
        case let .updateUser(id, _):
            return "/public/v2/users/\(id)"
        case let .deleteUser(id):
            return "/public/v2/users/\(id)"
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
    
    public var params: [String: Any] {
        switch self {
        case let .updateUser(_, user):
            return ["name": user.name, "email": user.email, "gender": user.gender.rawValue, "status": user.status.rawValue]
        default:
            return [:]
        }
    }
}
