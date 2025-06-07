import Foundation
import OpenAI

struct ToolInvocationRequest {
    let toolId: String
    let parameters: [String: Any]

    func toJson() throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

public class MCPClient {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func invokeTool(toolId: String, toolPath: String, parameters: [String: String]) async throws -> String {
        let url = baseURL.appendingPathComponent(toolPath) // endpoint variable
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let toolInvocationRequest = ToolInvocationRequest(toolId: toolId, parameters: parameters)
        let encoder = JSONEncoder()
        let body = try encoder.encode(parameters)
        

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)

        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw MCPServerError.invalidResponse
        }
        
        let result = String(data: data, encoding: .utf8) ?? "no response"
        return result
    }
}