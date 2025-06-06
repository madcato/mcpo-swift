import Foundation

public struct ToolCall {
    let id: String
    let toolId: String
    let parameters: [String: String]
}

public class ToolResolver {
    private let mcpClient: MCPClient

    public init(mcpClient: MCPClient) {
        self.mcpClient = mcpClient
    }

    func resolveToolCall(toolCall: ToolCall) async throws -> String {
        let toolInvocationResponse = try await mcpClient.invokeTool(toolId: toolCall.toolId, parameters: toolCall.parameters)
        return toolInvocationResponse.result
    }
}