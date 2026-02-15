# Android 8.1 Vendor -> Android 13 Port Feasibility (Oppo A5s / MT6765)

## Verdict
A direct vendor-only port from this Android 8.1-era vendor stack to Android 13 is **not realistically feasible for a stable build**. It may be possible to force partial boot with heavy compatibility hacks, but expect major breakage in radio/camera/media/SELinux and long-term maintenance pain.

## Evidence from this vendor tree

1. The vendor declares first API level 27 (Android 8.1 launch level), which means old vendor interface expectations.
2. VINTF files in this tree are minimal and use placeholder VNDK versions (`0.0.0`), indicating this dump is not A13-ready as-is.
3. The device manifest is almost entirely HIDL-era HALs (many 1.0/2.x services), while Android 13 ecosystems increasingly rely on newer interface levels and AIDL migrations in several subsystems.
4. SELinux policy version is `27.0`, so platform-side sepolicy compatibility and mapping burden is high when targeting Android 13.

## What this means in practice

To attempt Android 13 anyway, you would need all of the following:

- A strong **legacy-vendor compatibility** strategy (often "vndk-lite" + extensive shims).
- Large sepolicy bring-up effort with many custom allow rules and compatibility mappings.
- Interface adaptation for old HAL/service expectations (manifest/matrix surgery + service renames/overrides).
- Likely subsystem rewrites/workarounds for:
  - RIL/IMS stack
  - Camera provider and vendor camera extensions
  - Media codecs/OMX path
  - Biometrics/fingerprint
  - Thermal/power hints

## Recommended path

- Prefer porting to **Android 11/12 first**, then step to 13.
- If Android 13 is mandatory, scope as an R&D effort (not production) unless you can source newer vendor blobs from a closer Android base for the same SoC family.
