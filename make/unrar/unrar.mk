$(call PKG_INIT_BIN, 6.1.3)
$(PKG)_SOURCE:=unrarsrc-$($(PKG)_VERSION).tar.gz
$(PKG)_SOURCE_SHA256:=d05022442009202a792e588bec58921c123ff046fc755f7f2272871a5bd79636
$(PKG)_SITE:=https://www.rarlab.com/rar

$(PKG)_BINARY:=$($(PKG)_DIR)/unrar
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/unrar

$(PKG)_DEPENDS_ON += $(STDCXXLIB)
$(PKG)_REBUILD_SUBOPTS += FREETZ_STDCXXLIB

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_UNRAR_STATIC
ifeq ($(strip $(FREETZ_PACKAGE_UNRAR_STATIC)),y)
$(PKG)_LDFLAGS := -static
endif

$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_UCLIBC_0_9_28
$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_UCLIBC_0_9_29
ifeq ($(strip $(or $(FREETZ_TARGET_UCLIBC_0_9_28),$(FREETZ_TARGET_UCLIBC_0_9_29))),y)
$(PKG)_DEFINES += -DVFWPRINTF_WORKAROUND_REQUIRED
endif

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(UNRAR_DIR) -f makefile \
		CXX="$(TARGET_CXX)" \
		CXXFLAGS="$(TARGET_CFLAGS) -fno-rtti -fno-exceptions" \
		DEFINES="$(UNRAR_DEFINES)" \
		LDFLAGS="$(UNRAR_LDFLAGS)" \
		STRIP=true

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(SUBMAKE) -C $(UNRAR_DIR) -f makefile clean

$(pkg)-uninstall:
	$(RM) $(UNRAR_TARGET_BINARY)

$(PKG_FINISH)
