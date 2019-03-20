################################################################################
#
# microsoft-bond
#
################################################################################

#make gets confused with quoted strings
MICROSOFT_BOND_VERSION = 8.0.1
MICROSOFT_BOND_SITE = https://github.com/Microsoft/bond.git
MICROSOFT_BOND_SITE_METHOD = git

MICROSOFT_BOND_LICENSE_FILES = LICENSE
MICROSOFT_BOND_LICENSE = MIT
MICROSOFT_BOND_SUPPORTS_IN_SOURCE_BUILD = NO

MICROSOFT_BOND_DEPENDENCIES = boost host-microsoft-bond rapidjson

HOST_MICROSOFT_BOND_DEPENDENCIES = host-boost host-rapidjson host-patchelf
HOST_MICROSOFT_BOND_CONF_OPTS += -DBOND_FIND_RAPIDJSON=TRUE -DBOND_ENABLE_GRPC=FALSE -DBOND_SKIP_CORE_TESTS=YES
HOST_MICROSOFT_BOND_MAKE_ENV += CONF_CC_OPTS_STAGE2="-fno-pie" CONF_LD_LINKER_OPTS_STAGE2="-no-pie" CONF_GCC_LINKER_OPTS_STAGE2="-no-pie"

MICROSOFT_BOND_CONF_OPTS += -DBOND_FIND_RAPIDJSON=TRUE -DBOND_ENABLE_GRPC=FALSE -DBOND_GBC_PATH=$(HOST_DIR)/usr/bin/gbc -DBOND_SKIP_CORE_TESTS=YES
MICROSOFT_BOND_INSTALL_STAGING = YES
MICROSOFT_BOND_INSTALL_TARGET = NO

define HOST_MICROSOFT_BOND_GBC_PATCH_HOOK
    $(HOST_DIR)/usr/bin/patchelf --set-rpath $(HOST_DIR)/usr/lib $(HOST_DIR)/usr/bin/gbc
    echo "PATCHED host-microsoft-bond RPATH"
endef

HOST_MICROSOFT_BOND_POST_INSTALL_HOOKS += HOST_MICROSOFT_BOND_GBC_PATCH_HOOK

$(eval $(cmake-package))
$(eval $(host-cmake-package))
