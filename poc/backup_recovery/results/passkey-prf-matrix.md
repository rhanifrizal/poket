# Passkey PRF capability matrix

Checked 2026-11-16. This is an evidence and setup matrix, not a claim that the feature works on Poket launch devices.

| Target | Official API evidence | Actual Poket test | Required setup | Current result |
|---|---|---|---|---|
| Web | W3C defines PRF, but WebAuthn extensions are optional. | Not run. No test page or test credential. | HTTPS/RP domain (or local localhost probe), compatible browser and passkey provider. | Unverified; fail closed if PRF output is absent. |
| iOS | Apple documents AuthenticationServices PRF inputs for passkey registration/assertion and symmetric-key use. | Not run. No iOS app target, associated domain or test credential. | Apple team/signing identity, webcredentials association, app target, compatible device/provider. | API is documented; Poket portability and repeatability remain unverified. |
| Android | Credential Manager accepts standard request JSON and returns a standard WebAuthn response JSON. Public Android guidance reviewed does not document a native PRF result API. | Not run. No Android app target, signing identity, Digital Asset Links association or test credential. | App package/signing identity, relying-party association, compatible provider and test device. | Provider/extension support unverified; do not assume unsupported or supported until tested. |

No PRF output or test credential was created. Same-credential repeatability is unverified on all targets.

## Cross-platform decision gate

Do not make PRF the required launch recovery method unless the same account credential or a deliberately enrolled set of credentials reliably restores on replacement devices for the supported platform/provider matrix. If PRF is missing on any supported path, the recovery phrase path must independently work; absent that, encrypted backup is not ready to launch.

## Environment/configuration blockers

- No production or test RP domain, webcredentials association, Android Digital Asset Links file, app package identifier, Apple team identity, or signing configuration exists in this documentation-only repository.
- The machine has iOS simulators and Android virtual devices available but no connected iOS or Android device.
- Flutter reports an unknown channel and Android SDK licenses are pending; the Flutter invocation attempted to write outside the workspace and was not retried.
