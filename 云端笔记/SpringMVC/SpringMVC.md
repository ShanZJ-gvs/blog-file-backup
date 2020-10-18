# SpringMVC

MVC：模型(dao、service)    视图(jsp)  控制层(Servlet)  是一个软件设计规范

Model：数据模型，提供要展示的数据，因此包含数据和行为，

view：

 Controller：



- dao(连接数据库)

- service(调dao去执行一些具体的业务)

- servlet(接受前端数据，数据传给service去处理)   转发(url不变)，重定向

- jsp/html





MVC：

MVVM：M  V     VM(ViewModel：双向绑定)







<?xml version="1.0" encoding="UTF-8"?> <beans xmlns="http://www.springframework.org/schema/beans"       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"       xsi:schemaLocation="http://www.springframework.org/schema/beans        http://www.springframework.org/schema/beans/spring-beans.xsd">
</beans>





```xml
<!--1.注册DispatcherServlet-->
<servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!--关联一个springmvc的配置文件：（springname）-servlet.xml-->
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc-servlet.xml</param-value>
    </init-param>
    <!--启动级别为1-->
    <load-on-startup>1</load-on-startup>
</servlet>

<servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```





```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <!--添加处理映射器-->
    <bean class="org.springframework.web.servlet.handler.BeanNameUrlHandlerMapping"/>
    <!--添加处理适配器-->
    <bean class="org.springframework.web.servlet.mvc.SimpleControllerHandlerAdapter"/>


    <!--视图解析器:DispatcherServlet给他的ModelAndView
    1.获取了ModelAndView的数据
    2.解析ModelAndView的视图的名字
    3.拼接视图名字，找到对应的视图 /WEB-INF/hello1.jsp
    -->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
        <!--前缀-->
        <property name="prefix" value="/WEB-INF/jsp/"/>
        <!--后缀-->
        <property name="suffix" value=".jsp"/>
    </bean>
    <!--这里的hello10是网页端访问在后面要加上hello10才能访问-->
    <bean id="/" class=""/>
</beans>
```





Maven的资源过滤问题

```xml
<build>
    <resources>
        <resource>
            <directory>src/main/java</directory>
            <includes>
                <include>**/*.properties</include>
                <include>**/*.xml</include>
            </includes>
            <filtering>false</filtering>
        </resource>
    <resource>
        <directory>src/main/resources</directory>
        <includes>
            <include>**/*.properties</include>
            <include>**/*.xml</include>
        </includes>
        <filtering>false</filtering>
    </resource>
</resources>
</build>
```

注解开发

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:mvc="http://www.springframework.org/schema/mvc"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd http://www.springframework.org/schema/context https://www.springframework.org/schema/context/spring-context.xsd http://www.springframework.org/schema/mvc https://www.springframework.org/schema/mvc/spring-mvc.xsd">

    <context:component-scan base-package="com.shanzj.controller"/>
    <mvc:default-servlet-handler/>
    <mvc:annotation-driven/>

    <!--视图解析器-->
    <bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
        <!--前缀-->
        <property name="prefix" value="/WEB-INF/jsp/"/>
        <!--后缀-->
        <property name="suffix" value=".jsp"/>
    </bean>

