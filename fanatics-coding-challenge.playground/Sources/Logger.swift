import Foundation

public class Logger {
    public static func info(title: String, message: String) {
        print("""
===== ℹ️\(title)ℹ️ =====
\(message)
""")
    }
    
    public static func error(title: String, message: String) {
        print("""
======❗️\(title)❗️=====
\(message)
""")
    }
}
