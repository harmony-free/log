# wechat

#### Description [中文](README.md)

This is the HONAM version that outputs logs through the log console. By shaking the phone, the console logs will be displayed, enabling us to quickly locate the problem and accurately identify it.

#### Software Architecture 

Utilize the AOP aspect capabilities provided by the Aspect tool class to implement monitoring and printing of log messages. Open the console log output page by shaking the mobile phone.
#### Installation

`ohpm install @free/log`

#### Instructions

```
// Enable log monitoring. 20 degree shaking amplitude.
openLog(20)

// Disable log monitoring
closeLog()
```

#### Plugin Details

Hello everyone, welcome! Today, we will talk about the commonly used log logging in HarmonyOS. During the development process, logging is basically indispensable. Logging can help us quickly locate and identify problems. However, sometimes during the development process, the testers who show the bugs on their phones cannot directly locate the problems even when the developers are present. It would be great if the console logging could be displayed on the phone, right? Today, we will discuss how to use the AOP aspect capabilities provided by the Aspect tool class to implement monitoring and logging, as well as how to open the console log output page by shaking the phone.

一、Monitor and print logs through the AOP aspect capabilities of the Aspect tool class


1、Add the "logAfter" monitoring method to the **log** printing method

```arkts
util.Aspect.addAfter(console, 'log', true, this.logAfter)
```

2、The **logAfter** monitoring method records the log entries into the **logList**

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


二、Open the console output log page by shaking the mobile phone.

1、Configure the permissions for the mobile phone sensors

![](https://alliance-communityfile-drcn.dbankcdn.com/FileServer/getFile/cmtybbs/137/390/427/0080086000137390427.20250620152245.61312931180856484751854223995045:50001231000000:2800:94EC2C005BD347DB6606A510B2B7412FE60BAFCD0A37F374B618F56285F4511E.png)

2、Monitor the mobile phone sensors and open the console output log page


```arkts
sensors = sensor.getSensorListSync()
// Start listening
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
// Turn off the listening function
close(){
    try {
      sensor.off(sensor.SensorId.ACCELEROMETER, this.action.bind(this));
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      console.error(`Failed to invoke on. Code: ${e.code}, message: ${e.message}`);
    }
}
// Open the console log page
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


Note: The complete code has been submitted to[Hongmeng Tripartite Library](https://ohpm.openharmony.cn/#/cn/home),Use the following command to install.


```
ohpm install @free/log
```


The calling method: The onCreate and onDestroy methods in the EntryAbility class respectively invoke the following two methods

```arkts
// Start log monitoring
Log.open()
// Disable log monitoring
Log.close()
```

If you like this content, please give a little heart!



#### Contribution

1.  Fork the repository
2.  Create Feat_xxx branch
3.  Commit your code
4.  Create Pull Request


#### Gitee Feature

1.  You can use Readme\_XXX.md to support different languages, such as Readme\_en.md, Readme\_zh.md
2.  Gitee blog [blog.gitee.com](https://blog.gitee.com)
3.  Explore open source project [https://gitee.com/explore](https://gitee.com/explore)
4.  The most valuable open source project [GVP](https://gitee.com/gvp)
5.  The manual of Gitee [https://gitee.com/help](https://gitee.com/help)
6.  The most popular members  [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
