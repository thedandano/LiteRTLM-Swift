import Foundation

@MainActor
public final class LiteRTLMEngine {
    public enum Status: Sendable, Equatable {
        case notLoaded
        case loading
        case ready
        case error(String)
    }

    public private(set) var status: Status = .notLoaded
    public var isReady: Bool { status == .ready }

    private let modelPath: URL
    private let backend: String
    private var engine: Engine?

    public init(modelPath: URL, backend: String = "cpu") {
        self.modelPath = modelPath
        self.backend = backend
    }

    public func load() async throws {
        guard status != .ready && status != .loading else { return }
        status = .loading

        let mappedBackend: Backend = backend.lowercased() == "gpu" ? .gpu : .cpu()
        let config = try EngineConfig(
            modelPath: modelPath.path,
            backend: mappedBackend,
            maxNumTokens: 4096,
            cacheDir: nil
        )

        let runtime = Engine(engineConfig: config)
        do {
            try await runtime.initialize()
            engine = runtime
            status = .ready
        } catch {
            status = .error(error.localizedDescription)
            throw error
        }
    }

    public func unload() {
        guard let engine else {
            status = .notLoaded
            return
        }

        Task { await engine.close() }
        self.engine = nil
        status = .notLoaded
    }

    public func generateStreaming(
        prompt: String,
        temperature: Float = 0.7,
        maxTokens: Int = 512
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let engine else {
                        throw LiteRTLMError.engine(.notInitialized)
                    }

                    let conversation = try await engine.createConversation()
                    defer { conversation.close() }

                    let message = Message(prompt)
                    var producedTokens = 0

                    for try await chunk in conversation.sendMessageStream(message) {
                        if Task.isCancelled {
                            continuation.finish(throwing: CancellationError())
                            return
                        }

                        let text = chunk.toString
                        if !text.isEmpty {
                            continuation.yield(text)
                            producedTokens += 1
                            if producedTokens >= maxTokens {
                                break
                            }
                        }
                    }

                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
