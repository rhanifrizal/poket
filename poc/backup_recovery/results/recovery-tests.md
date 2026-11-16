# Synthetic recovery behavior results

Command:
node --test poc/backup_recovery/test/*.test.mjs

Result: 6 tests passed, 0 failed on Node.js v26.3.0.

A random data key was created internally and wrapped under two independent synthetic high-entropy inputs. After creation, restore used the returned envelope object and the selected slot input; the original data-key byte array is zero-filled in a finally block. Restoring through either slot returned the exact original synthetic JSON payload.

Negative cases failed closed:
- wrong recovery input;
- wrong account-binding context;
- modified authenticated ciphertext;
- unsupported envelope version;
- missing recovery slot.

No keys, recovery inputs, PRF outputs, or decrypted fixture payloads are printed by the envelope module or stored in result files.

This validates the local algorithm plumbing only. It does not validate a human-readable recovery phrase, device keychain, operating-system reinstall, authenticator behavior, or production key erasure.
