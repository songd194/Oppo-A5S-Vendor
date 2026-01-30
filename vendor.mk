PRODUCT_SOONG_NAMESPACES += vendor/oppo/cph1909

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/oppo/cph1909,$(TARGET_COPY_OUT_VENDOR))
