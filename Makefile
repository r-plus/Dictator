ARCHS = armv7
TARGET = iphone:latest:5.1
include theos/makefiles/common.mk

TWEAK_NAME = Dictator
Dictator_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = DictatorSettings
DictatorSettings_FILES = DCPreferenceController.m
DictatorSettings_INSTALL_PATH = /Library/PreferenceBundles
DictatorSettings_FRAMEWORKS = UIKit
DictatorSettings_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Dictator.plist$(ECHO_END)
