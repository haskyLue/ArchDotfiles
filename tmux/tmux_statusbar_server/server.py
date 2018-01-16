#!/usr/local/bin/python3
# -*- coding: UTF-8 -*-

import sh
import re
import time
import signal, os
import sys

# from pid.decorator import pidfile


# ONLY FOR OSX
class TmuxBar:
    # __tmux_color_tmpl = u"#[fg=black]#[bg=colour237]#[bg=colour237]#[fg=TMUX_COLOR,none] TMUX_LABEL TMUX_CONTENT #[fg=colour237]#[bg=default]"
    __tmux_color_tmpl2 = u"#[fg=black]#[bg=colour237]#[bg=colour237]#[fg=%s,none] %s %s #[fg=colour237]#[bg=default]"

    def __update_network_interface(self):
        self.__network_interface = sh.awk(
            sh.head(sh.netstat("-nr"), '-n5'), '/default/ {print $6}').strip()

    def __init__(self):
        # 初始化一些全局数据
        self.__flow_new = [0, 0]
        self.__flow_old = [0, 0]
        self.__stamp_old = 0
        self.__stamp_new = 0

    def wifi(self):
        self.__update_network_interface()
        if (self.__network_interface):
            mSsid = sh.awk(
                sh.networksetup("-getairportnetwork",
                                self.__network_interface),
                '{print $4}').strip()
            mIp = sh.awk(
                sh.ifconfig(self.__network_interface),
                '$1=="inet" {print $2}').strip()
            return mSsid + " " + mIp
        else:
            return "::"

    def batt(self):
        return sh.awk(
            sh.pmset('-g', 'batt'), '/InternalBattery/ {print $3$4}').replace(
                ";", ' ').strip()

    def traffic(self):
        def __trafficPerSecond():
            self.__flow_new = sh.awk(
                sh.netstat("-I", self.__network_interface, "-bn"),
                'NR==2 {print $7,$10}').strip().split(" ")
            self.__flow_new = [int(i) for i in self.__flow_new]
            self.__stamp_new = time.time()

            d = self.__stamp_new - self.__stamp_old
            rRate = (self.__flow_new[0] - self.__flow_old[0]) / 1000 / d
            tRate = (self.__flow_new[1] - self.__flow_old[1]) / 1000 / d

            self.__flow_old[0] = self.__flow_new[0]
            self.__flow_old[1] = self.__flow_new[1]
            self.__stamp_old = self.__stamp_new
            return (rRate, tRate)

        self.__update_network_interface()
        if (self.__network_interface):
            rate = __trafficPerSecond()
            return "%s ⇲ %.1fK ⇱ %.1fK" % (self.__network_interface, rate[0],
                                           rate[1])
        else:
            return "0.0K"

    def sysInfo(self):
        mLoad = re.sub(".*averages: ", "", sh.uptime().strip()).split(" ")[0]
        mVersion = sh.uname("-r").strip()
        return mVersion + " <" + mLoad + ">"

    def memory(self):
        mAvailMem = sh.awk(sh.memory_pressure(),
                           '/percent/ {print $5}').strip()
        mTopProcess = re.sub("\s+", " ",
                             sh.top("-l", "1", "-o", "mem", "-U", "hasky",
                                    "-n1", "-stats",
                                    "COMMAND,MEM").split("\n")[-2])

        return mAvailMem + " <" + mTopProcess + ">"

    def disk(self):
        mAvailMount = sh.awk(
            'NR!=1 {print $5}', _in=sh.df("-lh")).replace("\n", " ").strip()
        return mAvailMount

    # 这里就不检查参数合法性了
    def parse(color, content, label):
        return TmuxBar.__tmux_color_tmpl2 % (color.upper(), label, content)


outputfile = "/tmp/tmux_output"
pidfile = "/tmp/tmux_status.pid"


def log(content):
    sh.logger("-t", "tmux-server", content)


def __quit_handler(signum, frame):
    log("something wrong happened %d" % signum)
    os.unlink(pidfile)
    f = open(outputfile, "wb+")
    f.write(TmuxBar.parse("red", sh.date().strip(), "✗").encode('utf-8'))
    f.close()

    sys.exit()


def main():
    signal.signal(signal.SIGTERM, __quit_handler)
    signal.signal(signal.SIGINT, __quit_handler)

    tb = TmuxBar()
    while (1):
        time.sleep(1)
        # _t = time.time()
        data = "%s %s %s %s %s %s" % (
            TmuxBar.parse("green", tb.sysInfo(), "⌘"),
            TmuxBar.parse("magenta", tb.batt(), "❍"),
            TmuxBar.parse("cyan", tb.wifi(), "☫"),
            TmuxBar.parse("yellow", tb.traffic(), "⥂"),
            TmuxBar.parse("blue", tb.memory(), "◉"),
            TmuxBar.parse("red", tb.disk(), "☯"))
        # print("执行耗时 %d" % (time.time() - _t))

        f = open(outputfile, "wb+")
        f.write(data.encode('utf-8'))  # 以字节写入，否则在launchctl启动环境下会出错
        f.close()


if __name__ == "__main__":
    if os.path.isfile(pidfile):
        print("%s already exists, exiting" % pidfile)
        sys.exit()

    fp = open(pidfile, 'w')
    fp.write(str(os.getpid()))
    fp.close()
    try:
        main()
    except Exception as e:
        log(str(e))
    finally:
        __quit_handler(-1, -1)  # 参数无意义
