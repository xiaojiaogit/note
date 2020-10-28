# Electron桌面应用开发

> electron由github开发，可以商用，开源
>
> Electron=Chromium+Node.js+Native API(可以允许我们使用Web技术开发)

## 服务安装

```cmd
#使用Electron开发的软件：

​	VScode、Atom、slack(整合工具，国外)、wordpress、等等

[node.js官网](nodejs.org) 查看是否安装成功：`npm -v` 

新建一个工程：ElectronDemo

首先初始化项目：`npm init` 一路yes即可 会在项目的跟目录生成一个package.json 文件

在项目中安装开发版：`npm install electron --save-dev` 最好科学上网安装

cmd全局安装：`npm install -g electron` 最好科学上网安装

检验是否安装完成：`npx electron -v` 

启动Electorn：`electron` 会弹出一个electron窗口
```

## 第一个halloword

在工程下创建一个index.html文件。

```html
<!DOCTYPE html>
<html <lan="en">

<head>
    <meta charset="UTF-8">
    <title>hello</title>
</head>

<body>
    hello word!
</body>

</html>
```

创建一个main.js文件。

```js
var electron = require('electron')

var app = electron.app	//引入app 
var BrowserWindow = electron.BrowserWindow	//窗口引用

var mainWindow = null	//声明要打开的主窗口

app.on('ready',()=>{	//设置窗口
	mainWindow = new BrowserWindow({
        width:300,
        height:300,
  		webproferences:{nodeIntegration:true}	//这句话的意思是启动node下的所有文件                         
    }) //窗口大小
	mainWindow.loadFile('index.html')	//加载html页面
	mainWindow.on('closed',()=>{
		mainWindow = null
	})
})
```

初始化：`npm init --yes` 之所以在写完代码后初始化，是因为这样他会给我们自动生成 "main": "main.js"

运行我们的项目：`electron .` 





## yarn打包electron

安装相应的模块

```cmd
yarn add electron-builder --dev
```

修改`package.json`

```json
{
    "scripts": {
        "dev": "node build/dev-runner",
        "start": "electron electron/main",
        "serve": "vue-cli-service serve",
        "build": "vue-cli-service build",
        "lint": "vue-cli-service lint",
        "pack": "electron-builder --dir",
        "dist": "electron-builder",
        "bd": "yarn build && electron-builder",
        "postinstall": "electron-builder install-app-deps"
    },
    "build": {
        "productName": "EBlog",
        "directories": {
            "output": "build/dist"
        },
        "files": [
            "dist/**/*",
            "electron/**/*"
        ],
        "extraResources": "public",
        "dmg": {
            "contents": [
                {
                    "x": 410,
                    "y": 150,
                    "type": "link",
                    "path": "/Applications"
                },
                {
                    "x": 130,
                    "y": 150,
                    "type": "file"
                }
            ]
        },
        "mac": {
            "icon": "build/icons/icon.icns"
        }
    }
}
```

运行

```cmd
yarn bd
```



## 项目流程整理

```cmd
# 创建项目
mkdir mytext

# 查看服务版本
node -v
npm -v
electron -v
electron-builder.cmd --version

# 工具下载
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm.cmd install -g electron    如果权限不够可以 => sudo cnpm.cmd install -g electron

# 新建主入口 main.js 文件
var electron = require('electron')
var app = electron.app	//引入app 
var BrowserWindow = electron.BrowserWindow	//窗口引用
var mainWindow = null	//声明要打开的主窗口

app.on('ready',()=>{	//设置窗口
	//mainWindow = new BrowserWindow({width:2000,height:1000}) //窗口大小
	mainWindow = new BrowserWindow({width:600,height:500,webProFerences:{nodeIntegration:true}})	//webproferences:{nodeIntegration:true}	这句话的意思是启动node下的所有文件
	mainWindow.loadFile('index.html')	//加载html页面
	mainWindow.on('closed',()=>{
		mainWindow = null
	})
})

# 新建打包规范 project.json 文件
{
	"name": "mytest",
	"version": "1.0.0",
	"main": "main.js",
	"scripts": {
		"start": "electron.cmd .",
		"build:win": "node_modules/.bin/electron-builder.cmd -w"
	},
	"devDependencies": {
		"electron": "v10.1.2",
		"electron-builder": "22.8.1"
	},
	"author": "mingwang",
	"build": {
		"win": {
			"icon": "icon.png",
			"target": [
				"nsis"
			]
		},
		"nsis": {
			"allowToChangeInstallationDirectory": true,
			"oneClick": false,
			"menuCategory": true,
			"allowElevation": false
		}
	}
}


# 新建html文件
<!DOCTYPE html>
<html long="en">
	<head>
		<meta charset="utf-8">
		<title>nihao</title>
	</head>
	<body>
		<button id="btn">你两干嘛呢？</button>	<!-- 按钮 -->
		<div id="mybaby"></div>	<!-- 存放显示的内容 -->
		<script src="js/index.js"></script>
	</body>
</html>

# 新建js文件
var fs = require('fs')

window.onload = function(){
	var btn = this.document.querySelector('#btn')
	var mybaby = this.document.querySelector('#mybaby')
	btn.onclick = function(){
		fs.readFile('nihao.txt',(err,data)=>{
			mybaby.innerHTML = data
		})
	}
}

# 新建一个 build 目录
#目录里有: appdmg.png entitlements.mas.plist icon.icns icon.ico icons zulip.png

# 加载所需要的依赖
cnpm.cmd install     # 执行该命令会得到一个node_modules的资源文件夹

# 打包
cnpm.cmd run build:win
```











