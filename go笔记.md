# go笔记
## 环境变量
``` go
# 跟换国内镜像源
GOPROXY=https://goproxy.cn,direct
go env -w GOPROXY=https://goproxy.cn,direct
GOROOT
GO_HOME
PATH
```
## goland相关设置
``` go
# 创建项目
使用go Modules --> 设置GOPROXY=https://goproxy.cn

Tools --> File Watchers --> go fmt & goimports
```

## go相关命令
``` go
# 初始化项目
go mod init
# 下载相关依赖
go mod tidy

```

## 面向对象笔记总结
√ func (p *Person) Eat() {... } 这个方法，使用指针和值都可以调用----建议是：尽量使用指针；
√ 做主语时（调用者），使用值或指针效果一致，但！做参数时：一个是拷贝式值传递，一个是地址引用传递；
√ 定义方法时，方法的主语尽量使用指针，一方面模仿SDK，另一方面是最大程度地减少值传递拷贝效应的负面影响；
√ 对象做参数时，值传递时拷贝式的；指针传递（引用传递/地址传递）才是传递真身；
√ 在OOP的世界里值能做的指针都能做，反过来就完全不成立；
√ 创建对象的方式：
① 创建空白对象：p := Person{}
② 创建对象时，有选择地给指定属性赋值：p := Person{age:20,name:"张三"}
③ 创建对象时，完整有序地给所有属性赋值：p := Person{"张三",20,true,[]string{"撸代码","完美的撸代码"}}
④ 通过内建函数创建对象指针：pPtr := new(Person)
√ new(Type)*Type用于创建建构体的实例指针，参数是建构体的名字，返回的是【所有属性都为默认值的对象】的指针；
√ 大牛逼货的命名能够深度的望文生义，例如：personPtr你会明白无误地知道他是一个person对象的指针而非实例；
√ 类型名称大写开头，外部包可以创建他的对象，反之则不能；
√ 属性名和方法名大写开头，外部包就可以通过实例（或指针）进行访问，反之则不能；
√ 接口实例只认指针！不管实现接口的方法是主语的指针还是值！类型断言也只能断言为指针。




## 框架
``` go
# 下载框架
go get -u github.com/gin-gonic/gin

# 导入框架
import "github.com/gin-gonic/gin"
import "net/http"
```