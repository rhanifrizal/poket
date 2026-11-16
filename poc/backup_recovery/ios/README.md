# iOS passkey PRF probe

Apple AuthenticationServices exposes PRF inputs for passkey registration and assertion, and describes the PRF result as usable to create symmetric keys for data encryption.

A real native probe needs an iOS app target, Apple developer team/signing identity, a webcredentials-associated relying-party domain, and a device or simulator/passkey provider that supports the flow. The current Poket repository has no native app target or configured associated domain. No passkey was created in this task.

Record only API availability, assertion success, result presence and same-credential repeatability. Never log PRF output.

References:
- Apple PRF assertion input: https://developer.apple.com/documentation/authenticationservices/asauthorizationpublickeycredentialprfassertioninput-c.class
- Apple AuthenticationServices updates: https://developer.apple.com/documentation/updates/authenticationservices?changes=_4
