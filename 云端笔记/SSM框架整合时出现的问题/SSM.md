

==报错1：==

```java
java.sql.SQLException: Access denied for user 'å�•å­�å�¥'@'localhost' (using password: YES)
```

意思是：我的密码错误了，但我通过SQLyog测试没有问题，同时我在练习mybatis时，[database.properties]中的内容都是一样的

检查：[Spring-dao.xml]中也是对的，然后我开始怀疑我的url是不是不行，但通过测试也是可以的![image-20200816145448782](http://cdn.gvssimux.com/image-20200816145448782.png)



解决：将username替换为user

在系统中也有个username属性，这时系统变量覆盖了Properties中的值，这时取得username的值为系统的用户名r，密码为properties中的pwd去查询数据库，此时用户名名和密码并不匹配就会报错。在Spring完成注入时是用 "${..}"  方式获取值完成注入的。而通过这种表达式也能直接获取到JVM系统属性..........

而在这里提升的是Access denied for user 'å�•å­�å�¥'@'localhost' (using password: YES) 这里的乱码应该就是我电脑的用户名(中文)

-----------------------------------------------------------------



==报错2：==

```java
Error creating bean with name 'BookServiceImpl' defined in class path resource [spring-service.xml]: Cannot resolve reference to bean 'bookMapper' while setting bean property 'bookMapper'; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No bean named 'bookMapper' available
```

意思是：说我的 [spring-service.xml] 配置文件中无法引用bookMapper

检查：bookMapper是[spring-dao.xml] 中的，我一开始以为没有注册到容器中，但是在 [spring-service.xml] 中点击它却可以跳转。过去之后发现bookMapper中的小叶子 “显示未找到匹配Bean”![image-20200816144546816](http://cdn.gvssimux.com/image-20200816144546816.png)



解决：1. [spring-service.xml]中要导入[spring-dao.xml]

![image-20200816144714559](http://cdn.gvssimux.com/image-20200816144714559.png)

2.也可在idea中的“项目结构”---"控件" 中将spring文件放到一起（未测试，感觉在代码里import比较好）

注意：这里虽然在[applicationContext.xml] 中将3个spring文件导入了，但[spring-service.xml]中要没有导入[spring-dao.xml]，所以要特别注意。















