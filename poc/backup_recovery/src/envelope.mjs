import { webcrypto } from 'node:crypto';

const encoder = new TextEncoder();
const allowedSlots = new Set(['passkey-prf', 'recovery-phrase']);
const keyLength = 32;
const nonceLength = 12;
const saltLength = 32;
const maxPayloadLength = 32 * 1024 * 1024;

function randomBytes(length) {
  const bytes = new Uint8Array(length);
  webcrypto.getRandomValues(bytes);
  return bytes;
}

function toBase64Url(bytes) {
  let binary = '';
  for (let offset = 0; offset < bytes.length; offset += 0x8000) {
    binary += String.fromCharCode(...bytes.subarray(offset, offset + 0x8000));
  }
  return btoa(binary).replaceAll('+', '-').replaceAll('/', '_').replace(/=+$/u, '');
}

function fromBase64Url(value) {
  if (typeof value !== 'string' || !/^[A-Za-z0-9_-]+$/u.test(value) || value.length % 4 === 1) {
    throw new Error('Invalid backup envelope.');
  }
  const base64 = value.replaceAll('-', '+').replaceAll('_', '/')
    + '='.repeat((4 - value.length % 4) % 4);
  const binary = atob(base64);
  return Uint8Array.from(binary, (character) => character.charCodeAt(0));
}

function validateBinding(accountBinding) {
  if (typeof accountBinding !== 'string' || accountBinding.length < 1 || accountBinding.length > 256) {
    throw new Error('Invalid account binding.');
  }
}

function validateSecret(secret) {
  if (!(secret instanceof Uint8Array) || secret.byteLength !== keyLength) {
    throw new Error('Recovery material must contain 32 bytes.');
  }
}

function payloadAdditionalData(accountBinding) {
  return encoder.encode('PoketBackup/v1/payload\u0000' + accountBinding);
}

function slotAdditionalData(slotId, accountBinding) {
  return encoder.encode('PoketBackup/v1/key-wrap\u0000' + slotId + '\u0000' + accountBinding);
}

async function deriveWrappingKey(secret, salt, slotId) {
  const inputKey = await webcrypto.subtle.importKey('raw', secret, 'HKDF', false, ['deriveKey']);
  return webcrypto.subtle.deriveKey(
    {
      name: 'HKDF',
      hash: 'SHA-256',
      salt,
      info: encoder.encode('PoketBackup/v1/wrapping-key/' + slotId),
    },
    inputKey,
    { name: 'AES-GCM', length: 256 },
    false,
    ['encrypt', 'decrypt'],
  );
}

async function importAesKey(rawKey, usages) {
  return webcrypto.subtle.importKey('raw', rawKey, { name: 'AES-GCM' }, false, usages);
}

function validateEnvelope(envelope) {
  if (
    envelope === null
    || typeof envelope !== 'object'
    || Array.isArray(envelope)
    || envelope.version !== 1
    || envelope.payloadEncryption !== 'AES-256-GCM'
    || envelope.keyDerivation !== 'HKDF-SHA-256'
    || envelope.keyWrapping !== 'AES-256-GCM'
    || !Array.isArray(envelope.keySlots)
    || envelope.keySlots.length < 1
    || envelope.keySlots.length > allowedSlots.size
  ) {
    throw new Error('Invalid or unsupported backup envelope.');
  }

  const payloadNonce = fromBase64Url(envelope.payloadNonce);
  const ciphertext = fromBase64Url(envelope.ciphertext);
  if (payloadNonce.byteLength !== nonceLength || ciphertext.byteLength < 16 || ciphertext.byteLength > maxPayloadLength + 16) {
    throw new Error('Invalid backup envelope.');
  }

  const seen = new Set();
  for (const slot of envelope.keySlots) {
    if (
      slot === null
      || typeof slot !== 'object'
      || !allowedSlots.has(slot.slotId)
      || seen.has(slot.slotId)
      || slot.keyDerivation !== 'HKDF-SHA-256'
      || slot.keyWrapping !== 'AES-256-GCM'
      || (
        slot.slotId === 'passkey-prf'
        && fromBase64Url(slot.prfInput).byteLength !== 32
      )
    ) {
      throw new Error('Invalid backup envelope.');
    }
    seen.add(slot.slotId);
    if (
      fromBase64Url(slot.keyDerivationSalt).byteLength !== saltLength
      || fromBase64Url(slot.wrappedKeyNonce).byteLength !== nonceLength
      || fromBase64Url(slot.wrappedKey).byteLength !== keyLength + 16
    ) {
      throw new Error('Invalid backup envelope.');
    }
  }
}

