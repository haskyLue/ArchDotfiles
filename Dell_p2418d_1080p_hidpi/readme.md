1. `sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool YES` 开启hidpi

2. 生成显示器型号相应的hidpi分辨率
  `ioreg -l | grep DisplayVendorID` 16进制文件夹
  `ioreg -l | grep DisplayVendorID` 16进制文件名 DisplayVendorID-XXXX

  比如我想使用`1600x*900`这个HiDPI,那么我就需要生成两个分辨率,其中一个是`1600*x900`,一个是其双倍,`3200*x1800`
  1600,900        00000640 00000384 00000001 00200000
  3200,1800       00000C80 00000708 00000001 00200000


3. 安装rdm切换

> 记得关闭sip