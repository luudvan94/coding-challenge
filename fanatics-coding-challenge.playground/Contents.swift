import _Concurrency
import PlaygroundSupport
import XCTest

let apiManager = APIManager()

func getListUser(page: Int, perPage: Int = 20) async throws -> [User] {
    return try await apiManager.perform(UsersRequest.getUsersWith(page: page, perPage: perPage))
}

func getUserBy(id: Int) async throws -> User {
    return try await apiManager.perform(UsersRequest.getUserBy(id: id))
}

func update(user: User) async throws {
    try await apiManager.perform(UsersRequest.updateUser(id: user.id, user: user))
}

func delete(user: User) async throws {
    try await apiManager.perform(UsersRequest.deleteUser(id: user.id))
}

Task {
    do {
        var users: [User] = try await getListUser(page: 3)
        users = users.sorted()
        Logger.info(title: "User list of page 3", message: "\(users)")

        if var lastUser = users.last {
            Logger.info(title: "Name of the last user", message: lastUser.name)
            lastUser.name = "Luu Van"

            try await update(user: lastUser)
            try await delete(user: lastUser)
            try await getUserBy(id: 5555)
        }

    } catch (let e) {
        Logger.error(title: "ERROR", message: e.localizedDescription)
    }

    PlaygroundPage.current.finishExecution()
}

PlaygroundPage.current.needsIndefiniteExecution = true

public class APIManageTest: XCTestCase {
    private var apiManager: APIManagerProtocol?

    public override func setUp() {
        super.setUp()
        apiManager = APIManagerMock()
    }

    func testGetUsers() async throws {
        guard let users: [User] = try await apiManager?.perform(UsersRequestMock.getUsersWith(page: 3, perPage: 20)) else {
            return
        }

        XCTAssert(users.count > 0)
    }

    func testGetUser() async throws {
        guard let user: User = try await apiManager?.perform(UsersRequestMock.getUserBy(id: 1)) else {
            return
        }

        XCTAssertEqual(user.name, "Elakshi Tandon")
        XCTAssertEqual(user.email, "elakshi_tandon@tillman-heathcote.co")
        XCTAssertEqual(user.gender.rawValue, "male")
        XCTAssertEqual(user.status.rawValue, "active")
    }
}

public class UsersRequestTest: XCTestCase {
    public override func setUp() {
        super.setUp()
    }
    
    func testUpdateUserRequest() {
        let testUser = User(id: 1994, name: "Luu Van", email: "luuvan@gmail.com", gender: "male", status: "active")
        guard let urlRequest = try? UsersRequest.updateUser(id: 1994, user: testUser).createUrlRequest(authToken: "Bearer testToken"), let url = urlRequest.url else {
            return
        }
        
        XCTAssertEqual(url.pathComponents.last, "1994")
        XCTAssertEqual(urlRequest.httpMethod, "PUT")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"] ?? "", "Bearer testToken")
        
    }
    
    func testDeleteUserRequest() {
        guard let urlRequest = try? UsersRequest.deleteUser(id: 1994).createUrlRequest(authToken: "Bearer testToken"), let url = urlRequest.url else {
            return
        }
        
        XCTAssertEqual(url.pathComponents.last, "1994")
        XCTAssertEqual(urlRequest.httpMethod, "DELETE")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Authorization"] ?? "", "Bearer testToken")
    }
}

//APIManageTest.defaultTestSuite.run()
UsersRequestTest.defaultTestSuite.run()
