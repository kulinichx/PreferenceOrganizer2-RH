ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0
THEOS_PACKAGE_SCHEME ?= roothide
INSTALL_TARGET_PROCESSES = Preferences

THEOS_PACKAGE_DIR_NAME = packages

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = PreferenceOrganizer2
PreferenceOrganizer2_FILES = PreferenceOrganizer2.xm PO2Log.mm
PreferenceOrganizer2_FRAMEWORKS = UIKit Foundation
PreferenceOrganizer2_PRIVATE_FRAMEWORKS = Preferences
# Original code is MRC (no ARC); silence legacy-API warnings so -Werror doesn't trip
PreferenceOrganizer2_CFLAGS = -Wno-deprecated-declarations -Wno-unused-function -Wno-unused-variable -Wno-objc-method-access -Wno-incompatible-pointer-types -Wno-sign-compare -Wno-int-conversion -Wno-shorten-64-to-32 -Wno-unused-but-set-variable -Wno-error

ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
PreferenceOrganizer2_CFLAGS += -DPO2_ROOTHIDE
PreferenceOrganizer2_LIBRARIES += roothide
else ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
PreferenceOrganizer2_CFLAGS += -DPO2_ROOTLESS
endif

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += POPreferences
include $(THEOS_MAKE_PATH)/aggregate.mk
