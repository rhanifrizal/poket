# Provisional envelope shape

The manifest defines a candidate version 1 envelope for synthetic data. It is not a production format.

- A fresh random 256-bit data-encryption key encrypts the complete synthetic payload using AES-256-GCM.
- Each independent recovery method gets a keySlots entry that wraps the same data-encryption key. Candidate slots are passkey-prf and recovery-phrase.
- A passkey slot stores the exact non-secret PRF input needed to reproduce its output on restore. The input includes the fixed versioned label and per-backup random input bytes; the PRF output is never stored. Each slot derives a wrapping key with HKDF-SHA-256 using a per-slot random salt and a versioned, slot-specific context string, then wraps with AES-256-GCM.
- Store algorithm identifiers, salts, nonces, wrapped key and ciphertext. Never store plaintext data keys, PRF output or recovery secrets.
- Nonces must be freshly generated and never reused with the same AES-GCM key. Authentication failure must reject the entire restore without exposing partial plaintext.
- The recovery phrase must represent independently generated high-entropy secret material; a login password or user-chosen short phrase is not acceptable. Word encoding, entropy, normalization, backup-slot rotation and loss UX remain open for the security design.

AES-GCM is specified by NIST SP 800-38D; HKDF is specified by IETF RFC 5869. Using standardized algorithms does not make this envelope an independently reviewed protocol. The design still needs cross-platform interoperability testing, limits for large payloads, key lifecycle analysis and security review.
