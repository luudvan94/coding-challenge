import Foundation

public protocol APIManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
    func perform(_ request: RequestProtocol) async throws
}

public class APIManager: APIManagerProtocol {
    private let urlSession: URLSession
    private let parser: DataParserProtocol
    
    public init(urlSession: URLSession = .shared, parser: DataParserProtocol = DataParser()) {
        self.urlSession = urlSession
        self.parser = parser
    }
    
    private func createBearerToken() -> String {
        return "Bearer \(APIConstant.token)"
    }
    
    public func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let (data, response) = try await urlSession.data(for: request.createUrlRequest(authToken: createBearerToken()))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noServerResponse
        }
        
        guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
            throw NetworkError.invalidServerResponse(statusCode: httpResponse.statusCode)
        }

        let decoded: T =  try parser.parse(data: data)
        return decoded
    }
    
    public func perform(_ request: RequestProtocol) async throws {
        let (_, response) = try await urlSession.data(for: request.createUrlRequest(authToken: createBearerToken()))
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noServerResponse
        }
        
        guard httpResponse.statusCode >= 200, httpResponse.statusCode < 300 else {
            throw NetworkError.invalidServerResponse(statusCode: httpResponse.statusCode)
        }
    }
}
