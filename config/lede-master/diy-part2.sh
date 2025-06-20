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
# 微信推送
rm -rf feeds/kenzo/luci-app-wechatpush
rm -rf feeds/luci/applications/luci-app-serverchan
git clone -b openwrt-18.06 https://github.com/tty228/luci-app-serverchan.git feeds/luci/applications/luci-app-serverchan

# luci-app-adguardhome
rm -rf feeds/kenzo/luci-app-adguardhome
git clone https://github.com/Zane-E/luci-app-adguardhome.git feeds/kenzo/luci-app-adguardhome

# filebrowser
rm -rf feeds/kenzo/luci-app-filebrowser
git clone -b 18.06 https://github.com/xiaozhuai/luci-app-filebrowser feeds/kenzo/luci-app-filebrowser
merge_package https://github.com/Lienol/openwrt-package openwrt-package/luci-app-filebrowser

# mosdns
rm -rf feeds/kenzo/luci-app-mosdns
rm -rf feeds/packages/net/mosdns
rm -rf feeds/luci/applications/luci-app-mosdns
merge_package https://github.com/sbwml/luci-app-mosdns luci-app-mosdns
merge_package https://github.com/sbwml/luci-app-mosdns luci-app-mosdns/mosdns

# poweroff
git clone https://github.com/esirplayground/luci-app-poweroff.git

# v2raya   代理服务器
merge_package https://github.com/v2rayA/v2raya-openwrt v2raya-openwrt/v2raya
merge_package https://github.com/v2rayA/v2raya-openwrt v2raya-openwrt/luci-app-v2raya


#OpenAppFilter
git clone https://github.com/destan19/OpenAppFilter.git package/OpenAppFilter    
echo "CONFIG_PACKAGE_luci-app-oaf=y" >>.config
# ------------------------------- Other ends -------------------------------
# 进入package/libs目录
cd /builder/openwrt/package/libs

# 更新elfutils配置
rm -rf elfutils
git clone https://sourceware.org/git/elfutils.git elfutils

# 或者修改Makefile中的版本号为最新版本
cd openwrt/
# 搜索并安装libelf包
./scripts/feeds search libelf
# 输出类似：libelf - ELF file format library
./scripts/feeds install libelf
