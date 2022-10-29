import Foundation

public enum NetworkError: LocalizedError {
    case invalidServerResponse(statusCode: Int)
    case invalidURL
    case noServerResponse
    
    public var errorDescription: String? {
        switch self {
        case .noServerResponse:
            return "No server response."
        case let .invalidServerResponse(statusCode):
            return "The server returned an invalid response. (Status Code = \(statusCode))"
        case .invalidURL:
            return "URL String is malformed."
        }
    }
}
