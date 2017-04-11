GO_EASY_ON_ME = 1
export TARGET=iphone:clang:latest
export ARCHS=armv7 arm64
THEOS_DEVICE_IP = 172.20.10.1

DEBUG=0
FINALPACKAGE=1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AppBreak
PalBreak_FILES = Tweak.xm
PalBreak_FRAMEWORKS = UIKit
PalBreak_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
PalBreak_INSTALL_PATH = /usr/lib/

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 PayPal SpringBoard"
SUBPROJECTS += palbreaksb
SUBPROJECTS += nosub
include $(THEOS_MAKE_PATH)/aggregate.mk
