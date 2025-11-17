#!/system/bin/sh

# 检查是否在 Android 设备上运行
if [ ! -d "/system" ]; then
    echo "错误: 此脚本需要在 Android 设备上运行"
    exit 1
fi

# 设备信息
echo "=== 设备基本信息 ==="
echo "设备型号: $(getprop ro.product.model)"
echo "制造商: $(getprop ro.product.manufacturer)"
echo "品牌: $(getprop ro.product.brand)"
echo "Android 版本: $(getprop ro.build.version.release)"
echo "构建ID: $(getprop ro.build.id)"
echo

# 内存信息
echo "=== 内存信息 ==="
cat /proc/meminfo | grep -E "MemTotal|MemFree|MemAvailable"
echo

# CPU 信息
echo "=== CPU 信息 ==="
echo "处理器数量: $(grep -c processor /proc/cpuinfo)"
cat /proc/cpuinfo | grep "model name" | head -1
echo "CPU 架构: $(getprop ro.product.cpu.abi)"
echo

# 存储信息
echo "=== 存储信息 ==="
df -h | grep -E "/data|/system|/storage"
echo

# 电池信息
if [ -f "/sys/class/power_supply/battery/capacity" ]; then
    echo "=== 电池信息 ==="
    echo "电量: $(cat /sys/class/power_supply/battery/capacity)%"
    echo "状态: $(cat /sys/class/power_supply/battery/status)"
    echo "健康: $(cat /sys/class/power_supply/battery/health)"
    echo "温度: $(($(cat /sys/class/power_supply/battery/temp)/10))°C"
    echo
fi

# 网络信息
echo "=== 网络信息 ==="
ip addr show | grep "inet " | grep -v "127.0.0.1"
echo

# 屏幕信息
if [ -f "/sys/class/graphics/fb0/virtual_size" ]; then
    echo "=== 屏幕信息 ==="
    resolution=$(cat /sys/class/graphics/fb0/virtual_size)
    echo "分辨率: ${resolution/,/x}"
    echo
fi

echo "信息收集完成"
