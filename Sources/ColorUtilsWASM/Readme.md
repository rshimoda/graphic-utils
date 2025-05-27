## This is a starting point for porting ColorUtils to WASM.

### Preparations:
* Install open-source Swift toolchain (6.1 or later): 
https://www.swift.org/install/macos/

* Install WASM SDK: 
```bash
swift sdk install "https://github.com/swiftwasm/swift/releases/download/swift-wasm-6.1-RELEASE/swift-wasm-6.1-RELEASE-wasm32-unknown-wasi.artifactbundle.zip" --checksum "7550b4c77a55f4b637c376f5d192f297fe185607003a6212ad608276928db992"
```

* Check installation:
```bash
swift --version # Apple Swift version 6.1 (swift-6.1-RELEASE) - NOT swiftlang-6.1.0.110.21 clang-1700.0.13.3!
swift sdk list # swift-wasm-6.1-RELEASE-wasm32-unknown-wasi

```

### Usefull resources:
* Swift WASM Book: https://book.swiftwasm.org/getting-started/setup.html
* Swift for WASM examples: https://github.com/swiftlang/swift-for-wasm-examples
* Another Swift WASM examples (including passing custom types between Swift and JS via `Codable`): https://github.com/pwsacademy/swiftwasm-examples

## Available Challenges:
* [ ] Port ColorUtils to WASM
* [ ] Setup CI for WASM builds
* [ ] Add sample node.js app to test WASM build

### Note:
* Use PR or Issue for discussion and to share your work.
* Don't forget to re-export the Swift code to WASM via `@_cdecl(...)` and `@exported(wasm, ...)` attributes.
* This command should work for building the WASM module:
```bash
swift build \
  --swift-sdk wasm32-unknown-wasi \
  -Xswiftc -static-stdlib \
  -Xswiftc -Xclang-linker \
  -Xswiftc -mexec-model=reactor
```
