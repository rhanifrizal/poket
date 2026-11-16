# Synthetic envelope test results

Environment: Node.js v26.3.0, built-in Web Crypto API. No dependency installation.

Command:
node --test poc/backup_recovery/test/*.test.mjs

Result: 6 tests passed, 0 failed.

The tests create a random data-encryption key, encrypt a synthetic ledger payload using AES-256-GCM, and wrap that same key in independent passkey-PRF and recovery-phrase slots. Each slot uses HKDF-SHA-256 with a fresh 32-byte salt and AES-256-GCM wrapping. Payload and wrapped-key nonces are 12 bytes; Web Crypto uses a 128-bit GCM tag. Base64url encoding is used for envelope bytes.

Tested:
- the manifest contains only the fixed synthetic MYR ledger and fake receipt bytes;
- serialized envelope round trip through either key slot returns the exact synthetic payload;
- wrong slot secret and wrong account binding do not restore;
- changed ciphertext, unsupported version and empty key-slot collection fail;
- the envelope module contains no console logging.

Account binding is supplied by the caller and authenticated as additional data; it is not copied into the envelope. The test uses a synthetic value, not a real Firebase UID.

Limitations:
- Passkey PRF output and recovery phrase encoding were modeled as fixed 32-byte test inputs; neither was obtained from a real authenticator nor generated for a user.
- The tests run in one Node process, though they serialize and parse the envelope and do not persist the random data key. This is not an iOS, Android or web replacement-install test.
- JavaScript cannot guarantee erasure of copies held internally by the runtime or cryptographic provider; filling the local data-key byte array is best-effort only.
- No large receipts, cross-language interoperability, nonce lifecycle at scale, key rotation, production code, or independent security review was tested.
