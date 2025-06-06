# Swift MCP Client Library

A simple, secure MCP-to-OpenAPI proxy server in Swift

This project is inspired by [open-webui/mcpo](https://github.com/open-webui/mcpo)

[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Description

A Swift library designed to act as a manager for Model Context Protocol (MCP) servers. This library simplifies the integration of Large Language Models (LLMs) with tools available through MCP servers, enabling seamless tool calling functionality.  It's intended to work alongside existing LLM clients (e.g., those interacting with Ollama or other providers) and abstract away the complexities of interacting with multiple MCP endpoints.

## Features

*   **MCP Server Discovery:**  Automatically discovers available MCP servers based on a list of provided URLs.
*   **Dynamic Tool Loading:**  Retrieves the list of tools exposed by each server and makes them available for use.
*   **Tool Invocation:**  Handles the communication with MCP servers to invoke specific tools with provided parameters.
*   **Asynchronous Operation:**  Utilizes `async/await` for non-blocking calls to MCP servers.
*   **Error Handling:**  Provides robust error handling for network requests, JSON parsing, and server responses.
*   **MIT License:** Open-source and free to use and modify.

## Getting Started

### Prerequisites

*   Xcode 16 or later
*   Swift 6.1 or later

### Installation

You can add this library to your project using Swift Package Manager:

1.  In Xcode, go to `File` -> `Add Packages...`
2.  Enter the repository URL: `[https://github.com/madcato/mcpo-swift]`
3.  Select the repository and choose the latest version.

### Usage

```swift
import MCPClient

// 1. Discover MCP Servers
let serverURLs = [
    URL(string: "https://example.com/mcp-server-1/tools"),
    URL(string: "https://example.com/mcp-server-2/tools")
]

do {
    let toolDefinitions = try MCPDiscovery.discoverServers(fromURLs: serverURLs)
    print("Discovered Tools: \(toolDefinitions)")
} catch {
    print("Error discovering servers: \(error)")
}

// 2. Create MCP Clients for each server
let baseURL1 = URL(string: "https://example.com/mcp-server-1")!
let client1 = MCPClient(baseURL: baseURL1)

// 3. Invoke a tool
let toolId = "my-tool"
let parameters: [String: Any] = ["input": "some input"]

do {
    let response = try client1.invokeTool(toolId: toolId, parameters: parameters)
    print("Tool Response: \(response)")
} catch {
    print("Error invoking tool: \(error)")
}

// 4. Use ToolResolver to handle LLM tool calls (example)
// Assuming you have a 'toolCall' object representing a call from your LLM client

let toolResolver = ToolResolver(mcpClient: client1)
do {
    let result = try toolResolver.resolveToolCall(toolCall: toolCall)
    print("Tool Call Result: \(result)")
} catch {
    print("Error resolving tool call: \(error)")
}