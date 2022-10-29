import Foundation

public class APIManagerMock: APIManagerProtocol {
    private let parser: DataParserProtocol
    
    public init() {
        self.parser = DataParser()
    }
    
    public func perform<T>(_ request: RequestProtocol) async throws -> T where T : Decodable {
        return try parser.parse(data: Data(contentsOf: URL(fileURLWithPath: request.path), options: .mappedIfSafe))
    }
    
    public func perform(_ request: RequestProtocol) async throws {
    }
}
