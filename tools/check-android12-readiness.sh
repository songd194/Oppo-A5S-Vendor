#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

pass() { echo "[PASS] $*"; }
warn() { echo "[WARN] $*"; }
info() { echo "[INFO] $*"; }

info "Checking vendor readiness signals for Android 12 bring-up in: $ROOT_DIR"

BUILD_PROP="$ROOT_DIR/build.prop"
MANIFEST="$ROOT_DIR/manifest.xml"
DMATRIX="$ROOT_DIR/compatibility_matrix.xml"
FMATRIX="$ROOT_DIR/framework_matrix.xml"

for f in "$BUILD_PROP" "$MANIFEST" "$DMATRIX" "$FMATRIX"; do
  if [[ ! -f "$f" ]]; then
    echo "[FAIL] Missing required file: $f"
    exit 1
  fi
done

api_level="$(awk -F= '$1=="ro.product.first_api_level"{print $2}' "$BUILD_PROP" | tail -n1)"
if [[ -z "$api_level" ]]; then
  warn "ro.product.first_api_level missing in build.prop"
elif (( api_level <= 27 )); then
  warn "Launch API level is $api_level (legacy vendor). Expect shim + sepolicy heavy bring-up on Android 12."
else
  pass "Launch API level is $api_level"
fi

for matrix in "$DMATRIX" "$FMATRIX"; do
  matrix_name="$(basename "$matrix")"
  if rg -q '<version>0\.0\.0</version>' "$matrix"; then
    warn "$matrix_name includes VNDK placeholder 0.0.0"
  else
    pass "$matrix_name does not contain VNDK placeholder 0.0.0"
  fi
done

if rg -q -U '<sepolicy>\s*\n\s*<version>27\.0</version>' "$MANIFEST"; then
  warn "Manifest sepolicy level is 27.0; expect significant policy mapping/compat work for Android 12"
else
  info "Manifest sepolicy is not exactly 27.0"
fi

legacy_hidl_count="$(rg -c '<version>1\.0</version>|<version>2\.[0-4]</version>' "$MANIFEST" || true)"
info "Manifest contains $legacy_hidl_count low-version HAL declarations (1.0/2.0-2.4 patterns)."

echo
info "Suggested next steps:"
echo "  1) Build Android 12 with this vendor + permissive sepolicy for first boot only."
echo "  2) Fix VINTF/manifest mismatch and init service names."
echo "  3) Bring up RIL/data, then camera/media, then biometrics/IMS."
echo "  4) Enforce SELinux and remove temporary shims incrementally."
