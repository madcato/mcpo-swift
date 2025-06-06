import Foundation
import OpenAI

// MARK: - OpenAPI Document
struct OpenAPIDocument: Codable {
    let openapi: String
    let info: Info
    let servers: [Server]
    let paths: [String: RequestDefinition]
    let components: Components
}

// MARK: - Info
struct Info: Codable {
    let title: String
    let description: String
    let version: String
}

// MARK: - Server
struct Server: Codable {
    let url: String
}

// MARK: - Components
struct Components: Codable {
    let schemas: [String: Schema]
}

// MARK: - RequestDefinition
struct RequestDefinition: Codable {
    let post: Request?
    let get: Request?
}

// MARK: - Post
struct Request: Codable {
    let summary: String
    let description: String
    let operationId: String
    let requestBody: RequestBody?
    let responses: [String: Response]
}

// MARK: - RequestBody
struct RequestBody: Codable {
    let content: [String: ContentType]
    let required: Bool
}

// MARK: - ContentType
struct ContentType: Codable {
    let schema: [String: String]
}

// MARK: - Response
struct Response: Codable {
    let description: String
    let content: [String: Content]
}

// MARK: - Content
struct Content: Codable {
    let schema: [String: String]
}

// MARK: - Schema
struct Schema: Codable {
    let properties: AnyJSONSchema
    let type: String
    let title: String
}