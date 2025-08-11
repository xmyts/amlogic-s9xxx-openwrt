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

# ------------------------------------------------------------------------------------------------------------------------------

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

# 克隆所需的包
git clone https://github.com/jerrykuku/luci-app-jd-dailybonus package/luci-app-jd-dailybonus
git clone https://github.com/esirplayground/luci-app-poweroff package/luci-app-poweroff

# 解压amlogic.tar.gz（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/amlogic.tar.gz" ] && tar -zxf "${CONFIG_DIR}/amlogic.tar.gz" -C "target/linux/" || echo "警告：未找到${CONFIG_DIR}/amlogic.tar.gz，跳过解压"

# 复制Makefile-libdeflate（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/Makefile-libdeflate" ] && mkdir -p "tools/libdeflate/" && cp -f "${CONFIG_DIR}/Makefile-libdeflate" "tools/libdeflate/Makefile" || echo "警告：未找到${CONFIG_DIR}/Makefile-libdeflate，跳过复制"

# 复制Makefile-lede（从config/${SOURCE_BRANCH}/目录读取）
[ -f "${CONFIG_DIR}/Makefile-lede" ] && cp -f "${CONFIG_DIR}/Makefile-lede" "相应的目标路径" || echo "警告：未找到${CONFIG_DIR}/Makefile-lede，跳过复制"

