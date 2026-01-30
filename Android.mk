LOCAL_PATH := $(call my-dir)

VENDOR_FILES := \
    build.prop \
    default.prop \
    manifest.xml \
    compatibility_matrix.xml

include $(CLEAR_VARS)
LOCAL_MODULE := vendor_oppo_cph1909
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(VENDOR_FILES)
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)
include $(BUILD_PREBUILT)
