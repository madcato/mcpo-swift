import Foundation
import OpenAI

public class MCPDiscovery {
    public static func discoverServers(fromURLs: [URL]) async throws -> [FunctionTool] {
        var toolDefinitions: [FunctionTool] = []
        for url in fromURLs {
            let (data, response) = try await networkRequest(to: url)
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw MCPServerError.invalidResponse
            }

            let decoder = JSONDecoder()
            let definition = try decoder.decode(OpenAPIDocument.self, from: data)

            let tools = buildTools(from: definition)
            toolDefinitions.append(contentsOf: tools)
        }
        return toolDefinitions
    }

    private static func networkRequest(to url: URL) async throws -> (Data, URLResponse) {
        let (data, response) = try await URLSession.shared.data(from: url)
        return (data, response)
    }

    private static func buildTools(from definition: OpenAPIDocument) -> [FunctionTool] { // Tengo que construir FunctionTool de MacPaw
        let tools = definition.paths.map { (key: String, value: RequestDefinition) in
            guard let request = value.post ?? value.get else { fatalError("Only post and get are implemented currently") }
            let name = key
            let description = request.description

            guard let requestBody = request.requestBody else {
                return FunctionTool(name: name, description: description, parameters: AnyJSONSchema(fields: []), strict: true)
            }
            guard let schemaPath = requestBody.content["application/json"]?.schema["$ref"] else {
                fatalError("Schema not found for \(request)")
            }
            let parameters = buidlToolDefinition(for: schemaPath, components: definition.components)
            return FunctionTool(name: name, description: description, parameters: parameters, strict: true)
        }
        return tools
    }

    private static func buidlToolDefinition(for schemaPath: String, components: Components) -> AnyJSONSchema {
        guard let name = schemaPath.split(separator: "/").last else {
            fatalError("Schema malformed: \(schemaPath)")
        }
        guard let schema = components.schemas.first(where: { (key: String, value: Schema) in
            key == name
        }) else {
            fatalError("Component schema for \(name) not found")
        }
        return schema.value.properties
    }
}

public enum MCPServerError: Error {
    case invalidURL
    case networkError
    case invalidResponse
    case decodingError
}