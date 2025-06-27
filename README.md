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