export async function createEnvelope(payloadBytes, recoverySlots, accountBinding) {
  validateBinding(accountBinding);
  if (!(payloadBytes instanceof Uint8Array) || payloadBytes.byteLength > maxPayloadLength) {
    throw new Error('Payload must be a Uint8Array within the PoC size limit.');
  }
  if (!Array.isArray(recoverySlots) || recoverySlots.length < 1 || recoverySlots.length > allowedSlots.size) {
    throw new Error('Provide one or two recovery slots.');
  }

  const seen = new Set();
  for (const slot of recoverySlots) {
    if (
      slot === null
      || typeof slot !== 'object'
      || !allowedSlots.has(slot.slotId)
      || seen.has(slot.slotId)
    ) {
      throw new Error('Invalid or duplicate recovery slot.');
    }
    validateSecret(slot.secret);
    if (
      slot.slotId === 'passkey-prf'
      && (!(slot.prfInput instanceof Uint8Array) || slot.prfInput.byteLength !== 32)
    ) {
      throw new Error('Passkey PRF slot requires its 32-byte PRF input.');
    }
    seen.add(slot.slotId);
  }

  const dataKey = randomBytes(keyLength);
  try {
    const payloadNonce = randomBytes(nonceLength);
    const payloadKey = await importAesKey(dataKey, ['encrypt']);
    const ciphertext = new Uint8Array(await webcrypto.subtle.encrypt(
      {
        name: 'AES-GCM',
        iv: payloadNonce,
        additionalData: payloadAdditionalData(accountBinding),
        tagLength: 128,
      },
      payloadKey,
      payloadBytes,
    ));

    const keySlots = [];
    for (const slot of recoverySlots) {
      const salt = randomBytes(saltLength);
      const wrappingNonce = randomBytes(nonceLength);
      const wrappingKey = await deriveWrappingKey(slot.secret, salt, slot.slotId);
      const wrappedKey = new Uint8Array(await webcrypto.subtle.encrypt(
        {
          name: 'AES-GCM',
          iv: wrappingNonce,
          additionalData: slotAdditionalData(slot.slotId, accountBinding),
          tagLength: 128,
        },
        wrappingKey,
        dataKey,
      ));
      keySlots.push({
        slotId: slot.slotId,
        keyDerivation: 'HKDF-SHA-256',
        keyDerivationSalt: toBase64Url(salt),
        keyWrapping: 'AES-256-GCM',
        ...(slot.slotId === 'passkey-prf'
          ? { prfInput: toBase64Url(slot.prfInput) }
          : {}),
        wrappedKeyNonce: toBase64Url(wrappingNonce),
        wrappedKey: toBase64Url(wrappedKey),
      });
    }

    return {
      version: 1,
      payloadEncryption: 'AES-256-GCM',
      keyDerivation: 'HKDF-SHA-256',
      keyWrapping: 'AES-256-GCM',
      payloadNonce: toBase64Url(payloadNonce),
      keySlots,
      ciphertext: toBase64Url(ciphertext),
    };
  } finally {
    dataKey.fill(0);
  }
}

export async function restoreEnvelope(envelope, slotId, secret, accountBinding) {
  validateBinding(accountBinding);
  validateSecret(secret);
  validateEnvelope(envelope);
  if (!allowedSlots.has(slotId)) {
    throw new Error('Unsupported recovery slot.');
  }
  const slot = envelope.keySlots.find((candidate) => candidate.slotId === slotId);
  if (slot === undefined) {
    throw new Error('Recovery slot is unavailable.');
  }

  let dataKey;
  try {
    const salt = fromBase64Url(slot.keyDerivationSalt);
    const wrappingNonce = fromBase64Url(slot.wrappedKeyNonce);
    const wrappedKey = fromBase64Url(slot.wrappedKey);
    const wrappingKey = await deriveWrappingKey(secret, salt, slotId);
    dataKey = new Uint8Array(await webcrypto.subtle.decrypt(
      {
        name: 'AES-GCM',
        iv: wrappingNonce,
        additionalData: slotAdditionalData(slotId, accountBinding),
        tagLength: 128,
      },
      wrappingKey,
      wrappedKey,
    ));
    if (dataKey.byteLength !== keyLength) {
      throw new Error('Invalid wrapped key.');
    }

    const payloadKey = await importAesKey(dataKey, ['decrypt']);
    return new Uint8Array(await webcrypto.subtle.decrypt(
      {
        name: 'AES-GCM',
        iv: fromBase64Url(envelope.payloadNonce),
        additionalData: payloadAdditionalData(accountBinding),
        tagLength: 128,
      },
      payloadKey,
      fromBase64Url(envelope.ciphertext),
    ));
  } catch {
    throw new Error('Backup could not be authenticated or decrypted.');
  } finally {
    dataKey?.fill(0);
  }
}
