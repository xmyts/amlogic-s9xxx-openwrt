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
rm -f package/feeds/luci/luci-app-gowebdav



./scripts/feeds install -p NueXini_Packages luci-app-qbittorrent
./scripts/feeds install -p NueXini_Packages luci-app-gowebdav

#京东云自动签到
git clone https://github.com/noiver/luci-app-jd-dailybonus  package/luci-app-jd-dailybonus

git clone https://github.com/esirplayground/luci-app-poweroff.git  package/luci-app-poweroff
rm -f  target/linux/amlogic 
rm -f  tools/libdeflate/Makefile 
rm -f  Makefile

[ -f "../config/amlogic.tar.gz" ] && tar -zxf "../config/amlogic.tar.gz" -C "target/linux/" || echo "警告：未找到amlogic.tar.gz，跳过解压"

[ -f "../config/Makefile-libdeflate" ] && mkdir -p "tools/libdeflate/" && cp -f "../config/Makefile-libdeflate" "tools/libdeflate/Makefile" || echo "警告：未找到Makefile-libdeflate，跳过复制"


[ -f "../config/Makefile-lede" ] && mkdir -p "tools/libdeflate/" && cp -f "../config/Makefile-lede" "Makefile" || echo "警告：未找到Makefile-lede，跳过复制"

