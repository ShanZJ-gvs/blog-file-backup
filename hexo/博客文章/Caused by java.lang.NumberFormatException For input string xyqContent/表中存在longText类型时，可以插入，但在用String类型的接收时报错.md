表中存在longText类型时，可以插入，但在用String类型的接收时报错

**错误**

```
Caused by: java.lang.NumberFormatException: For input string: "xyqContent"
```

![image-20200909232335287](http://cdn.gvssimux.com/image-20200909232335287.png)

**测试日志的输出的sql**

```
[com.gvssimux.dao.XyqMapper.selectByPrimaryKey]-==>  Preparing: select id, forum_type, xyq_id, xyq_title, xyq_content, sort, views, author_id, author_name, author_avatar, son_id, son_type, create_time, update_time from forum_xyq where id = ?
[com.gvssimux.dao.XyqMapper.selectByPrimaryKey]-==> Parameters: 4(Integer)

```

![image-20200909232524728](http://cdn.gvssimux.com/image-20200909232524728.png)

**可以查询到**

**对应的Mapper.xml**

![image-20200909232721824](http://cdn.gvssimux.com/image-20200909232721824.png)



**对应的类**

![image-20200909232807427](http://cdn.gvssimux.com/image-20200909232807427.png)



求解！！！