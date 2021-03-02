import Foundation

private func < <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

private func > <T: Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

final class ParsingService<T> where T: Any, T: Decodable {
    
    @discardableResult
    func parseObject(_ response: [String: Any]?) -> T? {
        if let response = response {
            if let data = try? JSONSerialization.data(withJSONObject: response, options: []) {
                let decoder = JSONDecoder()
                if let decoded = try? decoder.decode(T.self, from: data) {
                    return decoded
                }
            }
        }
        return nil
    }
}
