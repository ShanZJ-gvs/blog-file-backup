报错：找不到js文件

GET http://localhost:8080/SpringMVC_07_ajax_war_exploded/statics/js/jquery-3.5.1.js net::ERR_ABORTED 404

![image-20200826161638234](http://cdn.gvssimux.com/image-20200826160955511.png)

![image-20200826161731230](http://cdn.gvssimux.com/image-20200826161731230.png)

1. 先检查文件路径是否正确，文件是否在指定位置

2. 使用cdn的js文件测试 
 ```jsp
	<script src="https://cdn.bootcdn.net/ajax/libs/jquery/3.5.1/jquery.js"></script> 
 ```

![image-20200826161901583](http://cdn.gvssimux.com/image-20200826161901583.png)

3. 如果可行，先看下在springmvc的配置文件中是否添加静态资源过滤  
    ```xml
        <mvc:default-servlet-handler/>
    ```
    ![image-20200826162129611](http://cdn.gvssimux.com/image-20200826162129611.png)

4. 然后在maven中clean下

    ![image-20200826162336253](http://cdn.gvssimux.com/image-20200826162336253.png)

    5. 重启下项目

        ![image-20200826163009635](http://cdn.gvssimux.com/image-20200826163009635.png)


