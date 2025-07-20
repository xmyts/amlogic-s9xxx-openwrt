#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add autocore support for armsr-armv8
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armsr/g' package/lean/autocore/Makefile

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/lean/default-settings/files/zzz-default-settings
echo "DISTRIB_SOURCECODE='lede'" >>package/base-files/files/etc/openwrt_release

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------

# ============== 新增: 修复 Qt5 编译依赖 ==============
# 确保使用 Qt5 而非 Qt6
echo "CONFIG_PACKAGE_qt6base=n" >> .config
echo "CONFIG_PACKAGE_qt6base-dbus=n" >> .config
echo "CONFIG_PACKAGE_qt5base=y" >> .config
echo "CONFIG_PACKAGE_qt5-dbus=y" >> .config  # 确保 Qt5 DBus 组件启用
echo "CONFIG_PACKAGE_qt5tools=y" >> .config  # 确保 Qt5 工具链启用

# 修正 qttools 的依赖配置（强制依赖 Qt5）
if [ -f "feeds/packages/libs/qttools/Makefile" ]; then
    sed -i 's/DEPENDS:=+qt6-base/DEPENDS:=+qt5-base +qt5-dbus/g' feeds/packages/libs/qttools/Makefile
fi

# 确保工具链目录存在
if [ ! -d staging_dir/toolchain-* ]; then
    make toolchain/install -j$(nproc) V=s
fi

# 修复 musl 库路径（保留原有逻辑）
TOOLCHAIN_DIR=$(ls -d staging_dir/toolchain-* | head -1)
if [ -n "$TOOLCHAIN_DIR" ] && [ ! -f $TOOLCHAIN_DIR/lib/ld-musl-*.so* ]; then
    cp -f $TOOLCHAIN_DIR/usr/lib/ld-musl-*.so* $TOOLCHAIN_DIR/lib/
fi

# 验证 Qt5 DBus 库是否存在（关键检查）
echo "Checking for Qt5 DBus library..."
QT5_DBUS_LIB="staging_dir/target-$(grep CONFIG_TARGET_ARCH .config | cut -d= -f2)/usr/lib/libQt5DBus.a"
if [ ! -f "${QT5_DBUS_LIB}" ]; then
    echo "::warning::Qt5 DBus library not found. Will be built during compilation."
fi
