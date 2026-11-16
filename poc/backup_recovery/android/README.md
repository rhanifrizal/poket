# Android passkey PRF probe

Android Credential Manager accepts standard WebAuthn request JSON and exposes a passkey authentication response as JSON. The public Android guidance reviewed for this PoC does not document a native PRF result API. The response JSON may carry client extension results when supported by the provider, but this must be verified on a real provider and must not be assumed.

A real probe needs an Android app target, signing identity, Digital Asset Links association for the relying-party domain, a compatible Credential Manager/provider version, and a test device/provider. Poket has no app target, package/signing identity or association file. The environment has emulators but no connected Android device; Android SDK licenses also remain pending. No passkey was created in this task.

Inspect extension results in memory only; record whether output is present and whether the same credential/input reproduces it. Never log PRF output.

References:
- Android passkey sign-in and Credential Manager response: https://developer.android.com/identity/passkeys/sign-in-with-passkeys
- Android PublicKeyCredential response JSON: https://developer.android.com/reference/androidx/credentials/PublicKeyCredential