</beans>
```



# 1、回顾MVC

## 1.1、什么是MVC

- MVC是模型(Model)、视图(View)、控制器(Controller)的简写，是一种软件设计规范。 
- 是将业务逻辑、数据、显示分离的方法来组织代码。 
- MVC主要作用是降低了视图与业务逻辑间的双向偶合。 
- MVC不是一种设计模式，MVC是一种架构模式。当然不同的MVC存在差异。


Model（模型）：数据模型，提供要展示的数据，因此包含数据和行为，可以认为是领域模型或 JavaBean组件（包含数据和行为），不过现在一般都分离开来：Value Object（数据Dao） 和 服务层 （行为Service）。也就是模型提供了模型数据查询和模型数据的状态更新等功能，包括数据和业务。 

View（视图）：负责进行模型的展示，一般就是我们见到的用户界面，客户想看到的东西。 

Controller（控制器）：接收用户请求，委托给模型进行处理（状态改变），处理完毕后把返回的模型 数据返回给视图，由视图负责展示。 也就是说控制器做了个调度员的工作。



最典型的MVC就是JSP + servlet + javabean的模式。



## 1.4、回顾Servlet

1. 新建一个Maven项目当做父工程

    ==pom.xml==

    ```xml
    <dependencies>
        <dependency>
            <groupId>junit</groupId>
            <artifactId>junit</artifactId>
            <version>4.13</version>
            <scope>test</scope>
        </dependency>
    
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-webmvc</artifactId>
            <version>5.2.7.RELEASE</version>
        </dependency>
    
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>servlet-api</artifactId>
            <version>2.5</version>
        </dependency>
    
        <dependency>
            <groupId>javax.servlet.jsp</groupId>
            <artifactId>jsp-api</artifactId>
            <version>2.2</version>
        </dependency>
    
        <dependency>
            <groupId>javax.servlet</groupId>
            <artifactId>jstl</artifactId>
            <version>1.2</version>
        </dependency>
    
    </dependencies>
    ```

    

2. 建立一个Moudle：springMVC-01-servlet ， 添加Web app的支持！ 

    ![image-20200811213644582](http://cdn.gvssimux.com/image-20200811213644582.png)

    然后模块里会多出个web的文件

3. 编写一个Servlet类

    ```java
    import javax.servlet.ServletException;
    import javax.servlet.http.HttpServlet;
    import javax.servlet.http.HttpServletRequest;
    import javax.servlet.http.HttpServletResponse;
    import java.io.IOException;
    
    /*只要实现了Servlet接口的类都叫Servlet*/
    public class HelloServlet extends HttpServlet {
        @Override
        protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            //1.获取前端参数
            String method = req.getParameter("method");
            if (method.equals("add")){
                req.getSession().setAttribute("msg","执行了add方法");
            }
            if (method.equals("delete")){
                req.getSession().setAttribute("msg","执行了delete方法");
            }
    
    
            //2.调用业务层
    
            //3.视图转发或者重定向
            req.getRequestDispatcher("/WEB-INF/jsp/test.jsp").forward(req,resp);
        }
    
        @Override
        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
            super.doGet(req, resp);
        }
    }
    ```

4. 编写Hello.jsp，在WEB-INF目录下新建一个jsp的文件夹，新建hello.jsp

    ```jsp
    <%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <html>
    <head>
        <title>Title</title>
    </head>
    <body>
    
    
    ${msg}
    
    </body>
    </html>
    ```

5. 在web.xml里注册

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
             version="4.0">
    
        <!--绑定Servlet-->
        <servlet>
            <servlet-name>hello</servlet-name>
            <servlet-class>com.shanzj.servlet.HelloServlet</servlet-class>
        </servlet>
    
        <servlet-mapping>
            <servlet-name>hello</servlet-name>
            <url-pattern>/hello</url-pattern>
        </servlet-mapping>
    
        <!--seesion超时时间-->
        <session-config>
            <session-timeout>15</session-timeout>
        </session-config>
    
        <!--欢迎页面，默认是index-->
        <welcome-file-list>
            <welcome-file>index.jsp</welcome-file>
        </welcome-file-list>
    </web-app>
    ```

6. 配置Tomcat，并启动测试



# SpringMVC流程

1. 构建一个Maven项目，然后导入依赖

2. 建立子模块，添加web框架支持（模块里会多一个web文件出来）

3. 配置web.xml，注册DispatcherServlet  然后关联一个关联一个springmvc的配置文件：（springname）-servlet.xml，再设置匹配请求<servlet-mapping>

