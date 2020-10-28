# echats学习笔记
## 官方网站
[echarts](http://echarts.apache.org/)\
[echarts官方教程](https://echarts.apache.org/zh/tutorial.html#5%20%E5%88%86%E9%92%9F%E4%B8%8A%E6%89%8B%20ECharts)

## 知识储备
- HTML、CSS、JS
- Echatrs的使用
- Vue、VueX、Router、Webpack
- WebSocket的使用

## 技术选型
- Echarts   --  可视化
- Vue、Vue Router、VueX -- 前端框架
- Webpack -- 打包前端静态页面的工具
- Axios -- 是一个基于 promise 的 HTTP 库，可以用在浏览器和 node.js 中。
- WebSocket -- 是一种在单个TCP连接上进行全双工通信的协议。
- Koa2 -- 轻量级的web框架，几行代码就可以启动服务器

## 学习展示
### 柱状图入门案例
```html
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <title>柱状图</title>
        <script src="../js/echarts.min.js"></script>
        <script src="../js/mytheme.js"></script>
    </head>
    <body>
      
        <div style="width: 100%;height: 650px; ">    
        </div>
        
        <script type="text/javascript">
            // 1.Echates最基本的代码结构
            // 2.x轴数据：['广东省','山东省','四川省','河南省','江苏省','湖北省','湖南省','江西省','浙江省','安徽省']
            // 3.y轴数据：[1000100,9959000,700000,705000,600000,600100,560000,500000,501000,490100]
            // 4.将type的值设置为bar
            var mChatrs = echarts.init(document.querySelector("div"),"mytheme")
            var xDataArr = ['广东省','山东省','四川省','河南省','江苏省','湖北省','湖南省','江西省','浙江省','安徽省']
            var yDataArr1 = [1000100,995900,700000,705000,600000,600100,560000,500000,501000,490100]
            var yDataArr2 = [500000,501000,560000,490100,600100,600000,705000,700000,995900,1000100]
            var option = {

                // 标题
                title: {
                    text: '实时开机终端排行榜地域TOP10',
                    textStyle: {
                        color: 'white'
                    },
                    //borderWidth: 5,
                    //borderColor: 'blue',
                    // 拐角的弯度
                    //borderRadius: 10,
                    left: 500,
                    top:10,
                },
                //提示，鼠标事件
                tooltip: {
                    //tirgger: 'item',
                    trigger: 'axis',
                    //triggerOn: 'click'
                    //formatter: '{b} 的地域TOP10为：{c}'
                    //formatter: function (arg) {
                    //    return arg[0].name + ' 的地域TOP10为：' + arg[0].data
                    //}
                },
                toolbox: {
                    feature: {
                        saveAsImage:{}, //导出图片
                        dataView: {}, //数据视图
                        restore: {}, //重置
                        dataZoom: {}, //区域缩放
                        magicType: {
                            type: ['bar', 'line']
                        } //动态图标类型的切换
                    }
                },
                //图例
                legend: {
                    data: ['2019年','2020年'],
                    //left: 200,
                    right: 20,
                    top: 37

                },
                xAxis: {
                    type: 'category',
                    data: xDataArr,
                    axisLabel: {
                            interval: 0,
                            rotate: 38
                        },
                },
                yAxis: {
                    type: 'value',
                    //设置坐标名称
                    name: '不包含直辖市'
                },
                series: [
                    {
                        name: '2020年',
                        type: 'bar',
                        data: yDataArr1,
                        // 最大值、最小值
                        //markPoint: {
                        //    data: [
                        //        {
                        //            type: 'max', name: '最大值'
                        //        },{
                        //            type: 'min', name: '最小值'
                        //        }
                        //    ]
                        //},
                        //平均值
                        markLine: {
                            data: [
                                {
                                    type: 'average', name: '平均值',
                                }
                            ]
                        },
                        // 数值的显示
                        //label: {
                            //show: true,
                            //rotate: 60
                        //},
                        // 柱的宽度
                        barWidth: '25%',
                        //设置柱状图渐变色
                        itemStyle: {
                            color: {
                                type: 'linear',
                                x: 0,
                                y: 0,
                                x2: 0,
                                y2: 1,
                                colorStops: [{
                                    offset:0,color: '#00FFFF'
                                },{
                                    offset:1,color: 'blue'
                                }],
                                global: false
                            }
                        }
                    },{
                        name: '2019年',
                        type: 'bar',
                        data: yDataArr2,
                        // 最大值、最小值
                        //markPoint: {
                        //    data: [
                        //        {
                        //            type: 'max', name: '最大值'
                        //        },{
                        //            type: 'min', name: '最小值'
                        //        }
                        //    ]
                        //},
                        //平均值
                        markLine: {
                            data: [
                                {
                                    type: 'average', name: '平均值',
                                }
                            ]
                        },
                        // 数值的显示
                        //label: {
                            //show: true,
                            //rotate: 60
                        //},
                        // 柱的宽度
                        barWidth: '25%'
                
                    },
                ]
            }
            mChatrs.setOption(option)
        </script>
    </body>
</html>
```
### 柱状图小结

- 基本的柱状图
    - 基本的代码结构
    - x轴和y轴的数据
    - series中的type设置为bar
- 柱状图常见效果
    - 最大值\最小值 markLine
    - 平均值 markLine
    - 数值的显示 label
    - 柱的宽度 barWidth
- 柱状图特点
    - 柱状图描述的是分类数据，呈现的是每一个分类中有多少，通过柱状图，可以很清晰的看出每个分类数据的排名情况

### 柱状图通用配置
> 通用配置指的就是任何表都能使用的配置
- 标题：title
    - 文字样式
        textStyle
    - 标题边框
        borderWidth、borderColor、borderRadius
    - 标题位置
        left、top、right、bottom
- 提示：tooltip
    > tooltip:提示框组件，用于配置鼠标滑过或点击图表时的显示框
    - 触发类型：trigger
        item、axis
    - 触发时机：triggerOn
        mouseover、click
    - 格式化：formatter
        字符串模板、回调函数
- 工具按钮：toolbox
    > toolbox: Echats提供的工具栏
    - 内置有导出图片、数据视图、动态类型切换、数据域缩放、重置等5个工具
    - 显示工具栏按钮featrue
        saveAsImage、dataView、restore、dataZoom、magicType
- 图例：legend


## 命令总结
```html
<!--在idea中导入资源需要这样写-->
<script src="${pageContext.request.contextPath}/要引入的文件路径"/>



```

## 注意说明
```html
<!-引入js文件要使用以下方式，防止出错-->
<script src="${pageContext.request.contextPath}/js/jquery-3.5.1.js"/>
```