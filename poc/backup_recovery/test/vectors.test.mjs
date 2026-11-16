import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const manifestPath = fileURLToPath(
  new URL('../vectors/manifest.json', import.meta.url),
);

test('test vector manifest exists and contains synthetic data only', () => {
  assert.ok(existsSync(manifestPath), 'expected vectors/manifest.json');
  const manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));

  assert.equal(manifest.fixtureType, 'synthetic');
  assert.deepEqual(manifest.syntheticLedger, {
    userId: 'synthetic-user-001',
    walletName: 'Synthetic Wallet',
    currency: 'MYR',
    amountMinor: 12345,
    note: 'Synthetic test data; not a real transaction',
  });
  assert.deepEqual(manifest.syntheticReceiptBytes, [80, 79, 75, 69, 84, 45, 84, 69, 83, 84]);
});

test('envelope schema separates payload encryption and independent key wrapping slots', () => {
  const manifest = JSON.parse(readFileSync(manifestPath, 'utf8'));

  assert.equal(manifest.envelope.version, 1);
  assert.equal(manifest.envelope.payloadEncryption, 'AES-256-GCM');
  assert.deepEqual(manifest.envelope.requiredFields, [
    'version',
    'payloadEncryption',
    'keyDerivation',
    'keyWrapping',
    'payloadNonce',
    'keySlots',
    'ciphertext',
  ]);
  assert.deepEqual(manifest.envelope.keySlotRequiredFields, [
    'slotId',
    'keyDerivation',
    'keyDerivationSalt',
    'keyWrapping',
    'wrappedKeyNonce',
    'wrappedKey',
  ]);
  assert.deepEqual(manifest.envelope.proposedSlots, [
    'passkey-prf',
    'recovery-phrase',
  ]);
  assert.deepEqual(manifest.envelope.keySlotOptionalFields, ['prfInput']);
  assert.equal(manifest.envelope.prfInputLabel, 'Poket Backup Key Slot v1');
  assert.equal(manifest.envelope.syntheticPrfInput, 'AwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwM');
  assert.equal(manifest.envelope.keyDerivation, 'HKDF-SHA-256');
  assert.equal(manifest.envelope.keyWrapping, 'AES-256-GCM');
});
