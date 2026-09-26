ARCHS = arm64 arm64e
TARGET = iphone:clang:16.5:15.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = POPreferences
POPreferences_FILES = POPreferences.mm
POPreferences_INSTALL_PATH = /Library/PreferenceBundles
POPreferences_FRAMEWORKS = UIKit
POPreferences_PRIVATE_FRAMEWORKS = Preferences
POPreferences_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -Wno-unused-function

ifeq ($(THEOS_PACKAGE_SCHEME),roothide)
POPreferences_CFLAGS += -DPO2_ROOTHIDE
else ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
POPreferences_CFLAGS += -DPO2_ROOTLESS
endif

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/PreferenceOrganizer2.plist$(ECHO_END)
