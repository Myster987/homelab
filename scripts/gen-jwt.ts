// JWT generator with public key
// no imports needed, run with Bun.js

const access = "rw";

// ---------- helpers ----------
function base64url(bytes: ArrayBuffer | Uint8Array) {
  const bin =
    typeof bytes === "string"
      ? bytes
      : String.fromCharCode(...new Uint8Array(bytes));

  return btoa(bin).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function encode(obj: any) {
  return base64url(new TextEncoder().encode(JSON.stringify(obj)));
}

// ---------- generate keypair ----------
const keyPair = await crypto.subtle.generateKey({ name: "Ed25519" }, true, [
  "sign",
  "verify",
]);

// ---------- export public key ----------
const rawPublicKey = await crypto.subtle.exportKey("raw", keyPair.publicKey);

const publicKeyB64 = base64url(rawPublicKey);
console.log("Public Key:\n", publicKeyB64);

// ---------- create JWT ----------
const header = encode({
  alg: "EdDSA",
  typ: "JWT",
});

const payload = encode({
  a: access,
  iat: Math.floor(Date.now() / 1000),
});

const data = `${header}.${payload}`;

// ---------- sign ----------
const signature = await crypto.subtle.sign(
  "Ed25519",
  keyPair.privateKey,
  new TextEncoder().encode(data),
);

const jwt = `${data}.${base64url(signature)}`;

console.log("JWT:\n", jwt);
