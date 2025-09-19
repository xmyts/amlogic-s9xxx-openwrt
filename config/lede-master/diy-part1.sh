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

sed -i '$a src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git' feeds.conf.default 
# sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
sed -i '$a src-git qbittorrent https://github.com/JSZMonkey/luci-app-qbittorrent.git' feeds.conf.default
git clone https://github.com/noiver/luci-app-jd-dailybonus  package/luci-app-jd-dailybonus
