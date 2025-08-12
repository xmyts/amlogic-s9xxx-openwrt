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
cd openwrt/
# 获取当前source_branch（从FEEDS_CONF路径中提取）
SOURCE_BRANCH=$(echo "${FEEDS_CONF}" | awk -F'/' '{print $2}')
echo "当前源分支: ${SOURCE_BRANCH}"

# 定义配置文件根目录（与环境变量FEEDS_CONF保持一致）
CONFIG_DIR="config/${SOURCE_BRANCH}"

# 正确删除目录（如果需要）
if [ -d "target/linux/amlogic" ]; then
    rm -rf "target/linux/amlogic"
    echo "已删除 target/linux/amlogic 目录"
fi

# 解压amlogic.tar.gz（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/amlogic.tar.gz" ] && tar -zxf "${CONFIG_DIR}/amlogic.tar.gz" -C "target/linux/" || echo "警告：未找到${CONFIG_DIR}/amlogic.tar.gz，跳过解压"

# 复制Makefile-libdeflate（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/Makefile-libdeflate" ] && mkdir -p "tools/libdeflate/" && cp -f "${CONFIG_DIR}/Makefile-libdeflate" "tools/libdeflate/Makefile" || echo "警告：未找到${CONFIG_DIR}/Makefile-libdeflate，跳过复制"

# 复制Makefile-lede（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/Makefile-lede" ] && cp -f "${CONFIG_DIR}/Makefile-lede" "相应的目标路径" || echo "警告：未找到${CONFIG_DIR}/Makefile-lede，跳过复制"

# -------------------------------------------------------------------------------------------------------------------------------------------

# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

sed -i '$a src-git NueXini_Packages https://github.com/NueXini/NueXini_Packages.git' feeds.conf.default 
sed -i '$a src-git small https://github.com/kenzok8/small' feeds.conf.default
