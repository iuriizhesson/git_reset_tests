################################################################################
#
# libpcap
#
################################################################################

LIBPCAP_VERSION = 1.9.0
LIBPCAP_SITE = http://www.tcpdump.org/release
LIBPCAP_LICENSE = BSD-3-Clause
LIBPCAP_LICENSE_FILES = LICENSE
LIBPCAP_INSTALL_STAGING = YES
LIBPCAP_DEPENDENCIES = zlib host-flex host-bison

LIBPCAP_CONF_ENV = \
	ac_cv_header_linux_wireless_h=yes \
	CFLAGS="$(LIBPCAP_CFLAGS)"
LIBPCAP_CFLAGS = $(TARGET_CFLAGS)
LIBPCAP_CONF_OPTS = --disable-yydebug --with-pcap=linux --without-dag
# 2018-10-29 amarkelov: this allows us to open CAN interfaces in SLL mode, see 0002-cooked-mode-only.patch
LIBPCAP_CONF_OPTS += --disable-can
LIBPCAP_CONFIG_SCRIPTS = pcap-config

# Omit -rpath from pcap-config output
define LIBPCAP_CONFIG_REMOVE_RPATH
	$(SED) 's/^V_RPATH_OPT=.*/V_RPATH_OPT=""/g' $(@D)/pcap-config
endef
LIBPCAP_POST_BUILD_HOOKS = LIBPCAP_CONFIG_REMOVE_RPATH

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
LIBPCAP_DEPENDENCIES += bluez_utils
else ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
LIBPCAP_DEPENDENCIES += bluez5_utils
else
LIBPCAP_CONF_OPTS += --disable-bluetooth
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
LIBPCAP_CONF_OPTS += --enable-dbus
LIBPCAP_DEPENDENCIES += dbus
else
LIBPCAP_CONF_OPTS += --disable-dbus
endif

ifeq ($(BR2_PACKAGE_LIBNL),y)
LIBPCAP_DEPENDENCIES += libnl
LIBPCAP_CFLAGS += "-I$(STAGING_DIR)/usr/include/libnl3"
LIBPCAP_CONF_OPTS += --with-libnl=$(STAGING_DIR)/usr
else
LIBPCAP_CONF_OPTS += --without-libnl
endif

# microblaze/sparc/sparc64 need -fPIC instead of -fpic
ifeq ($(BR2_microblaze)$(BR2_sparc)$(BR2_sparc64),y)
LIBPCAP_CFLAGS += -fPIC
endif

$(eval $(autotools-package))
