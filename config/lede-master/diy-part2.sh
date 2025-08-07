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

rm -f package/feeds/luci/luci-app-qbittorrent


./scripts/feeds install -p NueXini_Packages luci-app-qbittorrent

#京东云自动签到
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus package/luci-app-jd-dailybonus

git clone https://github.com/esirplayground/luci-app-poweroff.git  package/luci-app-poweroff