4. 编写SpringMVC的配置文件，即（springname）-servlet.xml 。我这是springmvc-servlet.xml（建议）

5. springmvc-servlet.xml。

    - 添加处理映射器HandlerMapping

    - 添加处理适配器HandlerAdapter

    - 视图解析器:DispatcherServlet给他的ModelAndView
        1.获取了ModelAndView的数据
        2.解析ModelAndView的视图的名字
        
        3.拼接视图名字，找到对应的视图 /WEB-INF/hello1.jsp

6. 将实现了org.springframework.web.servlet.mvc.Controller的类放入springmvc-servlet.xml的容器中

   



# /与/*的区别

```xml
<!--
在SpringMVC中   /  与/*
/：只匹配所有请求，不会匹配jsp页面
/*：匹配所有请求，包括jsp页面  比如说你在后面加了a.jsp在springMVC的视图解析器中就会无线嵌套a.jsp.jsp.jsp.....
-->
```



# web.xml

```xml
<!--配置DispatchServlet：这是SpringMVC的核心：请求分发器，前端控制器-->
<servlet>
    <servlet-name>springmvc</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <!--DispatchServlet需要绑定SpringMVC的配置文件-->
    <init-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath:springmvc-servlet.xml</param-value>
    </init-param>
    <!--启动级别-->
    <load-on-startup>1</load-on-startup>
</servlet>

<!--
在SpringMVC中   /  与/*
/：只匹配所有请求，不会匹配jsp页面
/*：匹配所有请求，包括jsp页面  比如说你在后面加了a.jsp在springMVC的视图解析器中就会无线嵌套a.jsp.jsp.jsp.....
-->
<!--所有请求都会被SpringMVC拦截-->
<servlet-mapping>
    <servlet-name>springmvc</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>


<filter>
    <filter-name>encoding</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```





# @Controller及RestFull风格

4.1、控制器Controller 

控制器复杂提供访问应用程序的行为，通常通过接口定义或注解定义两种方法实现。 控制器负责解析用户的请求并将其转换为一个模型。 在Spring MVC中一个控制器类可以包含多个方法 在Spring MVC中，对于Controller的配置方式有很多种







# 5、结果跳转方式

## 5.1、ModelAndView 

设置ModelAndView对象 , 根据view的名称 , 和视图解析器跳到指定的页面 。

页面 : {视图解析器前缀} + viewName +{视图解析器后缀}

```xml
<!--视图解析器-->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
    <!--前缀-->
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <!--后缀-->
    <property name="suffix" value=".jsp"/>
</bean>
```

对应的controller类（第一种）

```java
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloController implements Controller {
    public ModelAndView handleRequest(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
        ModelAndView mv = new ModelAndView();

        //业务代码
        String result = "shanzj";
        mv.addObject("msg",result);



        //视图跳转
        mv.setViewName("test");




        return mv;
    }
}
```

对应的controller类（注解的方式@Controller）

```java
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
public class HelloController {
    @RequestMapping("/gvs")
    public String hesadfso(Model model){
        //封装数据
        model.addAttribute("msg","springmvc注解");

        return "gvs";   //会被视图解析器处理  前面配置的地方的gvs.jsp
    }

}
```

## 5.2、ServletAPI 

通过设置ServletAPI , 不需要视图解析器 

1. 通过HttpServletResponse进行输出 
2. 通过HttpServletResponse实现重定向 
3.  通过HttpServletResponse实现转发



# 6、数据跳转

## 6.1、处理提交数据

1、提交的域名称和处理方法的参数名一致

提交数据 : http://localhost:8080/t1?name=shanzj处理方法 :

```java
@Controller
public class UserController {
    //localhost:8080/t1?name=xxx
    @GetMapping("t1")
    public String test01(String name, Model model){  //1.接受前端参数
        //2.将返回的结果传递给前端
        model.addAttribute("msg",name);
        System.out.println(name);
        //3.跳转视图
        return "shanzj";
    }
}
```

