# Expected synthetic-vector results

- The test suite accepts the manifest only when it identifies the fixtures as synthetic and the ledger/receipt values match the fixed synthetic samples.
- The manifest identifies AES-256-GCM for payload encryption and key wrapping, HKDF-SHA-256 for key derivation, and separate slots for passkey PRF and recovery phrase.
- Future crypto harness tests must restore the exact synthetic payload with a valid slot and fail closed for changed ciphertext/tag, wrong slot secret, malformed envelope, or unsupported version.
- No vector may contain real receipts, personal identifiers, access tokens, passwords, PRF outputs or encryption keys.
