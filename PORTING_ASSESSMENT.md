# Port Feasibility: Oppo A5s Vendor (Android 8.1-era) to Android 12/13

## Short answer
- **Android 12:** **Possibly yes** for a community/experimental ROM, but still high effort and not guaranteed fully stable.
- **Android 13:** Much harder; generally R&D-only unless you have newer blobs.

## Why Android 12 is more realistic than Android 13

From this tree:
1. Vendor launch level is old (`ro.product.first_api_level=27`), so there is a large framework/vendor gap either way.
2. VINTF matrices are minimal and carry placeholder VNDK (`0.0.0`), so compatibility plumbing must be custom.
3. HAL stack is heavily legacy HIDL with many low versions (common on Oreo/Pie vendors).
4. SELinux manifest policy version is `27.0`, so policy compatibility work is substantial.

Android 12 still tolerates legacy-vendor bring-up paths (with shims + compatibility work) better than Android 13 in many practical device-port scenarios.

## Practical expectation for Android 12

Likely outcome if you proceed carefully:
- **Boot to UI:** often achievable.
- **Core telephony/data:** possible, but modem/RIL quirks expected.
- **Camera/media/fingerprint/IMS:** highest risk areas; may be partially working for a while.
- **Stability/perf:** depends heavily on shim quality and SELinux cleanup.

## What you would need

- Legacy-vendor strategy (often vndk-lite style approach, symbol shims, service adaptation).
- Device tree + init + manifest/matrix adjustments for old HIDL services.
- Significant SELinux bring-up and policy mapping.
- Focused subsystem debugging in this order:
  1. Boot/SurfaceFlinger/audio
  2. RIL + mobile data
  3. Camera + media codecs
  4. Biometrics + sensors + IMS features

## Recommendation

If your goal is a usable port:
1. Target **Android 12 first** (yes, feasible enough to try).
2. Freeze and stabilize major hardware.
3. Only then evaluate Android 13 migration.
