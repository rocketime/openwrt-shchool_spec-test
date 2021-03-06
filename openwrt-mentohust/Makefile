#
# Copyright (C) 2006-2017 
#
# Modify by Rocketime at 2017.10
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=mentohust-vn
PKG_VERSION:=0.n.7
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/rocketime/mentohust-v.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=003907df2dbf72f3effe00c4f8b48f19681ebb0f

PKG_LICENSE:=GPLv3

PKG_BUILD_PARALLEL:=1
PKG_INSTALL:=1
# PKG_FIXUP:=autoreconf

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	DEPENDS:=+libpcap +libintl +libiconv
	TITLE:=Open-source alternative to rjsupplicant
	URL:=https://github.com/rocketime/mentohust-v4.git

endef

define Package/$(PKG_NAME)/description
Open-source alternative to rjsupplicant.
endef

define Build/Prepare
	$(call Build/Prepare/Default)
	$(SED) 's/dhclient/udhcpc -i/g' $(PKG_BUILD_DIR)/src/myconfig.c
endef

CONFIGURE_ARGS += \
	--disable-encodepass \
	--disable-notify \
	--with-pcap=dylib

define Build/Configure
	( cd $(PKG_BUILD_DIR); ./autogen.sh )
	$(call Build/Configure/Default)
endef

# XXX: CFLAGS are already set by Build/Compile/Default
MAKE_FLAGS+= \
	OFLAGS=""

define Package/$(PKG_NAME)/conffiles
/etc/$mentohust.conf
endef

define Package/$(PKG_NAME)/install
	mkdir -p $(PKG_INSTALL_DIR)/usr/bin
	mkdir -p $(PKG_INSTALL_DIR)/etc
	$(CP) $(PKG_BUILD_DIR)/src/mentohust $(PKG_INSTALL_DIR)/usr/bin/mentohust
	$(CP) $(PKG_BUILD_DIR)/src/mentohust.conf $(PKG_INSTALL_DIR)/etc/mentohust.conf
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/mentohust $(1)/usr/sbin/
	chmod 755 $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_CONF) $(PKG_INSTALL_DIR)/etc/mentohust.conf $(1)/etc/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
