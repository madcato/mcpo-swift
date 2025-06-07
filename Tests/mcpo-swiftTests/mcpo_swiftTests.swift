import Foundation
import Testing
@testable import mcpo_swift

@Test func discoverMCP() async throws {
    let serverURLs = [
        URL(string: "http://micro-atx.local:8084/brave-search/openapi.json")!,
        URL(string: "http://micro-atx.local:8084/server-time/openapi.json")!,
        URL(string: "http://micro-atx.local:8084/filesystem/openapi.json")!,
        URL(string: "http://micro-atx.local:8084/memory/openapi.json")!,
        URL(string: "http://micro-atx.local:8084/sequential-thinking/openapi.json")!
    ]

    
    let toolDefinitions = try await MCPDiscovery.discoverServers(fromURLs: serverURLs)
    print("Found tools: ")
    toolDefinitions.forEach { functionTool in
        print("- \(functionTool.name): \(String(describing:functionTool.description))")
    }
    #expect(toolDefinitions.count > 0)
}

@Test func testGetCurrentTime() async throws {
    let url = [URL(string: "http://micro-atx.local:8084/server-time/openapi.json")!]
    
    let toolDefinitions = try await MCPDiscovery.discoverServers(fromURLs: url)
    print("Found tools: ")
    let functionTool = toolDefinitions.first { functionTool in
        functionTool.name == "/get_current_time"
    }

    guard let functionTool = functionTool else { return }
    
    let clientUrl = URL(string: "http://micro-atx.local:8084/server-time")!
    let client = MCPClient(baseURL: clientUrl)
    let response = try await client.invokeTool(toolId: "asdf", toolPath: functionTool.name, parameters: ["timezone": "Europe/Madrid"])
    print("Current time is: \(response)")
}
