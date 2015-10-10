# Demo-Support-iOS

## 介绍

MLHelpCenter 的例子。MLHelpCenter 集成了用户帮助和反馈功能，这个例子演示怎么使用这些功能。

## 演示功能

- 展示 FAQ
- 用户反馈

## 效果截图

![](docs/images/1.png)
![](docs/images/2.png)
![](docs/images/3.png)
![](docs/images/4.png)
![](docs/images/5.png)
![](docs/images/6.png)

## 如何运行

- 克隆这个仓库，然后打开项目
- 在 leap.as 控制台中创建一个应用，下面称他为 MaxLeap 应用。如果已经创建，跳过这个步骤。
- 在 `AppDelegate.` 中填写 MaxLeap 应用的 `applicationId` 和 `clientKey`.
- 按下 <kbd>Commond</kbd> + <kbd>R</kbd> 按钮运行

## 项目依赖

- MaxLeap.framework  MaxLeap iOS SDK 的基础模块，MaxLeap 所有功能都依赖于该模块
- MLHelpCenter.embededframework

## 用法

### 显示 FAQ 界面

`[[MLHelpCenter sharedInstance] showFAQs:currentDisplayingViewController];`

### 显示用户反馈界面

`[[MLHelpCenter sharedInstance] showConversation:currentDisplayingViewController];`

### 新消息提醒

默认配置下，每次应用进入前台时 (WillEnterForeground)，会联网检查是否有未读消息。如果有，会弹窗提醒用户。你也可以在应用启动时关闭这个提醒：

`[MLHelpCenter alertNewMessage:NO];`

## 文档

FAQ: https://leap.as/docs/appFaqs/ios.html
用户反馈：https://leap.as/docs/appIssues/ios.html

