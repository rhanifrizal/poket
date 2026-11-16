# Web passkey PRF probe

The web platform uses WebAuthn. The PRF extension can return key material to the client, but WebAuthn defines extensions as optional, so Poket must treat absent results as an unsupported path.

A real probe needs a relying-party ID that matches an HTTPS origin (localhost is permitted for local development), a browser/passkey provider that supports the PRF extension, and a test credential. The probe must record only registration/assertion success, result presence and whether the same credential plus same input reproduces the result. It must never print PRF output.

No credential was created in this task. Poket has no configured relying-party domain or test page yet. See the platform matrix for the verification blocker.

References:
- W3C WebAuthn PRF and optional-extension requirements: https://www.w3.org/TR/webauthn/
