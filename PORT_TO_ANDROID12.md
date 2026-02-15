# Straight Port Plan: This Vendor -> Android 12

This repository is a vendor blob dump. A "straight" Android 12 port means doing a legacy-vendor bring-up with compatibility shims and policy work.

## 1) Minimal device-tree flags to start

Use these in your device `BoardConfig.mk` / product config as a starting baseline:

```make
# Legacy vendor compatibility baseline
BOARD_VNDK_VERSION := current
PRODUCT_EXTRA_VNDK_VERSIONS := 27
PRODUCT_SHIPPING_API_LEVEL := 27

# First-boot survival switches (tighten later)
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
```

> Notes:
> - Keep this vendor mounted at `/vendor` from `vendor/oppo/cph1909`.
> - If your ROM tree uses a dedicated legacy-vendor mode (vndk-lite flow), enable it.

## 2) Keep current vendor copy strategy

`vendor.mk` already copies the entire vendor tree into `$(TARGET_COPY_OUT_VENDOR)`.
That is acceptable for first bring-up, then narrow down if needed.

## 3) First-boot goal (do this in order)

1. Boot to lockscreen/home with permissive SELinux for initial triage.
2. Get `hwservicemanager` clean enough that core HAL services register.
3. Fix RIL + data before camera.
4. Fix camera/media codecs.
5. Move to SELinux enforcing and remove temporary hacks.

## 4) Expected high-risk subsystems

- RIL/IMS stack (Mediatek multi-HAL radio interfaces)
- Camera provider and vendor camera extension services
- OMX/media codecs
- Biometrics (multiple fingerprint vendor services in manifest)

## 5) Quick validation command

Run:

```bash
./tools/check-android12-readiness.sh
```

This script surfaces known compatibility pressure points before full ROM bring-up.

## 6) Realistic outcome

- **Possible:** Android 12 boot + mostly working daily driver after iterative fixes.
- **Not realistic:** One-shot "no-modification" direct port.
