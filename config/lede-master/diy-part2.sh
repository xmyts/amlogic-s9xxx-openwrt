#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
# Add autocore support for armsr-armv8
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armsr/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
# ------------------------------- Other ends -------------------------------

# ============== 修复 Qt6 编译依赖 ==============
# 1. 禁用依赖缺失的包
echo "CONFIG_PACKAGE_geodata=n" >> .config
echo "CONFIG_PACKAGE_luci-app-dogcom=n" >> .config
echo "CONFIG_PACKAGE_luci-app-ssr-plus=n" >> .config
echo "CONFIG_PACKAGE_natflow=n" >> .config

# 2. 修正 qttools 依赖为 Qt6
if [ -f "feeds/packages/libs/qttools/Makefile" ]; then
    sed -i 's/DEPENDS:=+qt5-base/DEPENDS:=+qt6base +qt6base-dbus +qt6tools/g' feeds/packages/libs/qttools/Makefile
    sed -i '/qt5/d' feeds/packages/libs/qttools/Makefile
fi

# 3. 修正 qbittorrent 依赖为 Qt6（若启用）
if [ -f "feeds/smpackage/qbittorrent/Makefile" ]; then
    sed -i 's/libQt5/libQt6/g' feeds/smpackage/qbittorrent/Makefile
    sed -i 's/qt5/qt6/g' feeds/smpackage/qbittorrent/Makefile
    echo "CONFIG_PACKAGE_qbittorrent=y" >> .config
fi

# 4. 修复 musl 库路径
TOOLCHAIN_DIR=$(ls -d staging_dir/toolchain-* | head -1)
if [ -n "$TOOLCHAIN_DIR" ] && [ ! -f $TOOLCHAIN_DIR/lib/ld-musl-*.so* ]; then
    cp -f $TOOLCHAIN_DIR/usr/lib/ld-musl-*.so* $TOOLCHAIN_DIR/lib/
fi
