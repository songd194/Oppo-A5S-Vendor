LOCAL_PATH := $(call my-dir)

# Helper function
define add-vendor-asset
    include $(CLEAR_VARS)
    LOCAL_MODULE := $(1)
    LOCAL_SRC_FILES := $(1)
    LOCAL_MODULE_CLASS := ETC
    LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)
    include $(BUILD_PREBUILT)
endef

# Only the .prop files go here now
$(eval $(call add-vendor-asset,build.prop))
$(eval $(call add-vendor-asset,default.prop))