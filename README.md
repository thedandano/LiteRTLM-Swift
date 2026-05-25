# LiteRTLMSwift (Official-Source Wrapper)

Swift Package wrapper for Google LiteRT-LM using official Google release artifacts.

## Goals

- Keep a stable module/product name: `LiteRTLMSwift`
- Pin to official Google LiteRT-LM artifacts by exact URL + checksum
- Manual version bumps only (no auto-update)

## Install

Add the package in Xcode:

- URL: `https://github.com/thedandano/LiteRTLM-Swift-Official.git`
- Dependency rule: `branch: main` (or pin to a tag in production)

Then import:

```swift
import LiteRTLMSwift
```

## Provenance

| Field | Value |
|---|---|
| Upstream project | `google-ai-edge/LiteRT-LM` |
| Upstream artifact | `CLiteRTLM.xcframework.zip` |
| Upstream release | `v0.12.0` |
| Upstream URL | `https://github.com/google-ai-edge/LiteRT-LM/releases/download/v0.12.0/CLiteRTLM.xcframework.zip` |
| Checksum | `3c2a11ecc8511d1e74efa7ca308dc7130c95223325c33212337ffb0563b79cde` |
| Retrieval date | `2026-05-25` |

## Manual update workflow

1. Choose a new official Google LiteRT-LM release.
2. Update `Package.swift` binary URL and checksum.
3. Resolve and build in Xcode / `xcodebuild`.
4. Smoke-test simulator and physical device launch.
5. Tag a new wrapper release.

## Legal

- Upstream LiteRT-LM is Apache-2.0 licensed.
- This wrapper repo includes attribution and notice references in `THIRD_PARTY_NOTICES.md`.
- This wrapper is not affiliated with or endorsed by Google.
