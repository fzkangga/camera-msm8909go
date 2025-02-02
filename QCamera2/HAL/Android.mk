LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)
LOCAL_SRC_FILES := \
        QCamera2Factory.cpp \
        QCamera2Hal.cpp \
        QCamera2HWI.cpp \
        QCameraMem.cpp \
        ../util/QCameraQueue.cpp \
        ../util/QCameraCmdThread.cpp \
        QCameraStateMachine.cpp \
        QCameraChannel.cpp \
        QCameraStream.cpp \
        QCameraPostProc.cpp \
        QCamera2HWICallbacks.cpp \
        QCameraParameters.cpp \
        CameraParameters.cpp \
        QCameraThermalAdapter.cpp \
        wrapper/QualcommCamera.cpp

LOCAL_CFLAGS = -Wall -Wextra -Werror
ifeq ($(filter OMR1 O 8.1.0, $(PLATFORM_VERSION)), )
LOCAL_CFLAGS += -march=armv7ve
endif
LOCAL_CFLAGS += -DHAS_MULTIMEDIA_HINTS

#use media extension
ifeq ($(TARGET_USES_MEDIA_EXTENSIONS), true)
LOCAL_CFLAGS += -DUSE_MEDIA_EXTENSIONS
endif

#Debug logs are enabled
#LOCAL_CFLAGS += -DDISABLE_DEBUG_LOG

#ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
#LOCAL_CFLAGS += -DUSE_VENDOR_CAMERA_EXT
#endif

ifneq ($(call is-platform-sdk-version-at-least,18),true)
LOCAL_CFLAGS += -DUSE_JB_MR1
endif

LOCAL_C_INCLUDES := \
        $(LOCAL_PATH)/../stack/common \
        frameworks/native/include/media/openmax \
        frameworks/native/libs/nativewindow/include \
        frameworks/native/libs/nativebase/include \
        frameworks/native/libs/arect/include \
        hardware/qcom/display/libgralloc1 \
        hardware/qcom/display/libqdutils \
        hardware/qcom/media/libstagefrighthw \
        system/media/camera/include \
        system/core/include/cutils \
        $(LOCAL_PATH)/../../mm-image-codec/qexif \
        $(LOCAL_PATH)/../../mm-image-codec/qomx_core \
        $(LOCAL_PATH)/../util \
        $(LOCAL_PATH)/wrapper

ifeq ($(call is-platform-sdk-version-at-least,20),true)
LOCAL_C_INCLUDES += system/media/camera/include
else
LOCAL_CFLAGS += -DUSE_KK_CODE
endif

LOCAL_C_INCLUDES += \
        $(TARGET_OUT_HEADERS)/qcom/display
LOCAL_C_INCLUDES += \
        hardware/qcom/display/libqservice

#ifeq ($(TARGET_USE_VENDOR_CAMERA_EXT),true)
#LOCAL_C_INCLUDES += hardware/qcom/display/msm8974/libgralloc
#else
LOCAL_C_INCLUDES += hardware/qcom/display/libgralloc
#endif
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_C_INCLUDES += $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include/media
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_CFLAGS += -DTARGET_TS_MAKEUP
LOCAL_C_INCLUDES += $(LOCAL_PATH)/tsMakeuplib/include
endif
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr

LOCAL_SHARED_LIBRARIES := liblog libhardware libutils libcutils libdl libsync
LOCAL_SHARED_LIBRARIES += libmmcamera_interface libmmjpeg_interface libqdMetaData
ifeq ($(TARGET_TS_MAKEUP),true)
LOCAL_SHARED_LIBRARIES += libts_face_beautify_hal libts_detected_face_hal
endif
LOCAL_SHARED_LIBRARIES += libqdMetaData libqservice libbinder

LOCAL_STATIC_LIBRARIES := android.hardware.camera.common@1.0-helper

LOCAL_MODULE_RELATIVE_PATH    := hw
LOCAL_MODULE := camera.$(TARGET_BOARD_PLATFORM)
LOCAL_VENDOR_MODULE := true
LOCAL_CLANG := false
LOCAL_32_BIT_ONLY := true
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)

ifeq ($(TARGET_USES_AOSP),false)
include $(LOCAL_PATH)/test/Android.mk
endif
