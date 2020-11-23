---
title: IntelliJ插件——Lombok
date: 2020-8-13
updated: 2020-8-13
comments: false
categories:
  - IDEA插件
tags:
  - IDEA插件
---

# IntelliJ插件——Lombok

目的：简化类关于get、set等操作

## 使用展示

```java
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private int id;
    private String name;
    private String pwd;
}
```



@Data
@AllArgsConstructor
@NoArgsConstructor

对应产生的方法

![image-20200623112716655](http://cdn.gvssimux.com/image-20200623112716655.png)



## 如何使用

1. 首先在idea中下载Lombok插件

 <img src="http://cdn.gvssimux.com/image-20200623112924923.png" alt="image-20200623112924923" style="zoom: 50%;" />

 <img src="http://cdn.gvssimux.com/image-20200623113044278.png" alt="image-20200623113044278" style="zoom:50%;" />
2. 从maven仓库里导入lombok的包
   
   ```xml
   <!-- https://mvnrepository.com/artifact/org.projectlombok/lombok -->
   <dependency>
       <groupId>org.projectlombok</groupId>
       <artifactId>lombok</artifactId>
       <version>1.18.12</version>
       <scope>provided</scope>
   </dependency>

   ```


这里我使用的是Feb, 2020最新版（附[仓库地址](https://mvnrepository.com/artifact/org.projectlombok/lombok)）



## 注意

- 常用的注解有

    ```java
    @Data	//插入的时get()、set(Object)、equals(Object)、hashCode()、toString()
    @AllArgsConstructor	//顾名思义为全部参数的有参构造方法
    @NoArgsConstructor	//无参的构造方法
    ```

- 当你使用@AllArgsConstructor、@NoArgsConstructor 任意一个时，Data自带的无参构造方法会被替换掉，也就是说当你只使用@AllArgsConstructor和@Data时，是没有无参构造的如图

    ![image-20200623114223440](http://cdn.gvssimux.com/image-20200623114223440.png)