后台会输出“shanzj”





2、提交的域名称和处理方法的参数名不一致 提交数据 : http://localhost:8080/t1?username=shanzj2

```java
@Controller
public class UserController {
    //localhost:8080/t1?username=xxx
    @GetMapping("t1")
    public String test01(@RequestParam("username") String name, Model model){ //1.接受前端参数
        //2.将返回的结果传递给前端
        model.addAttribute("msg",name);
        System.out.println(name);
        //3.跳转视图
        return "shanzj";
    }
}
```

后台输出“shanzj2”

在这里加上了@RequestParam 之后浏览器通过user就无法请求了，如果不加的话用户可以通过 http://localhost:8080/t1去访问到要所跳转的页面

![image-20200813094957490](http://cdn.gvssimux.com/image-20200813094957490.png)

![image-20200813095024200](http://cdn.gvssimux.com/image-20200813095024200.png)

==所以为了规范，以后写的参数尽量带@RequestParam==





3、提交的是一个对象 要求提交的表单域和对象的属性名一致 , 参数使用对象即可

1. 实体类

    ```java
    public class User {
        private int id;
        private String name;
        private int age;
    }
    ```

2. 处理方式

3. ```java
    //http://localhost:8080/t2?id=1&age=20&name=shanzj
    @GetMapping("t2")
    public String test02(User user, Model model){ //1.接受前端参数
    
        //2.将返回的结果传递给前端
        model.addAttribute("msg",user);
        System.out.println(user);
        //3.跳转视图
        return "shanzj";
    }
    ```

4. 提交方式http://localhost:8080/t2?id=1&age=20&name=shanzj

后台输出：User(id=1, name=shanzj, age=20)

说明：如果使用对象的话，前端传递的参数名和对象名必须一致，否则就是null。







## 6.2、数据显示到前端

==第一种 : 通过ModelAndView==

```java
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.Controller;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloController implements Controller {
    public ModelAndView handleRequest(HttpServletRequest request, HttpServletResponse response)throws Exception {
        //ModelAndView 模型和视图
        ModelAndView mv = new ModelAndView();

        //封装对象，放在ModelAndView中。Model
        mv.addObject("msg","HelloSpringMVC!");
        //封装要跳转的视图，放在ModelAndView中        
        mv.setViewName("hello1");//: /WEB-INF/jsp/hello1.jsp  
        return mv;
    }
}
```



注意：需要在配置文件中（springmvc-servlet.xml）配置视图解析器

```xml
<!--视图解析器-->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver" id="InternalResourceViewResolver">
    <!--前缀-->
    <property name="prefix" value="/WEB-INF/jsp/"/>
    <!--后缀-->
    <property name="suffix" value=".jsp"/>
</bean>
```



==第二种 : 通过ModelMap==

ModelMap

```java
@Controller
public class UserController {
//localhost:8080/t1?name=xxx
@GetMapping("t1")
public String test01(@RequestParam("username") String name, ModelMap model){ //1.接受前端参数
 		 
    //2.将返回的结果传递给前端
    //相当于req.setAttribute("name",name);
    model.addAttribute("msg",name);
    System.out.println(name);
    //3.跳转视图
    return "shanzj";
}
```








==第三种 : 通过Model==

Model 就是在6.1中使用到的

```java
@Controller
public class UserController {

    //localhost:8080/t1?name=xxx
    @GetMapping("t1")
    public String test01(@RequestParam("username") String name, Model model){ //1.接受前端参数
 		 
        //2.将返回的结果传递给前端
        //相当于req.setAttribute("name",name);
        model.addAttribute("msg",name);
        System.out.println(name);
        //3.跳转视图
        return "shanzj";
    }
```

总结

```
Model 只有寥寥几个方法只适合用于储存数据，简化了新手对于Model对象的操作和理解；
ModelMap 继承了 LinkedMap ，除了实现了自身的一些方法，同样的继承 LinkedMap 的方法和特性；
ModelAndView 可以在储存数据的同时，可以进行设置返回的逻辑视图，进行控制展示层的跳转。
```

当然更多的以后开发考虑的更多的是性能和优化，就不能单单仅限于此的了解。
请使用80%的时间打好扎实的基础，剩下18%的时间研究框架，2%的时间去学点英文，框架的官方文档 永远是最好的教程。





## 6.4、乱码问题

测试步骤：

1.先写一个提交的表单（form.jsp）

```xml
<form action="/SpringMVC_05_jumpway_war_exploded/e/t1" method="post">
    <input type="text" name="name">
    <input type="submit">
</form>
```

2.后台编写对应的处理类

```java
@Controller
public class EncodingController {
    //过滤器解决乱码
    @RequestMapping("/e/t1")
    public String test01(String name, Model model){
        model.addAttribute("msg",name);
        System.out.println(name);
        return "shanzj";
    }
}
```

![image-20200813110223459](http://cdn.gvssimux.com/image-20200813110223459.png)



乱码问题是在我们开发中十分常见的问题！






1. 自己写过滤器

    ![image-20200813110429845](http://cdn.gvssimux.com/image-20200813110429845.png)

```java
import javax.servlet.*;
import java.io.IOException;

public class EncodingFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        servletRequest.setCharacterEncoding("utf-8");
        servletResponse.setCharacterEncoding("utf-8");
        filterChain.doFilter(servletRequest,servletResponse);
    }

    public void destroy() {

    }
}
```

web.xml配置（加入过滤器）==/与/*的区别==

```xml
<filter>
    <filter-name>encoding</filter-name>
    <filter-class>com.shanzj.filter.EncodingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```





2. 以前乱码问题通过过滤器解决 , 而SpringMVC给我们提供了一个过滤器

```xml
<filter>
    <filter-name>encoding</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>

<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```





3.网络找过滤器







# 7、前后端分离

后端部署后端，提供接口，提供数据：



​				json（数据格式，js对象标记）



前端独立部署，负责渲染后端的数据



json转js

js转json

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>

    <script type="text/javascript">
        //编写一个JavaScript
        var user = {
            name:"shanzj",
            age:18,
            sex:"男"
        };

        //将js对象转换为json对象
        var json = JSON.stringify(user);

        console.log(json);

        //将 json 对象转换为 JavaScript对象
        var obj = JSON.parse(json);
        console.log(obj);
    </script>

</head>

<body>


</body>
</html>
```



## 7.1、jackson

导包

```xml
<!-- https://mvnrepository.com/artifact/com.fasterxml.jackson.core/jackson-databind -->
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.11.2</version>
</dependency>
```

UserController

直接toString打印

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.shanzj.pojo.User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class UserController {
    @ResponseBody  //使之不会走视图解析器，会直接返回一个字符串
    @RequestMapping("/j1")
    public String json01() throws JsonProcessingException {
        User user = new User(1,"单子健",18);
        return user.toString();
    }
}
```

![image-20200813190836129](http://cdn.gvssimux.com/image-20200813190836129.png)



### 1.使用Jackson(ObjectMapper)

```java

@Controller
public class UserController {
	@ResponseBody  //使之不会走视图解析器，会直接返回一个字符串
	@RequestMapping(value = "/j2", produces = "application/json;charset=utf-8")//加	  上produces 之后就不会出现中文乱码了
	public String json02() throws JsonProcessingException {
   	 	User user = new User(1,"单子健",18);
    	//jackson：ObjectMapper

    	ObjectMapper mapper = new ObjectMapper();
    	String str = mapper.writeValueAsString(user);
    	return str;
	}
}
```

![image-20200813191029787](http://cdn.gvssimux.com/image-20200813191029787.png)



### @RestController

 使用在类上就 里面的方法就不走视图解析器（方法全部给前端调用接口使用时）

不走视图解析器 1. 直接@RestController     2.  @Controller和@ResponseBody搭配使用

```java
@RestController
public class UserController {
    @RequestMapping("/j1")
    public String json01() throws JsonProcessingException {
        User user = new User(1,"单子健",18);
        return user.toString();
    }

}
```



### 2.Jackson解析集合

```java
@ResponseBody
@RequestMapping(value = "/j3")
public String json03() throws JsonProcessingException {
    List<User> userList = new ArrayList<User>();

    User user = new User(1,"单子健",18);
    User user2 = new User(2,"单子健",18);
    User user3 = new User(3,"单子健",18);

    userList.add(user);
    userList.add(user2);
    userList.add(user3);

    String str = new ObjectMapper().writeValueAsString(userList);

    return str;
}
```



### 3.Jackson解析时间

```java
@ResponseBody
@RequestMapping(value = "/j4")
public String json04() throws JsonProcessingException {

    Date date = new Date();
    //ObjectMapper  时间解析后的默认格式为时间戳(Timestamp) 1970年1月1号到现在的毫秒数
    String str = new ObjectMapper().writeValueAsString(date);

    return str;
}
```

![image-20200813194152766](http://cdn.gvssimux.com/image-20200813194152766.png)



==将时间戳改为人能看懂的==

==方法一：==

```java
@RestController
public class UserController {

    @RequestMapping(value = "/j4")
    public String json04() throws JsonProcessingException {

        Date date = new Date();
        //自定义日期格式
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        String str = new ObjectMapper().writeValueAsString(simpleDateFormat.format(date));
        return str;
    }

}
```

![image-20200813194436248](http://cdn.gvssimux.com/image-20200813194436248.png)



==方法二：修改Jackson中ObjectMapper==

```java
@RestController
public class UserController {
    @RequestMapping(value = "/j5")
    public String json05() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        //不使用时间戳
        mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,false);
        //自定义日期格式
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        mapper.setDateFormat(simpleDateFormat);

        Date date = new Date();
        String str =mapper.writeValueAsString( date);

        return str;
    }

}
```







## 7.2、SpringMVC统一解决Json乱码

```xml
<!--springmvc 统一解决json中文乱码问题-->
<mvc:annotation-driven>
    <mvc:message-converters register-defaults="true">
        <bean class="org.springframework.http.converter.StringHttpMessageConverter">
            <constructor-arg value="UTF-8"/>
        </bean>
        <bean class="org.springframework.http.converter.json.MappingJackson2HttpMessageConverter">
            <property name="objectMapper">
                <bean class="org.springframework.http.converter.json.Jackson2ObjectMapperFactoryBean">
                    <property name="failOnEmptyBeans" value="false"/>
                </bean>
            </property>
        </bean>
    </mvc:message-converters>
</mvc:annotation-driven>
```



## 7.3JsonUtil

==封装Jackson的一些操作==

 JsonUtil

```java
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import java.text.SimpleDateFormat;

public class JsonUtil {
    //简单的getJson
    public static String getJson(Object obj) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(obj);
    }

    public static String getJson(Object obj,String dataFormat) throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        mapper.configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS,false);
        //自定义日期格式
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat(dataFormat);
        mapper.setDateFormat(simpleDateFormat);
        return  mapper.writeValueAsString(obj);
    }

}
```

测试

```java
@RestController
public class UserController {
    
    //编写JsonUtil类简化代码
    @RequestMapping(value = "/j6")
    public String json06() throws JsonProcessingException {
        Date date = new Date();
        JsonUtil jsonUtil = new JsonUtil();
        return jsonUtil.getJson(date);
    }

    //使用JsonUtil类解析时间 （测试）
    @RequestMapping(value = "/j7")
    public String json07() throws JsonProcessingException {
        Date date = new Date();
        return new JsonUtil().getJson(date,"yyyy-MM-dd HH:mm:ss");
    }

}
```

