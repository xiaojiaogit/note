# 学习flink相关笔记

[官网](flink.apache.org)

## 是什么？

是一个**框架**和**分布式**处理引擎，用于对**无界和有界数据流**进行**状态**计算。

## 为什么选择它？

- 流数据更真实地反应了我们的生活方式

- 传统的数据架构是基于有限数据集的

- 我们的目标

    - 低延迟

    - 高吞吐

    - 结果的准确性和良好的容错性
## 流处理的演变

- storm（完全基于内存）

- lambda 架构（即将步入淘汰的大军列表）

  - 用两套系统，同时保证低延迟和结果准确
    - 批处理
    - 流处理
- spark Streaming（一批一批处理，存在1级延迟）

- flink（最新的流式架构）

## 主要特点

- 事件驱动（Event-driven）

- 基于流的世界观

  - 在Flink的世界观中，一切都是有流组成的，离线数据是有界的流；实时数据是一个没有界限的流：这就是所谓的有界流和无界流。

- 分层API

    - 越顶层越抽象，表达含义越简明，使用越方便

    - 越底层越具体，表达能力越丰富，使用越灵活

> High-level Analytics API              SQL、Table API（dynamic tables）
> stream-& Batch Data Processing        DataStream API (streams,windows)
> stateful Event-Driven Applications    ProcessFunction (events,state,time)

## Flink 的其它特点

- 支持事件时间（event-time）和处理时间（processing-time）

  语义

  - 精确一次（exactly-once）的状态一致性保证

  - 低延迟，每秒处理数百万个事件，毫秒级延迟

  - 与众多常用存储系统的连接

  - 高可用，动态扩展，实现7*24小时全天侯运行

## 快速上手

### 使用工具：idea，语言：scala，包管理工具：maven

### 搭建maven工程 Flink Tutorial

### pom文件
'''xml
<dependencles>
    <groupld>org.apache.flink</groupld>
    <artifactld>flink-scala_2.12</artifactld>
    <version>1.10.1</version>
</dependencles>

<dependencles>
    <groupld>org.apache.flink</groupld>
    <artifactld>flink-streaming-scala_2.12</artifactld>
    <version>1.10.1</version>
</dependencles>


<build>
    <!-- 将scala代码编译为class文件 -->
    <plugin>
        <groupld>net.alchim31.maven</groupld>
        <artifactld>scala-maven-plugin</artifactld>
        <version>4.4.0</version>
        <executions>
            <execution>
                <!-- 声明绑定到maven的complle阶段 -->
                <goals>
                    <goal>compile</goal>
                </goals>
            </execution>
        </executions>
    </plugin>

    <!-- 打包 -->
    <plugin>
        <groupld>org.apache.maven.plugins</groupld>
        <artifactld>maven-assembly-plugin</artifactld>
        <version>3.3.0</version>
        <configuration>
            <descriptorRefs>
                <descriptorRef>jar-with-dependencles</descriptorRef>
            </descriptorRefs>
        </configuration>
        <executions>
            <execution>
                <id>make-assembly</id>
                <phase>package</phase>
                <goals>
                    <goal>single</goal>
                </goals>
            </execution>
        </executions>
    </plugin>
</build>
'''
