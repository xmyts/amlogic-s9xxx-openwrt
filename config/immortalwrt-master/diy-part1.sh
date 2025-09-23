#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default

# other
# rm -rf package/emortal/{autosamba,ipv6-helper}

# 更新软件包列表
# sudo apt update

# 安装 help2man
# sudo apt install -y help2man
sed -i '$a src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git' feeds.conf.default 
rm -rf feeds/NueXini_Packages/{qbittorrent,qt6base,qt6tools,rblibtorrent,luci-app-qbittorrent}

# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default

sed -i '$a src-git qbittorrent https://github.com/xmyts/luci-app-qbittorrent.git' feeds.conf.default


cat > target/linux/armsr/armv8/target.mk << 'EOF'
ARCH:=aarch64
SUBTARGET:=armv8
BOARDNAME:=64-bit (armv8) machines
CPU_TYPE:=cortex-a73
CPU_CFLAGS_cortex-a73:=-mcpu=cortex-a73

define Target/Description
  Build multi-platform images for the ARMv8 instruction set architecture
endef
EOF