## 项目打包案例1

```cmd
npm install -g yarn
yarn add electron-builder --save-dev  //为electron项目添加electron-builder模块
yarn dist-win //过程中会下载打包需要的包，会很慢
```

## 解决打包慢或者不成功的问题

安装smart-npm

```javascript
npm install --global smart-npm --registry=https://registry.npm.taobao.org/
```

1、安装electron-builder（注意全局安装）

```javascript
npm install -g electron-builder
npm install -g electron-package
```

2、在项目目录（my-project）执行打包命令

```javascript
electron-builder.cmd		22.8.1
electron-packager.cmd ./ oral -all --electron-version=22.8.1
//显示因为在此系统上禁止运行脚本。
//原因分析：禁止执行脚本，那就打开权限执行脚本嘛
//解决方案：
//1、打开 powerShell 用管理员身份运行
//2、输入命令： set-ExecutionPolicy RemoteSigned 
//3、输入A
再输入 vue -V (搞定)
```

3、由于网络原因，各种包下载不下来，导致出错

electron-builder 在打包时会检测cache中是否有electron 包，如果没有的话会从github上拉去，在国内网络环境中拉取的过程大概率会失败，所以你可以自己去下载一个包放到cache目录里

例如在macos平台打包electron应用，执行 electron-builder --mac --x64

```javascript
➜  clipboard git:(master) ✗ npm run dist

> clipboard@1.0.0 dist /Users/xx/workspace/electron/clipboard
> electron-builder --mac --x64

  • electron-builder  version=22.3.2 os=18.7.0
  • loaded configuration  file=package.json ("build" field)
  • writing effective config  file=dist/builder-effective-config.yaml
  • packaging       platform=darwin arch=x64 electron=8.0.0 appOutDir=dist/mac
  • downloading     url=https://github.com/electron/electron/releases/download/v8.0.0/electron-v8.0.0-darwin-x64.zip size=66 MB parts=8
12345678910
```

可以单独下载这个包 https://github.com/electron/electron/releases/download/v8.0.0/electron-v8.0.0-darwin-x64.zip， 放到~/Library/Caches/electron/ 目录下

各个平台的目录地址

```javascript
Linux: $XDG_CACHE_HOME or ~/.cache/electron/
MacOS: ~/Library/Caches/electron/
Windows: %LOCALAPPDATA%/electron/Cache or ~/AppData/Local/electron/Cache/
123
```

**常用参数**
electron-builder配置文件写在package.json中的build字段中

