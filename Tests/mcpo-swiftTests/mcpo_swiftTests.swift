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
