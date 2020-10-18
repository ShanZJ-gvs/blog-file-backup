# 1、Spring

## 1.1、简介

## 1.2、优点

​		Spring是一个开源的免费的框架(容器)！

# 2.IOC理论推导

​	1.UserDao接口

​	2.UserDaoImpl实现类

​	3.UserService业务接口

​	4.UserServiceImpl业务实现类

​	

​	在我们之前的业务中，用户的需求可能会影响我们原来的代码，我们需要根据需求去修改原代码！如果程序代码量十分大，修改的代价是十分昂贵的！

![image-20200613095224654](http://cdn.gvssimux.com/image-20200613095224654.png)

​	我们使用一个Set接口实现，发生革命性变化

```java
private UserDao userDao;

//利用一个Set进行动态实现值的注入
public void setUserDao(UserDao userDao) {
    this.userDao = use
```

- 之前，程序是主动创建对象！控制权在程序员手上！

- 使用了set注入后，程序不再具有主动性，而是变成了被动的接受对象！

    

​	这种思想，从本质上解决了问题，我们程序员不用再去管理对象的创建了。系统的耦合性大大降低，可以专注在业务的实现上！这是IOC的原型！

![3498](http://cdn.gvssimux.com/image-20200613093110666.png)



<img src="D:\笔记\Spring5\Spring.assets\image-20200613093222573.png" alt="image-20200613093222573"  />

### IOC本质

**控制反转IoC(Inversion of Control)，是一种设计思想，DI(依赖注入)是实现IoC的一种方法**，也有人认为DI只是IoC的另一种说法。没有IoC的程序中 , 我们使用面向对象编程 , 对象的创建与对象间的依赖关系完全硬编码在程序中，对象的创建由程序自己控制，控制反转后将对象的创建转移给第三方，个人认为所谓控制反转就是：获得依赖对象的方式反转了。

采用XML方式配置Bean的时候，Bean的定义信息是和实现分离的，而采用注解的方式可以把两者合为一体，Bean的定义信息直接以注解的形式定义在实现类中，从而达到了零配置的目的。

**控制反转是一种通过描述（XML或注解）并通过第三方去生产或获取特定对象的方式。在Spring中实现控制反转的是IoC容器，其实现方法是依赖注入（Dependency Injection,DI）。**

# 3、配置元数据

## 1、applicationContext.xml

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="..." class="...">  
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <bean id="..." class="...">
        <!-- collaborators and configuration for this bean go here -->
    </bean>

    <!-- more bean definitions go here -->

</beans>
```

## 2、实例化容器

```java
ApplicationContext context = new ClassPathXmlApplicationContext("services.xml", "daos.xml");
```





# 4、IOC创建对象的方式



1. 使用无参构造创建对象（默认）

2. 使用有参构造创建对象

    1. 下标赋值

        ```xml
        <!--下标赋值-->
            <bean id="user" class="com.shanzj.pojo.User">
                <constructor-arg index="0" value="单子健爱生活"/>
            </bean>
        ```

    2. Constructor argument name

        ```xml
        <!--Constructor argument name-->
        <bean id="user" class="com.shanzj.pojo.User">
            <constructor-arg name="name" value="单子健爱生活"/>
        </bean>
        ```

    3. Constructor argument type matching

        ```xml
        <!--Constructor argument type matching-->
        <bean id="user" class="com.shanzj.pojo.User">
            <constructor-arg type="java.lang.String" value="单子健爱生活"/>
        </bean>
        ```

    总结：在配置文件加载的时候，容器中管理的对象就已经初始化了~

# 5、spring配置 

## 5.1、别名

```xml
<!-- 别名，如果添加了别名，我们也可以使用别名获取到这个对象 -->
<alias name="user" alias="wwwww"/>
```

## 5.2、Bean的配置

```xml
<!--
id:bean 的唯一标识符，也就是相对于我们学的对象名
class：bean 对象所对应的全限定名：包名+类名
name：也是别名,而且name可以同时取多个别名(user2 u2 u3 u4 这里可以用很多东西去分割)
-->
<bean id="user" class="com.shanzj.pojo.User" name="user2,u2 u3;u4">
      <constructor-arg name="name" value="单子健爱生活2" />
</bean>
```

## 5.3、import

import 一般用于团队开发使用，他可以将多个配置文件，导入合并为一个

假如，现在项目中有多个人开发，这三个人复制不同的类开发，不同的类需要注册在不同的bean中，我们可以利用import将所有人的beans.xml合并为一个总的配置文件

- 张三

- 李四

- 王五

- applicationContext

    使用的时候，直接使用总的配置就可以了

    


# 6、依赖注入

## 6.1、构造器注入

前面4、IOC创建对象的方式讲述过了



## 6.2、通过set方式注入【重点】 

- 依赖注入：set注入！

    - 依赖：bean对象的创建依赖容器
    - 注入：bean对象中的所有属性，由容器来注入！

    【环境搭建】

    1. 复杂类型

        ```java
        public class Address {
            private  String address;
        
            public String getAddress() {
                return address;
            }
        
            public void setAddress(String address) {
                this.address = address;
            }
        }
        ```

    2. 真实测试对象

        ```java
        public class Student {
            private String name;
            private Address address;
            private String[] books;
            private List<String> hobbies;
            private Map<String, String> card;
            private Set<String> games;
            private Properties info;
            private String wife;
        }
        ```

    3. beans.xml

        ```xml
        <?xml version="1.0" encoding="UTF-8"?>
        <beans xmlns="http://www.springframework.org/schema/beans"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
               xsi:schemaLocation="http://www.springframework.org/schema/beans
                https://www.springframework.org/schema/beans/spring-beans.xsd">
        
        
        
        </beans>
        ```

    4. 测试类

        ```java
        public class test {
            @Test
            public void test01(){
                ApplicationContext context = new ClassPathXmlApplicationContext("beans.xml");
                Student studnet = (Student) context.getBean("student");
                System.out.println(studnet.getName());
            }
        }
        ```

    5. 完善注入信息

        ```xml
        <bean id="address" class="com.shanzj.pojo.Address">
            <property name="address" value="hf"/>
        </bean>
        
        <bean id="student" class="com.shanzj.pojo.Student">
            <!-- 普通注入  -->
            <property name="name" value="单子健"/>
        
            <!-- Bean注入 -->
            <property name="address" ref="address"/>
        
            <!--数组-->
            <property name="books">
                <array>
                    <value>水浒传</value>
                    <value>红楼梦</value>
                </array>
            </property>
        
            <!-- List -->
            <property name="hobbies">
                <list>
                    <value>打篮球</value>
                    <value>跑步</value>
                </list>
            </property>
        
            <!-- Map -->
            <property name="card">
                <map>
                    <entry key="银行卡" value="62132"/>
                    <entry key="身份证" value="345234"/>
                </map>
            </property>
        
            <!--Set-->
            <property name="games">
                <set>
                    <value>LOL</value>
                    <value>CSGO</value>
                </set>
            </property>
        
            <!-- property -->
            <property name="info">
                <props>
                    <prop key="性别">男</prop>
                    <prop key="年龄">18</prop>
                </props>
            </property>
        
            <!-- NULL -->
            <property name="wife">
                <null/>
            </property>
        
        </bean>
        ```

    

    

## 6.3、拓展方式注入

### 6.3.1、官方文档

我们使用p:命名空间(Set)和c:(构造)命名空间去注入

地址：https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-c-namespace

![image-20200615192059589](http://cdn.gvssimux.com/image-20200615192059589.png)



p-namespace

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:p="http://www.springframework.org/schema/p"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean name="classic" class="com.example.ExampleBean">
        <property name="email" value="someone@somewhere.com"/>
    </bean>

    <bean name="p-namespace" class="com.example.ExampleBean"
        p:email="someone@somewhere.com"/>
</beans>
```



c-namespace

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:c="http://www.springframework.org/schema/c"
    xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">

    <bean id="beanTwo" class="x.y.ThingTwo"/>
    <bean id="beanThree" class="x.y.ThingThree"/>

    <!-- traditional declaration with optional argument names -->
    <bean id="beanOne" class="x.y.ThingOne">
        <constructor-arg name="thingTwo" ref="beanTwo"/>
        <constructor-arg name="thingThree" ref="beanThree"/>
        <constructor-arg name="email" value="something@somewhere.com"/>
    </bean>

    <!-- c-namespace declaration with argument names -->
    <bean id="beanOne" class="x.y.ThingOne" c:thingTwo-ref="beanTwo"
        c:thingThree-ref="beanThree" c:email="something@somewhere.com"/>

</beans>
```



### 6.3.2、个人演示

userbeans.xml

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd">


    <bean name="user" class="com.shanzj.pojo.User" p:age="18" p:name="shanzj"/>

    <bean name="user2" class="com.shanzj.pojo.User" c:age="19" c:name="shanzj2"/>


</beans>
```

Usertest.java

```java
public class UserTest {
    @Test
    public void test(){
        ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("userbeans.xml");
        User user = context.getBean("user", User.class);
        User user2 = context.getBean("user2", User.class);
        System.out.println(user);
        System.out.println(user2);
    }
}
```

### 6.3.3、注意

p或c命名空间需要导入xml约束

```xml
xmlns:p="http://www.springframework.org/schema/p"
xmlns:c="http://www.springframework.org/schema/c"
```

## 6.4、bean的作用域

| Scope                                                        | Description                                                  |
| :----------------------------------------------------------- | ------------------------------------------------------------ |
| [singleton](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-singleton) | (Default) Scopes a single bean definition to a single object instance for each Spring IoC container. |
| [prototype](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-prototype) | Scopes a single bean definition to any number of object instances. |
| [request](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-request) | Scopes a single bean definition to the lifecycle of a single HTTP request. That is, each HTTP request has its own instance of a bean created off the back of a single bean definition. Only valid in the context of a web-aware Spring `ApplicationContext`. |
| [session](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-session) | Scopes a single bean definition to the lifecycle of an HTTP `Session`. Only valid in the context of a web-aware Spring `ApplicationContext`. |
| [application](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/core.html#beans-factory-scopes-application) | Scopes a single bean definition to the lifecycle of a `ServletContext`. Only valid in the context of a web-aware Spring `ApplicationContext`. |
| [websocket](https://docs.spring.io/spring/docs/5.2.7.RELEASE/spring-framework-reference/web.html#websocket-stomp-websocket-scope) | Scopes a single bean definition to the lifecycle of a `WebSocket`. Only valid in the context of a web-aware Spring `ApplicationContext`. |

1. singleton

    ```xml
    <bean name="user" class="com.shanzj.pojo.User" p:age="18" p:name="shanzj" scope="singleton"/>
    ```

    **默认是单例模式**

    ![image-20200615193846405](http://cdn.gvssimux.com/image-20200615193846405.png)

2. The Prototype Scope

    原型模式：每次从容器中get的时候，都会产生一个新对象！

    ```xml
    <bean name="user" class="com.shanzj.pojo.User" p:age="18" p:name="shanzj" scope="prototype"/>
    ```

    ![image-20200622200532161](http://cdn.gvssimux.com/image-20200622200532161.png)

3. 其余的Request、Session、Application、websocket 只能在web开发中使用到





# 7、Bean的自动装配

- 自动装配是Spring满足bean依赖的一种方式！
- Spring会在上下中自动寻找，并自动给bean装配属性！



在Spring中有三种装配的方式

1. 在xml中显示的配置

2. 在java中显示配置

3. 隐式的自动装配Bean【重要】

    

    

## 7.1、测试

环境搭建：一个人有两个宠物

dog

```java
public class Dog {
    public void shout(){
        System.out.println("汪");
    }
}
```



cat

```java
public class Cat {
    public void shout(){
        System.out.println("喵");
    }
}
```



People

```java
public class People {
    private Cat cat;
    private Dog dog;
    private String name;

    @Override
    public String toString() {
        return "People{" +
                "cat=" + cat +
                ", dog=" + dog +
                ", name='" + name + '\'' +
                '}';
    }

    public Cat getCat() {
        return cat;
    }

    public void setCat(Cat cat) {
        this.cat = cat;
    }

    public Dog getDog() {
        return dog;
    }

    public void setDog(Dog dog) {
        this.dog = dog;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```





## 7.2、ByName自动装配

```xml
 	<bean id="cat" class="com.shanzj.pojo.Cat"/>
    <bean id="dog" class="com.shanzj.pojo.Dog"/>
<!--
    byName:会自动在容器上下文查找，和自己对象set方法后面的值对应的bean的id！际setBeanId(...)..
-->
    <bean name="people" class="com.shanzj.pojo.People" autowire="byName">
        <property name="name" value="shanzj"/>
    </bean>
```

ps：在这里要充分理解其中的含义，比如说将cat的bean-id改为cat1或Cat时会报“空指针异常”。



## 7.3、ByType自动装配

```xml
	<bean id="cat" class="com.shanzj.pojo.Cat"/>
    <bean id="dog" class="com.shanzj.pojo.Dog"/>
<!--
    byType:会自动在容器上下文查找，和自己对象中所包含的属性类型相同的 bean的id！
-->
    <bean name="people" class="com.shanzj.pojo.People" autowire="byType">
        <property name="name" value="shanzj"/>
    </bean>
```

ps：在这里也可以将bean-id删去，因为时根据类型查找的嘛，但如果这有两个cat或者两个dog就会报错。

==byName和byType都需要set方法==

​	==byName：set方法名   和  bean的id名 (容器里可以有多个dog，但要注意Dao.java中的set方法名字)==

​	==byType：bean对应的类  和  要自动装配的bean对应的类的属性（容器里不能有多个dog）==

## 7.4、使用注解实现自动装配

jdk看1.5支持的注解，Spring2.5就支持了

The introduction of annotation-based configuration raised the question of whether this approach is “better” than XML. The short answer is “it depends.”（基于注释的配置的引入提出了这样一个问题:这种方法是否比XML“更好”。简短的回答是“视情况而定”。）

要使用注解须知：

1. 导入约束    context约束( xmlns:context="http://www.springframework.org/schema/context")

2. ==配置注解的支持==

    ```xml
    <context:annotation-config/>
    ```

    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <beans xmlns="http://www.springframework.org/schema/beans"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:context="http://www.springframework.org/schema/context"
        xsi:schemaLocation="http://www.springframework.org/schema/beans
            https://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/context
            https://www.springframework.org/schema/context/spring-context.xsd">
    
        <context:annotation-config/>
    
    </beans>
    ```

3. 自动装配

    - @Autowired

        直接在属性上添加使用，也可以在set方法上添加使用

        ```java
        import org.springframework.beans.factory.annotation.Autowired;
        
        public class People {
        
            private Cat cat;
            @Autowired        	//加在属性上
            private Dog dog;
            private String name;
        
            @Override
            public String toString() {
                return "People{" +
                        "cat=" + cat +
                        ", dog=" + dog +
                        ", name='" + name + '\'' +
                        '}';
            }
        
            public Cat getCat() {
                return cat;
            }
            @Autowired				//加在set方法上使用！
            public void setCat(Cat cat) {
                this.cat = cat;
            }
        
            public Dog getDog() {
                return dog;
            }
        
            public void setDog(Dog dog) {
                this.dog = dog;
            }
        
            public String getName() {
                return name;
            }
        
            public void setName(String name) {
                this.name = name;
            }
        }
        
        ```

        同时Autowired 也可不必写set方法，前提是自动装配的对象在IOC容器（或者叫Spring容器，bean容器  但IOC容器是正规叫法）中我，其符合byType，也就是说beans.xml中的BeanId可以不和要配置的属性名一致，比如

        ```xml
        <bean id="dog111瓦s大213大" class="com.shanzj.pojo.Dog"/>
        ```

        注意：大部分是说先按byType，然后有相同时再byName

        

    - @Nullable  

        测试

        ```java
        //如果显示定义了Autowired的required的属性为false，说明这个对象为null，否则不能为空
        @Autowired(required = false)
        private Cat cat;
        @Autowired
        private Dog dog;
        private String name;
        @Override
        ```

        

    - @Qualifier

        如果@Autowired自动装配的环境比较复杂，自动装配无法通过@Autowired完成时，需要配合@Qualifer去添加限定符，指定一个bean对象注入

        

        people.java

        ```java
        public class People {
        
        
            @Autowired
            private Cat cat;
            @Qualifier("dog11")   // <------
            @Autowired
            private Dog dog;
            private String name;
            @Override
            public String toString() {
                return "People{" +
                        "cat=" + cat +
                        ", dog=" + dog +
                        ", name='" + name + '\'' +
                        '}';
            }
        
            public Cat getCat() {
                return cat;
            }
        
        
            public Dog getDog() {
                return dog;
            }
        
        
            public String getName() {
                return name;
            }
        
            public void setName(String name) {
                this.name = name;
            }
        }
        ```

        beans.xml

        ```xml
        <bean id="cat" class="com.shanzj.pojo.Cat"/>
        <bean id="dog1112" class="com.shanzj.pojo.Dog"/>
        <bean id="dog11" class="com.shanzj.pojo.Dog"/>
        <bean name="people" class="com.shanzj.pojo.People"/>
        ```

        

    - @Resource（在JDK11中被移出了）
      
        集成了@Autowired@Qualifier，但在大部分开发中不怎么使用，因为效率比前者要低点
        
        people.java
        
        ```java
        public class People {
        
            @Resource
            private Cat cat;
            @Resource(name = "dog11")
            private Dog dog;
            private String name;
            @Override
            public String toString() {
                return "People{" +
                        "cat=" + cat +
                        ", dog=" + dog +
                        ", name='" + name + '\'' +
                        '}';
            }
        
            public Cat getCat() {
                return cat;
            }
        
        
            public Dog getDog() {
                return dog;
            }
        
        
            public String getName() {
                return name;
            }
        
            public void setName(String name) {
                this.name = name;
            }
        }
        ```
        
        beans.xml
        
        ```xml
        <bean id="cat" class="com.shanzj.pojo.Cat"/>
        <bean id="dog1112" class="com.shanzj.pojo.Dog"/>
        <bean id="dog11" class="com.shanzj.pojo.Dog"/>
        <bean name="people" class="com.shanzj.pojo.People"/>
        ```



4.总结

@Resource和@Autowired的区别

- 都是用来自动装配的，都可以放在属性的字段上

- 实现方式：先按byType，然后有相同时再byName(不太确定）

- 如果命名不一致同时出现多个同类型时，可以分别用@Resource(name = "dog11")和

    @Qualifier("dog11")   @Autowired来指定

- 执行顺序不同@Autowired------byType，byName       @Resource-----byName，byType





# 8、使用注解开发

在Spring4之后，要使用注解开发，必须保证AOP的包导入了

![image-20200708120022792](http://cdn.gvssimux.com/image-20200708120022792.png)

使用注解需要导入context约束，增加注解的支持

1. bean

     ```java
    @Component  //等价于<bean id="user" class="com.shanzj.pojo.User"/>
    ```

    

2. 属性如何注入

    ```java
    @Component  //等价于<bean id="user" class="com.shanzj.pojo.User"/>
    public class User {
        @Value("shanzj")    //相当于<property name="name" value="shanzj"/>
        public String name;
    
    }
    ```

3. 衍生的注解

    @Component 有一些衍生注解，我们在web开发中，会按照mvc三层架构分层

    - dao  【@Repository】

    - service 【@Service】

    - controller 【@Controller】

        这四个注解的功能都是一样的，都是代表将某给类注册的IOC容器中，然后装配bean

4. 自动装配

    @Autowired 

    @Nullable

    @Resource 见7.4

5. 作用域

    单例模式	@Scope("singleton")  

    原型模式    @Scope("Prototype")  				见6.4bean的作用域

    

6. 小结

    xml与注解对比：

    - xml更加万能，适用于任何场合！维护简单
    - 注解：不是自己的类使用不了，维护现对复杂

    

    xml与注解的最佳实践：

    - xml用来管理bean

    - 而注解来注入属性

    - 在使用过程中要注意，必须让注解生效的话，就需要开启注解的支持和扫包

    - ```xml
        <context:component-scan base-package="com.shanzj"/>
        <context:annotation-config/>
        ```

# 9、使用Java的方式去配置Spring

现在我们完全不用Spring 的xml去配置，全都交于java来做

JavaConfig是Spring的一个子项目，在Spring4之后，它成为了一个核心功能

![image-20200708222515713](http://cdn.gvssimux.com/image-20200708222515713.png)



==User.java 实体类==

```java
//这里这个注解的意思，就是说明这个类被Spring接管了，也就是注册到了容器中
@Component
public class User {
    @Value("单子健")       //属性注入值
    private  String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


}
```



==ShanzjConfig.java 配置文件(配置类)==

```java
@Configuration      				
//这个也会被Spring容器托管，注册到容器中，因为他本来就是一个Component, @Configuration代表一个配置类，就和我们之前看的beans.xml一样
@ComponentScan("com.shanzj.pojo")   
//如果不扫包的话，在test中，使用不了类名去获取对象User user = (User) context.getBean("user");
@Import(ShanzjConfig2.class)
//导入多个配置文件
public class ShanzjConfig {
    
    //注册一个bean，就相当于我们之前写的bean标签，
    // bean-id==方法名即为getUser
    // bean-class==方法的返回值return new User()
    
    @Bean
    public User getUser(){
        return new User();  //就是返回要注入到bean的对象
    }
    
}

```



==Test.java 测试类==

注意：

- 这里的IOC容器中有2个user 一个通过getUser去取一个通过user去取
- ShanzjConfig.class也可替换为"com.shanzj.config"

```java
@Test
public void test01(){
    ApplicationContext context = new AnnotationConfigApplicationContext(ShanzjConfig.class);
    User getUser = (User) context.getBean("getUser");
    User user = (User) context.getBean("user");
    System.out.println(getUser);
    System.out.println(user);
}
```

**这种纯java的配置方式，在SpringBoot中随处可见**





# 10、代理模式

为什么要学习代理模式？因为这就是SpringAOP的底层。SpringAOP和SpringMVC面试必问

代理模式的分类：

- 静态代理

- 动态代理

    ![image-20200716175153840](http://cdn.gvssimux.com/image-20200716175153840.png)

## 10.1、静态代理

角色分析：

- 抽象角色：一般会使用接口或者抽象类来解决
- 真实角色：被代理的角色
- 代理角色：代理真实角色，代理真实角色后，我们一般会做一些附属操作
- 客户：访问代理对象的人



代理模式的好处

- 可以使真实角色的操作更加纯粹，不用去关注一些公共的业务
- 公共业务也就交给了代理角色，实现了业务的分工
- 公共业务发生拓展的时候，方便集中管理

缺点：

- 一个真实角色就会产生一个代理角色，开发效率就变低了



案例：

1.接口

```java
//租房
public interface Rent {
    public void rent();
}
```

2.真实角色

```java
//房东
public class HouseMaster implements Rent{

    public void rent() {
        System.out.println("房东要出租房子");
    }

}
```

3.代理角色

```java
public class Proxy implements Rent{
    private HouseMaster houseMaster;

    public Proxy(HouseMaster houseMaster) {
        this.houseMaster = houseMaster;
    }

    public Proxy() {
    }

    public void rent() {
        seeHouse();
        houseMaster.rent();
        hetong();
        fare();
    }

    //看房
    public void seeHouse(){
        System.out.println("中介带你看房子");
    }

    //签合同
    public void hetong(){
        System.out.println("签合同");
    }

    //收中介费
    public void fare(){
        System.out.println("收中介费");
    }
}
```

4.客户端访问代理角色

```java
public class Client {
    public static void main(String[] args) {
        HouseMaster houseMaster = new HouseMaster();
        //代理，中介帮房东租房子，但是代理角色(中介)会有一些附属操作
        Proxy proxy = new Proxy(houseMaster);

        //你不用面对房东，直接找中介租房即可
        proxy.rent();
    }
}
```



## 10.2、静态代理2

AOP

![image-20200716223456090](http://cdn.gvssimux.com/image-20200716223456090.png)



## 10.3、动态代理

- 动态代理和静态代理角色一样
- 动态代理的代理类是动态生成的，不是我们直接写好的
- 动态代理分为两大类：1.基于接口的动态代理  2.基于类的动态代理
    - 基于接口——JDK的动态代理【使用这个】
    - 基于类：cglib
    - java字节码实现：javalist

需要了解两个类，Proxy，InvocationHandler



动态代理的好处：

- 可以使真实角色的操作更加纯粹，不用去关注一些公共的业务
- 公共业务也就交给了代理角色，实现了业务的分工
- 公共业务发生拓展的时候，方便集中管理
- 一个动态代理类代理的是一个接口，一般就是对应的一类业务
- 一个动态代理类可以代理多个类，只要实现了同一个接口即可





案例

1.接口

```java
public interface UserService {
    public void add();
    public void delete();
    public void update();
    public void query();

}
```

2.真实角色

```java
//真实对象
public class UserServiceImpl implements UserService{
    public void add() {
        System.out.println("增加了一个用户");
    }

    public void delete() {
        System.out.println("删除了一个用户");
    }

    public void update() {
        System.out.println("修改了一个用户");
    }

    public void query() {
        System.out.println("查询了一个用户");
    }
}
```

3.代理角色

```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

//等会用这个类去自动生成代理类
public class ProxyInvocationHandler implements InvocationHandler {

    //被代理的接口
    private Object target;   //可替换

    public void setTarget(Object target) {
        this.target = target;
    }

    //生成得到代理类
    public Object getProxy(){
        return Proxy.newProxyInstance(this.getClass().getClassLoader(),target.getClass().getInterfaces(),this);
    }


    //处理代理实例，并返回结果
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        //动态代理的本质就是使用反射机制
        Object result = method.invoke(target, args);
        log(method.getName()); //反射得到方法名
        return null;
    }

    public void  log(String msg){
        System.out.println("执行了"+msg+"方法");
    }

}
```

4.客户端访问

```java
public class Client {
    public static void main(String[] args) {
        //真实对象
        UserServiceImpl userService = new UserServiceImpl();
        //代理
        ProxyInvocationHandler pih = new ProxyInvocationHandler();
        //设置代理的对象，即userService
        pih.setTarget(userService);
        //动态的生成代理对象
        UserService proxy = (UserService) pih.getProxy();
        proxy.query();
    }
}
```





# 11、AOP

## 11.1、什么是AOP

AOP（Aspect Oriented Programming）意为：面向切面编程，通过预编译方式和运行期动态代理实现 程序功能的统一维护的一种技术。AOP是OOP的延续，是软件开发中的一个热点，也是Spring框架中的 一个重要内容，是函数式编程的一种衍生范型。利用AOP可以对业务逻辑的各个部分进行隔离，从而使 得业务逻辑各部分之间的耦合度降低，提高程序的可重用性，同时提高了开发的效率。

![image-20200718095159793](http://cdn.gvssimux.com/image-20200718095159793.png)

## 11.2AOP在SPring中的作用

==声明式事务；允许用户自定义切面==

- 横切关注点：跨越应用程序多个模块的方法或功能。即是，与我们业务逻辑无关的，但是我们需要 关注的部分，就是横切关注点。如日志 , 安全 , 缓存 , 事务等等 .... 
- 切面（ASPECT）：横切关注点 被模块化 的特殊对象。即，它是一个类。 
- 通知（Advice）：切面必须要完成的工作。即，它是类中的一个方法。 
- 目标（Target）：被通知对象。 
- 代理（Proxy）：向目标对象应用通知之后创建的对象。
-  切入点（PointCut）：切面通知 执行的 “地点”的定义。
-  连接点（JointPoint）：与切入点匹配的执行点。



![image-20200718095355844](http://cdn.gvssimux.com/image-20200718095355844.png)

即 Aop 在 不改变原有代码的情况下 , 去增加新的功能 . 

## 11.3使用Spring实现AOP

首先需要导包

```xml
<!-- https://mvnrepository.com/artifact/org.aspectj/aspectjweaver -->
<dependency>
    <groupId>org.aspectj</groupId>
    <artifactId>aspectjweaver</artifactId>
    <version>1.9.5</version>
</dependency>
```



### 方法一：通过Spring API实现【主要是SpringAPI接口实现】

业务接口

```java
public interface UserService {
    public void add();
    public void delete();
    public void update();
    public void query();

}
```

业务接口的实现类

```java
//真实对象
public class UserServiceImpl implements UserService{
    public void add() {
        System.out.println("增加了一个用户");
    }

    public void delete() {
        System.out.println("删除了一个用户");
    }

    public void update() {
        System.out.println("修改了一个用户");
    }

    public void query() {
        System.out.println("查询了一个用户");
    }
}
```

业务增强类，这里举一个前置增强一个后置增强为例子

```java
import org.springframework.aop.MethodBeforeAdvice;

import java.lang.reflect.Method;

public class Log implements MethodBeforeAdvice {
    //method : 要执行的目标对象的方法  
    // objects : 被调用的方法的参数(arg)    
    // o : 目标对象(object)
    public void before(Method method, Object[] objects, Object o) throws Throwable {
        System.out.println( o.getClass().getName() + "的" + method.getName() + "方法被执行了");
    }
}
```

```java
import org.springframework.aop.AfterReturningAdvice;

import java.lang.reflect.Method;

public class AfterLog implements AfterReturningAdvice {
    // o 返回值    returnValue
    // method被调用的方法    
    // args 被调用的方法的对象的参数    
    // o1 被调用的目标对象   targer
    public void afterReturning(Object o, Method method, Object[] objects, Object o1) throws Throwable {
        System.out.println("执行了" + o1.getClass().getName()+"的"+method.getName()+"方法,"+"返回值："+o);
    }
}
```

然后在Spring中注册，并实现AOP切入，注意导入约束

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

        <!--注册bean-->
        <bean id="UserService" class="com.shanzj.service.UserServiceImpl"/>
        <bean id="log" class="com.shanzj.log.Log"/>
        <bean id="afterLog" class="com.shanzj.log.AfterLog"/>

        <!--aop的配置-->
        <aop:config>
            <!--切入点  expression:表达式匹配要执行的方法-->
            <aop:pointcut id="pointcut" expression="execution(* com.shanzj.service.UserServiceImpl.*(..))"/>
            <!--执行环绕; advice-ref执行方法 . pointcut-ref切入点-->
            <aop:advisor advice-ref="log" pointcut-ref="pointcut"/>
            <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
        </aop:config>

</beans>
```

测试

```java
public class Test {
    @org.junit.Test
    public void test01(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserService userService = (UserService) context.getBean("UserService");
        userService.query();
    }

}
```





### 方式二：自定义类来实现AOP【主要是切面定义】

将业务增强类替换为

```java
public class DiyPointCut {
    public void before(){
        System.out.println("方法执行前");
    }

    public void after(){
        System.out.println("方法执行后");
    }
}
```

applicationContext

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

        <!--注册bean-->
        <bean id="UserService" class="com.shanzj.service.UserServiceImpl"/>
        <bean id="log" class="com.shanzj.log.Log"/>
        <bean id="afterLog" class="com.shanzj.log.AfterLog"/>

        <!--aop的配置-->
        <!--<aop:config>
            &lt;!&ndash;切入点  expression:表达式匹配要执行的方法&ndash;&gt;
            <aop:pointcut id="pointcut" expression="execution(* com.shanzj.service.UserServiceImpl.*(..))"/>
            &lt;!&ndash;执行环绕; advice-ref执行方法 . pointcut-ref切入点&ndash;&gt;
            <aop:advisor advice-ref="log" pointcut-ref="pointcut"/>
            <aop:advisor advice-ref="afterLog" pointcut-ref="pointcut"/>
        </aop:config>-->

        <!--方式二：-->
        <bean id="diy" class="com.shanzj.diy.DiyPointCut"/>

        <aop:config>
            <!--自定义切面，ref要引用的类-->
            <aop:aspect ref="diy">
                <!--切入点(切面)-->
                <aop:pointcut id="point" expression="execution(* com.shanzj.service.UserServiceImpl.*(..))"/>
                <!--通知-->
                <aop:after method="after" pointcut-ref="point"/>
                <aop:before method="before" pointcut-ref="point"/>
            </aop:aspect>
        </aop:config>


</beans>
```

其他的不用动，但这里就不能用反射了。



### 方法三：使用注解实现

业务增强类

```java
@Aspect
public class AnnotionPointCut {
    @Before("execution(* com.shanzj.service.UserServiceImpl.*(..))")
    public void before(){
        System.out.println("方法执行之前===");
    }

    @After("execution(* com.shanzj.service.UserServiceImpl.*(..))")
    public void after(){
        System.out.println("方法执行后==");
    }

    //在环绕增强中，我们可以给定一个参数，代表我们要获取处理的切入点
    @Around("execution(* com.shanzj.service.UserServiceImpl.*(..))")
    public void around(ProceedingJoinPoint joinPoint) throws Throwable {

        System.out.println("环绕前");

        //执行方法
        System.out.println(joinPoint.getSignature());
        Object proceed = joinPoint.proceed();



        System.out.println("环绕后");
    }
}
```

applicationContext.xml

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

        <!--注册bean-->
        <bean id="UserService" class="com.shanzj.service.UserServiceImpl"/>
        <bean id="log" class="com.shanzj.log.Log"/>
        <bean id="afterLog" class="com.shanzj.log.AfterLog"/>


        <!--方法三-->
        <bean id="annotionPointCut" class="com.shanzj.diy.AnnotionPointCut"/>
        <!--开启注解支持      JDK(默认proxy-target-class="false") cglib(proxy-target-class="true")-->
        <aop:aspectj-autoproxy proxy-target-class="true"/>


</beans>
```





# 12、整合Mybatis

步骤:

1. 导入相关jar包
    - junit
    - mybatis
    - mysql数据库
    - Spring相关的
    - AOP织入
    - mybatis-spring【新】
2. 编写配置文件
3. 测试

## 12.1、回忆mybatis

1. 编写实体类

    ```java
    import lombok.Data;
    
    @Data
    public class User {
        private int id;
        private String name;
        private String pwd;
    }
    ```

2. 编写核心配置文件

    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE configuration
            PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-config.dtd">
    <configuration>
        <typeAliases>
            <package name="com.shanzj.pojo"/>
        </typeAliases>
        
        <environments default="development">
            <environment id="development">
                <transactionManager type="JDBC"/>
                <dataSource type="POOLED">
                    <property name="driver" value="com.mysql.cj.jdbc.Driver"/>
                    <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;serverTimezone=Asia/Shanghai&amp;useUnicode=true&amp;characterEncoding=utf8"/>
                    <property name="username" value="root"/>
                    <property name="password" value="root"/>
                </dataSource>
            </environment>
        </environments>
    
        <!--每一个Mapper.xml都需要在Mybatis核心配置文件中注册-->
        <mappers>
            <mapper resource="com/shanzj/dao/UserMapper.xml"/>
        </mappers>
    </configuration>
    ```

    

3. 编写接口

    ```java
    import com.shanzj.pojo.User;
    
    import java.util.List;
    
    public interface UserMapper {
        public List<User> selectUser();
    }
    ```

4. 编写Mapper.xml

    ```xml
    <?xml version="1.0" encoding="UTF-8" ?>
    <!DOCTYPE mapper
            PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
            "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
    <mapper namespace="com.shanzj.mapper.UserMapper">
    
        <select id="selectUser" resultType="user">
           select * from user;
       </select>
    
    </mapper>
    ```

    

5. 测试

    ```java
    @org.junit.Test
    public void test02() throws IOException {
        String resource = "mybatis-config.xml";
        InputStream inputStream = Resources.getResourceAsStream(resource);
        SqlSession sqlSession = new SqlSessionFactoryBuilder().build(inputStream).openSession();
        UserMapper mapper = sqlSession.getMapper(UserMapper.class);
        List<User> users = mapper.selectUser();
        for (User user : users) {
            System.out.println(user);
        }
    }
    ```

    



## 12.2、Mybatis-Spring(多了一个接口实现类)

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:p="http://www.springframework.org/schema/p"
       xmlns:c="http://www.springframework.org/schema/c"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
        https://www.springframework.org/schema/beans/spring-beans.xsd
        http://www.springframework.org/schema/aop
        https://www.springframework.org/schema/aop/spring-aop.xsd">

        <!--DataSource:使用Spring的数据源替换mybatis的配置  c3p0 dbcp  druid 在这使用Spring的JDBC！-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;serverTimezone=Asia/Shanghai&amp;useUnicode=true&amp;characterEncoding=utf8"/>
        <property name="username" value="root"/>
        <property name="password" value="root"/>
    </bean>


        <!--sqlSessionFactory-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <property name="mapperLocations" value="classpath:com/shanzj/mapper/*.xml"/>
    </bean>

    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>


</beans>
```

1. 编写数据源配置

    ```xml
     <!--DataSource:使用Spring的数据源替换mybatis的配置  c3p0 dbcp  druid 在这使用Spring的JDBC！-->
    <bean id="dataSource" class="org.springframework.jdbc.datasource.DriverManagerDataSource">
        <property name="driverClassName" value="com.mysql.cj.jdbc.Driver"/>
        <property name="url" value="jdbc:mysql://localhost:3306/mybatis?useSSL=true&amp;serverTimezone=Asia/Shanghai&amp;useUnicode=true&amp;characterEncoding=utf8"/>
        <property name="username" value="root"/>
        <property name="password" value="root"/>
    </bean>
    ```

2. sqlSessionFactory

    ```xml
    <!--sqlSessionFactory-->
    <bean id="sqlSessionFactory" class="org.mybatis.spring.SqlSessionFactoryBean">
        <property name="dataSource" ref="dataSource" />
        <property name="configLocation" value="classpath:mybatis-config.xml"/>
        <property name="mapperLocations" value="classpath:com/shanzj/mapper/*.xml"/>
    </bean>
    ```

3. sqlSession

    ```xml
    <bean id="sqlSession" class="org.mybatis.spring.SqlSessionTemplate">
        <constructor-arg index="0" ref="sqlSessionFactory"/>
    </bean>
    ```

4. 将userMapper的接口实现类注入到Spring中去

    ```xml
    <beans xmlns="http://www.springframework.org/schema/beans"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:p="http://www.springframework.org/schema/p"
           xmlns:c="http://www.springframework.org/schema/c"
           xmlns:aop="http://www.springframework.org/schema/aop"
           xsi:schemaLocation="http://www.springframework.org/schema/beans
            https://www.springframework.org/schema/beans/spring-beans.xsd
            http://www.springframework.org/schema/aop
            https://www.springframework.org/schema/aop/spring-aop.xsd">
        <import resource="spring-dao.xml"/>
    
        <!---->
        <bean id="userMapperImpl" class="com.shanzj.mapper.UserMapperImpl">
            <property name="sqlSession" ref="sqlSession"/>
        </bean>
        
        <!--方法二，在这里就不用在spring-dao.xml中去写SqlSessionTemplate即3.sqlSession就省略了-->
        <bean id="userMapperImpl2" class="com.shanzj.mapper.UserMapperImpl2">
            <property name="sqlSessionFactory" ref="sqlSessionFactory"/>
        </bean>
    
    
    </beans>
    ```

5. 测试

    ```java
    public class Test {
        @org.junit.Test
        public void test01() throws IOException {
            ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
            UserMapper userMapperImpl = context.getBean("userMapperImpl", UserMapper.class);
            List<User> users = userMapperImpl.selectUser();
            for (User user : users) {
                System.out.println(user);
            }
        }
    
    
    }
    ```

==方法二：==

在这里就不用在spring-dao.xml中去写SqlSessionTemplate即  sqlSession就省略了





# 13、声明式事务

## 13.1、回顾事务

- 把一组业务当成一个业务来做，要么都成功，要么都失败。
- 事务在项目开发中，十分重要，涉及到数据的一致性问题，不得马虎！
- 确保完整性和一致性；



事务的ACID原则

- 原子性

- 一致性

- 隔离型

    - 多个业务操作一个资源的时候，不会影响数据的正确性，防止数据损坏

- 持久性

    - 事务一旦提交，无论系统发生什么问题，结果都不会再被影响，被持久化的写到了存储器中

    

13.2、Spring中的事务管理器

- 声明式事务：AOP横切进去的不需要改原有代码
- 编程时事务：需要改动代码进行事务的管理



思考：

为什么要配置事务？

- 如果不配置事务的话，可能存在数据提交不一致的情况下
- 如果我们不在Spring中去配置申明式事务，我们就需要在代码中手动配置事务
- 事务在项目的开发中十分重要