```javascript
"build": {
    "appId": "com.example.app", // 应用程序id 
    "productName": "测试", // 应用名称 
    // 设置为 true 可以把自己的代码合并并加密
  	"asar": true,
    "directories": {
        "buildResources": "build", // 构建资源路径默认为build
        "output": "dist" // 输出目录 默认为dist
    },
    "mac": {
        "category": "public.app-category.developer-tools", // 应用程序类别
        "target": ["dmg", "zip"],  // 目标包类型 
        "icon": "build/icon.icns" // 图标的路径
    },
    "dmg": {
        "background": "build/background.tiff or build/background.png", // 背景图像的路径
        "title": "标题",
        "icon": "build/icon.icns" // 图标路径
    },
    "win": {
     // 打包成一个独立的 exe 安装程序
        // 'target': 'nsis',
        // 这个意思是打出来32 bit + 64 bit的包，但是要注意：这样打包出来的安装包体积比较大，所以建议直接打32的安装包。
        // 'arch': [
        //   'x64',
        //   'ia32'
        // ]
        "target": ["nsis","zip"] // 目标包类型 
    },
    "nsis": {
    // 是否一键安装，建议为 false，可以让用户点击下一步、下一步、下一步的形式安装程序，如果为true，当用户双击构建好的程序，自动安装程序并打开，即：一键安装（one-click installer）
    "oneClick": false,
    // 允许请求提升。 如果为false，则用户必须使用提升的权限重新启动安装程序。
    "allowElevation": true,
    // 允许修改安装目录，建议为 true，是否允许用户改变安装目录，默认是不允许
    "allowToChangeInstallationDirectory": true,
    // 安装图标
    "installerIcon": "build/installerIcon_120.ico",
    // 卸载图标
    "uninstallerIcon": "build/uninstallerIcon_120.ico",
    // 安装时头部图标
    "installerHeaderIcon": "build/installerHeaderIcon_120.ico",
    // 创建桌面图标
    "createDesktopShortcut": true,
    // 创建开始菜单图标
    "createStartMenuShortcut": true,
    // electron中LICENSE.txt所需要的格式，并非是GBK，或者UTF-8，LICENSE.txt写好之后，需要进行转化，转化为ANSI
    "license": "LICENSE.txt"
  },
```





## 项目打包案例2

```cmd
下载插件
npm install -g electron-packager

打包0
electron-packager ./ oral -all --electron-version=22.8.1
打包1
electron-packager . myClient --win --out ../electron-api-demos-master --arch=x64 --app-version=1.0.0 --electron-version=2.0.0
打包2
electron-packager . test --overwrite --win=x32 --out  ./test --arch=x64 --app-version=1.0.0 --electron-version=2.0.0
```

index.html

```html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>百度</title>
<style type="text/css">
*{margin:0px; padding: 0px;}
#iframe{width: 100%; height: 100%; position: absolute; top:0px; right:0px; bottom:0px; left:0px;}
</style>
</head>
<body> 
<iframe id="iframe" frameborder="0" src="https://www.baidu.com/"></iframe> 
<script>
// You can also require other files to run in this process
require('./renderer.js')
</script>
</body>
</html>
```

main.js

```js
// Modules to control application life and create native browser window
const {app, BrowserWindow} = require('electron')
if(require('electron-squirrel-startup')) return;
// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
let mainWindow

function createWindow () {
  // Create the browser window.
  mainWindow = new BrowserWindow({width: 800, height: 600})

  // and load the index.html of the app.
  mainWindow.loadFile('index.html')

  // Open the DevTools.
  // mainWindow.webContents.openDevTools()

  // Emitted when the window is closed.
  mainWindow.on('closed', function () {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null
  })
}

// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
// Some APIs can only be used after this event occurs.
app.on('ready', createWindow)

// Quit when all windows are closed.
app.on('window-all-closed', function () {
  // On OS X it is common for applications and their menu bar
  // to stay active until the user quits explicitly with Cmd + Q
  if (process.platform !== 'darwin') {
    app.quit()
  }
})

app.on('activate', function () {
  // On OS X it's common to re-create a window in the app when the
  // dock icon is clicked and there are no other windows open.
  if (mainWindow === null) {
    createWindow()
  }
})

// In this file you can include the rest of your app's specific main process
// code. You can also put them in separate files and require them here.
```

package.json

```json
{
  "name": "electron-quick-start",
  "version": "1.0.0",
  "description": "A minimal Electron application",
  "main": "main.js",
  "scripts": {
    "start": "electron .",
    "packager": "electron-packager . electron-quick-start --overwrite --win=x32 --out  ./HelloWorldApp --arch=x64 --app-version=1.0.0 --electron-version=2.0.0"
  },
  "repository": "https://github.com/electron/electron-quick-start",
  "keywords": [
    "Electron",
    "quick",
    "start",
    "tutorial",
    "demo"
  ],
  "author": "GitHub",
  "license": "CC0-1.0",
  "devDependencies": {
    "electron": "^2.0.0",
    "electron-packager": "^12.2.0",
    "electron-winstaller": "^2.7.0"
  },
  "dependencies": {
    "electron-squirrel-startup": "^1.0.0"
  }
}
```























