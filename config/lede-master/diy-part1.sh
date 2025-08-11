#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic s9xxx tv box
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# other
# -----------------------------------------------------------------------------------------------------------
# 1. 解压 /config/amlogic.tar.gz 到 openwrt/target/linux/ 目录
[ -f "../config/amlogic.tar.gz" ] && tar -zxf "../config/amlogic.tar.gz" -C "target/linux/" || echo "警告：未找到../config/amlogic.tar.gz，跳过解压"

# 2. 复制 /config/Makefile-libdeflate 到 tools/libdeflate/Makefile（目录已存在，无需创建）
[ -f "../config/Makefile-libdeflate" ] && cp -f "../config/Makefile-libdeflate" "tools/libdeflate/Makefile" || echo "警告：未找到../config/Makefile-libdeflate，跳过复制"

# 2. 复制 /config/Makefile-libdeflate 到 tools/libdeflate/Makefile（目录已存在，无需创建）
[ -f "../config/Makefile-lede" ] && cp -f "../config/Makefile-lede" "Makefile" || echo "警告：未找到../config/Makefile-libdeflate，跳过复制"

# -------------------------------------------------------------------------------------------------------------------------------------------

# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

sed -i '$a src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git' feeds.conf.default 
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
