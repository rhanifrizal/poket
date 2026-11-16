import assert from 'node:assert/strict';
import { existsSync, readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import test from 'node:test';

const sourcePath = fileURLToPath(new URL('../src/envelope.mjs', import.meta.url));

const secret = (byte) => new Uint8Array(32).fill(byte);
const fixture = new TextEncoder().encode(
  JSON.stringify({ fixtureType: 'synthetic', amountMinor: 12345 }),
);

test('synthetic payload restores with either independent recovery slot', async () => {
  assert.ok(existsSync(sourcePath), 'expected src/envelope.mjs');
  const { createEnvelope, restoreEnvelope } = await import('../src/envelope.mjs');
  const prfInput = secret(3);
  const envelope = await createEnvelope(fixture, [
    { slotId: 'passkey-prf', secret: secret(7), prfInput },
    { slotId: 'recovery-phrase', secret: secret(9) },
  ], 'synthetic-account-binding');

  assert.equal(
    envelope.keySlots[0].prfInput,
    Buffer.from(prfInput).toString('base64url'),
  );
  assert.deepEqual(
    await restoreEnvelope(envelope, 'passkey-prf', secret(7), 'synthetic-account-binding'),
    fixture,
  );
  assert.deepEqual(
    await restoreEnvelope(envelope, 'recovery-phrase', secret(9), 'synthetic-account-binding'),
    fixture,
  );
});

test('wrong secret or account binding fails authenticated restore', async () => {
  assert.ok(existsSync(sourcePath), 'expected src/envelope.mjs');
  const { createEnvelope, restoreEnvelope } = await import('../src/envelope.mjs');
  const envelope = await createEnvelope(fixture, [
    { slotId: 'recovery-phrase', secret: secret(9) },
  ], 'synthetic-account-binding');

  await assert.rejects(
    restoreEnvelope(envelope, 'recovery-phrase', secret(8), 'synthetic-account-binding'),
  );
  await assert.rejects(
    restoreEnvelope(envelope, 'recovery-phrase', secret(9), 'different-account-binding'),
  );
});

test('tampered, malformed and unsupported envelopes fail closed', async () => {
  assert.ok(existsSync(sourcePath), 'expected src/envelope.mjs');
  const { createEnvelope, restoreEnvelope } = await import('../src/envelope.mjs');
  const envelope = await createEnvelope(fixture, [
    { slotId: 'recovery-phrase', secret: secret(9) },
  ], 'synthetic-account-binding');
  const tampered = structuredClone(envelope);
  const ciphertext = tampered.ciphertext;
  tampered.ciphertext = (ciphertext[0] === 'A' ? 'B' : 'A') + ciphertext.slice(1);

  await assert.rejects(
    restoreEnvelope(tampered, 'recovery-phrase', secret(9), 'synthetic-account-binding'),
  );
  await assert.rejects(
    restoreEnvelope({ ...envelope, version: 999 }, 'recovery-phrase', secret(9), 'synthetic-account-binding'),
  );
  await assert.rejects(
    restoreEnvelope({ ...envelope, keySlots: [] }, 'recovery-phrase', secret(9), 'synthetic-account-binding'),
  );
});

test('envelope source contains no console logging', async () => {
  assert.ok(existsSync(sourcePath), 'expected src/envelope.mjs');
  const source = readFileSync(sourcePath, 'utf8');
  assert.doesNotMatch(source, /console\./);
});
