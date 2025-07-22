# wechat

#### 介绍 [English](README.en.md)

这是鸿蒙版本基于log控制台输出日志，通过摇晃手机弹出控制台输出日志，为我们快速的定位问题，找准的找到问题。

#### 软件架构

使用Aspect工具类提供的AOP切面能力实现监控打印日志，通过摇晃手机打开控制台输出日志页面。

#### 安装教程

`ohpm install @free/log`

#### 使用说明

```
// 开启日志监控 20 摇晃幅度
openLog(20)

// 关闭日志监控
closeLog()
```

#### 插件明细

hello 各位同学，大家好！ 今天我们来讲讲关于鸿蒙里常用的log日志打印，在开发的过程中基本上离不开打印日志，打印日志能够为我们快速的定位问题，找准的找到问题，但是有时候在在开发过程中，测试的同学拿着手机上展示的bug找到开发时开发也无法直观的定位问题，如果把控制台的打印能够在手机上打印那该多好啊，对吧！今天要讲的就是如何Aspect工具类提供的AOP切面能力实现监控打印日志，以及通过摇晃手机打开控制台输出日志页面。

一、通过Aspect工具类AOP切面能力监控打印日志


1、对log打印方法添加logAfter监控方法

```arkts
util.Aspect.addAfter(console, 'log', true, this.logAfter)
```

2、logAfter监控方法实现日志留痕到logList

```arkts
logAfter: (instance: console, method: string, arg: string, ...args: object[]) => void  = (instance: console, method: string, arg: string, ...args: object[]) => {
      let msg = arg
      if (args != undefined) {
        args.forEach((a) => {
          msg += JSON.stringify(a)
        })
      }
      this.logList.push(new LogModel(msg))
    }
```


二、通过摇晃手机打开控制台输出日志页面

1、配置手机传感器权限

![](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/137/390/427/0080086000137390427.20250620152245.61312931180856484751854223995045:50001231000000:2800:94EC2C005BD347DB6606A510B2B7412FE60BAFCD0A37F374B618F56285F4511E.png)

2、监听手机传感器并打开控制台输出日志页面


```arkts
sensors = sensor.getSensorListSync()
// 开始监听
open() {
    if (this.findSensor(sensor.SensorId.ACCELEROMETER)){
      try {
        sensor.on(sensor.SensorId.ACCELEROMETER, this.action.bind(this));
      } catch (error) {
        let e: BusinessError = error as BusinessError;
        console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
      }
    }else{
      console.error(`not find id with ${sensor.SensorId.ACCELEROMETER}`);
    }
}
// 关闭监听
close(){
    try {
      sensor.off(sensor.SensorId.ACCELEROMETER, this.action.bind(this));
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
}
// 打开控制台日志页面
action(data: sensor.GyroscopeResponse){
    if ((data.x > this.num || data.y > this.num || data.z > this.num) && (this.isOn)) {
      this.isOn = false
      if (this.type === "router"){
        router.pushNamedRoute({name:"log"})
      }else {
        nav.push("log").then(() => {
          this.isOn = true
        })
      }
    }
}
```


注意：完整代码我已提交到[鸿蒙三方库](https://ohpm.openharmony.cn/#/cn/home)中，使用一下命令安装


```
ohpm install @free/log
```


调用方式，在 EntryAbility 中的onCreate和onDestroy分别调用下面两个方法


```arkts
// 开启日志监控
Log.open()
// 关闭日志监控
Log.close()
```

喜欢本篇内容的话给个小爱心！





#### 参与贡献

1. Fork 本仓库
2. 新建 Feat_xxx 分支
3. 提交代码
4. 新建 Pull Request

#### 特技

1. 使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2. Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3. 你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4. [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5. Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6. Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
