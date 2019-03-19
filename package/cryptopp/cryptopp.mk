################################################################################
#
# cryptopp
#
################################################################################

CRYPTOPP_VERSION = 8.0.0
CRYPTOPP_SOURCE = cryptopp$(subst .,,$(CRYPTOPP_VERSION)).zip
CRYPTOPP_SITE = https://cryptopp.com
CRYPTOPP_LICENSE = BSL-1.0
CRYPTOPP_LICENSE_FILES = License.txt
CRYPTOPP_INSTALL_STAGING = YES

define CRYPTOPP_EXTRACT_CMDS
	$(UNZIP) $(CRYPTOPP_DL_DIR)/$(CRYPTOPP_SOURCE) -d $(@D)
endef

define HOST_CRYPTOPP_EXTRACT_CMDS
	$(UNZIP) $(HOST_CRYPTOPP_DL_DIR)/$(CRYPTOPP_SOURCE) -d $(@D)
endef

CRYPTOPP_MAKE_COMMAND = $(MAKE) $(TARGET_CONFIGURE_OPTS) -f GNUmakefile-cross CXXFLAGS+="-mfloat-abi=softfp -mfpu=neon"
HOST_CRYPTOPP_MAKE_COMMAND = $(MAKE) -f GNUmakefile

define CRYPTOPP_BUILD_CMDS
	$(CRYPTOPP_MAKE_COMMAND) -C $(@D) shared
endef

define CRYPTOPP_INSTALL_STAGING_CMDS
	$(CRYPTOPP_MAKE_COMMAND) -C $(@D) PREFIX=$(STAGING_DIR)/usr install
endef

define CRYPTOPP_INSTALL_TARGET_CMDS
	$(CRYPTOPP_MAKE_COMMAND) -C $(@D) PREFIX=$(TARGET_DIR)/usr install
endef

HOST_CRYPTOPP_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	CXXFLAGS="$(HOST_CXXFLAGS) -fPIC"

define HOST_CRYPTOPP_BUILD_CMDS
	$(HOST_CRYPTOPP_MAKE_COMMAND) -C $(@D) $(HOST_CRYPTOPP_MAKE_OPTS) shared
endef

define HOST_CRYPTOPP_INSTALL_CMDS
	$(HOST_CRYPTOPP_MAKE_COMMAND) -C $(@D) PREFIX=$(HOST_DIR)/usr install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
