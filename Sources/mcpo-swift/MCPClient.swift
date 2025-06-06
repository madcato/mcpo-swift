import Foundation

struct ToolInvocationRequest {
    let toolId: String
    let parameters: [String: Any]

    func toJson() throws -> Data {
        return try JSONSerialization.data(withJSONObject: parameters, options: [])
    }
}

public struct ToolInvocationRequest2: Codable {
    let toolId: String
    let parameters: [String: String]

    // enum ToolInvocationRequestKeys: String, CodingKey {
    //     case toolId, parameters
    // }
    
    // public init(from decoder: Decoder) throws {
    //     let container =  try decoder.container(keyedBy: ToolInvocationRequestKeys.self)
    //     toolId = try container.decode(String.self, forKey: .toolId)
    //     parameters = try container.decode(Any.self, forKey: .parameters)
    // }

    //  func encode(to encoder: Encoder) throws
    //  {
    //       var container = encoder.container(keyedBy: ToolInvocationRequestKeys.self)
    //       try container.encode(toolId, forKey: .toolId)
    //       try container.encode(parameters, forKey: .parameters)
    //  }
}

public struct ToolInvocationResponse: Codable {
    let result: String
}

public class MCPClient {
    private let baseURL: URL

    public init(baseURL: URL) {
        self.baseURL = baseURL
    }

    func invokeTool(toolId: String, parameters: [String: Any]) async throws -> ToolInvocationResponse {
        let url = baseURL.appendingPathComponent("/tools/\(toolId)/invoke") // endpoint variable
        let request = URLRequest(url: url)
        
        let toolInvocationRequest = ToolInvocationRequest(toolId: toolId, parameters: parameters)
        // let body = try encoder.encode(toolInvocationRequest)
        let body = try toolInvocationRequest.toJson()

        let (data, response) = try await URLSession.shared.upload(for: request, from: body)

        guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
            throw MCPServerError.invalidResponse
        }
        let decoder = JSONDecoder()
        let toolInvocationResponse = try decoder.decode(ToolInvocationResponse.self, from: data)
        return toolInvocationResponse
    }
}