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


# -------------------------------------------------------------------------------------------------------------------------------------------

# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

# sed -i '$a src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git' feeds.conf.default 
# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
# sed -i '$a src-git smpackage https://github.com/kenzok8/small-package' feeds.conf.default
# rm -rf feeds/smpackage/{base-files,dnsmasq,firewall*,fullconenat,libnftnl,nftables,ppp,opkg,ucl,upx,vsftpd*,miniupnpd-iptables,wireless-regdb}
# sed -i '$a src-git qbittorrent https://github.com/xmyts/luci-app-qbittorrent.git' feeds.conf.default
# git clone https://github.com/noiver/luci-app-jd-dailybonus  package/luci-app-jd-dailybonus
#
cat > target/linux/armsr/armv8/target.mk << 'EOF'
ARCH:=aarch64
SUBTARGET:=armv8
BOARDNAME:=64-bit (armv8) machines
CPU_TYPE:=cortex-a73
CPU_CFLAGS_cortex-a73:=-march=armv8-a+crypto+simd+crc -mtune=cortex-a73

define Target/Description
  Build multi-platform images for the ARMv8 instruction set architecture
endef
EOF
