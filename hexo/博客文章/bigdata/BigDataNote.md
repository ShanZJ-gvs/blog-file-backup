---
title: 大数据比赛环境搭建
date: 2020-10-11 22:54:49
updated: 2020-10-29 22:54:49
comments: false
excerpt: 本科大数据比赛的环境搭建，实测无坑
categories:
  - [本科]
  - [LInux]
  - [环境搭建]
tags:
  - 本科
  - LInux
  - 环境搭建
---
# 前言

## 环境

CentOS7，安装时选择的GUI服务器

在这里配置了三给节点分别是node01、node02、node03，ip的地址是VMware自动配置的

Java 1.8.0_241、Mysql 5.7.31 root 123456(只有node01安装了)、Hadoop 2.6.0、Python 2.7.5、Python 3.6.5、Hive 1.2.1





# CentOS7换源

```bash
# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup

# wget -O /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo

# curl -o /etc/yum.repos.d/CentOS-Base.repo https://mirrors.aliyun.com/repo/Centos-7.repo
```

# 关闭防火墙

```bash
$sudo systemctl stop firewalld.service

$sudo systemctl disable firewalld.service
```



# 配置 hosts实现主机名和ip地址映射

**三台机器都需要**

> vim /etc/hosts

![image-20201007183903708](http://cdn.gvssimux.com/image-20201007183903708.png)





# 更改主机名

**在node0x上执行**

```bash
# hostname node0x
```



# 配置SSH免密登录

1. **生成公钥** 

    > ssh-keygen -t rsa

    回车回车

2. **拷贝node02，node03到node01上去**

    >  ssh-copy-id node01

    在node01,02,03上执行 然后输入yes 再输入node01的密码

    node02,node03 可以免密登录nod01

    但node01不能登录node02，node03

3. **复制node01的认证到其他机器上去**

    ```bash
    # scp /root/.ssh/authorized_keys node02:/root/.ssh/
    
    # scp /root/.ssh/authorized_keys node03:/root/.ssh/
    ```

4. **测试ssh免密登录**

    ![image-20201007155207982](http://cdn.gvssimux.com/image-20201007155207982.png)



# 时钟同步(非必须)

**安装**

yum install -y ntp

**启动定时任务**

contab -e

**随后输入**

*/1****/usr/sbin/ntpdate ntp4.aliyun.com;



# 卸载Mysql

> 如果你使用环境非常干净，不需要做这一步，只是有的时候操作失误，又不想重新搭环境(●'◡'●)   
>
> 也可自行百度如何卸除mysql

![](http://cdn.gvssimux.com/20201027181617.png)

方法一：rpm -qa |grep -i mysql

-i 作用是不区分大小写

方法二：yum list installed mysql*

**可以看到有两个安装包**

MySQL-server-5.6.19-1.linux_glibc2.5.x86_64.rpm
MySQL-client-5.6.19-1.linux_glibc2.5.x86_64.rpm

**删除这两个服务(去掉后缀)**

rpm –e MySQL-client-5.6.19-1.linux_glibc2.5.x86_64（不行）
rpm -e MySQL-server-5.6.19-1.linux_glibc2.5.x86_64（不行）

yum remove mysql-comm*(可以)

**查看残留的目录：**

whereis mysql

**然后删除mysql目录：**

rm –rf /usr/lib64/mysql

**删除相关文件：**

rm –rf /usr/my.cnf
rm -rf /root/.mysql_sercret

**最关键的：**

rm -rf /var/lib/mysql

**如果这个目录如果不删除，再重新安装之后，密码还是之前的密码，不会重新初始化！**

**网上查了很久都没有文章提到这个，最后还是自己摸索找出来的。**

**卸载完成！怎么确定是不是真的卸载干净了呢？**

**一是看安装输出：**

如果没有卸载干净，安装server时输入只有两行：



```plain
[root@localhost opt]# rpm -ivh MySQL-server-5.6.19-1.linux_glibc2.5.x86_64.rpmPreparing...                ########################################### [100%]   1:MySQL-server           ########################################### [100%]
```

卸载干净了安装输入如下：



```plain
[root@localhost opt]# rpm -ivh MySQL-server-5.6.19-1.linux_glibc2.5.x86_64.rpmPreparing...                ########################################### [100%]   1:MySQL-server           ########################################### [100%]2014-09-23 07:22:43 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).2014-09-23 07:22:43 26041 [Note] InnoDB: Using atomics to ref count buffer pool pages2014-09-23 07:22:43 26041 [Note] InnoDB: The InnoDB memory heap is disabled2014-09-23 07:22:43 26041 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins2014-09-23 07:22:43 26041 [Note] InnoDB: Compressed tables use zlib 1.2.32014-09-23 07:22:43 26041 [Note] InnoDB: Using Linux native AIO2014-09-23 07:22:43 26041 [Note] InnoDB: Using CPU crc32 instructions2014-09-23 07:22:43 26041 [Note] InnoDB: Initializing buffer pool, size = 128.0M2014-09-23 07:22:43 26041 [Note] InnoDB: Completed initialization of buffer pool2014-09-23 07:22:43 26041 [Note] InnoDB: The first specified data file ./ibdata1 did not exist: a new database to be created!2014-09-23 07:22:43 26041 [Note] InnoDB: Setting file ./ibdata1 size to 12 MB2014-09-23 07:22:43 26041 [Note] InnoDB: Database physically writes the file full: wait...2014-09-23 07:22:43 26041 [Note] InnoDB: Setting log file ./ib_logfile101 size to 48 MB2014-09-23 07:22:43 26041 [Note] InnoDB: Setting log file ./ib_logfile1 size to 48 MB2014-09-23 07:22:45 26041 [Note] InnoDB: Renaming log file ./ib_logfile101 to ./ib_logfile02014-09-23 07:22:45 26041 [Warning] InnoDB: New log files created, LSN=457812014-09-23 07:22:45 26041 [Note] InnoDB: Doublewrite buffer not found: creating new2014-09-23 07:22:45 26041 [Note] InnoDB: Doublewrite buffer created2014-09-23 07:22:45 26041 [Note] InnoDB: 128 rollback segment(s) are active.2014-09-23 07:22:45 26041 [Warning] InnoDB: Creating foreign key constraint system tables.2014-09-23 07:22:45 26041 [Note] InnoDB: Foreign key constraint system tables created2014-09-23 07:22:45 26041 [Note] InnoDB: Creating tablespace and datafile system tables.2014-09-23 07:22:45 26041 [Note] InnoDB: Tablespace and datafile system tables created.2014-09-23 07:22:45 26041 [Note] InnoDB: Waiting for purge to start2014-09-23 07:22:45 26041 [Note] InnoDB: 5.6.19 started; log sequence number 0A random root password has been set. You will find it in '/root/.mysql_secret'.2014-09-23 07:22:46 26041 [Note] Binlog end2014-09-23 07:22:46 26041 [Note] InnoDB: FTS optimize thread exiting.2014-09-23 07:22:46 26041 [Note] InnoDB: Starting shutdown...2014-09-23 07:22:48 26041 [Note] InnoDB: Shutdown completed; log sequence number 16259772014-09-23 07:22:48 0 [Warning] TIMESTAMP with implicit DEFAULT value is deprecated. Please use --explicit_defaults_for_timestamp server option (see documentation for more details).2014-09-23 07:22:48 26065 [Note] InnoDB: Using atomics to ref count buffer pool pages2014-09-23 07:22:48 26065 [Note] InnoDB: The InnoDB memory heap is disabled2014-09-23 07:22:48 26065 [Note] InnoDB: Mutexes and rw_locks use GCC atomic builtins2014-09-23 07:22:48 26065 [Note] InnoDB: Compressed tables use zlib 1.2.32014-09-23 07:22:48 26065 [Note] InnoDB: Using Linux native AIO2014-09-23 07:22:48 26065 [Note] InnoDB: Using CPU crc32 instructions2014-09-23 07:22:48 26065 [Note] InnoDB: Initializing buffer pool, size = 128.0M2014-09-23 07:22:48 26065 [Note] InnoDB: Completed initialization of buffer pool2014-09-23 07:22:48 26065 [Note] InnoDB: Highest supported file format is Barracuda.2014-09-23 07:22:48 26065 [Note] InnoDB: 128 rollback segment(s) are active.2014-09-23 07:22:48 26065 [Note] InnoDB: Waiting for purge to start2014-09-23 07:22:48 26065 [Note] InnoDB: 5.6.19 started; log sequence number 16259772014-09-23 07:22:48 26065 [Note] Binlog end2014-09-23 07:22:48 26065 [Note] InnoDB: FTS optimize thread exiting.2014-09-23 07:22:48 26065 [Note] InnoDB: Starting shutdown...2014-09-23 07:22:50 26065 [Note] InnoDB: Shutdown completed; log sequence number 1625987A RANDOM PASSWORD HAS BEEN SET FOR THE MySQL root USER !You will find that password in '/root/.mysql_secret'.You must change that password on your first connect,no other statement but 'SET PASSWORD' will be accepted.See the manual for the semantics of the 'password expired' flag.Also, the account for the anonymous user has been removed.In addition, you can run:  /usr/bin/mysql_secure_installationwhich will also give you the option of removing the test database.This is strongly recommended for production servers.See the manual for more instructions.Please report any problems at http://bugs.mysql.com/The latest information about MySQL is available on the web at  http://www.mysql.comSupport MySQL by buying support/licenses at http://shop.mysql.comNew default config file was created as /usr/my.cnf andwill be used by default by the server when you start it.You may edit this file to change server settings
```

最后一段中提示了重要信息，很多人因为不喜欢读英文，导致接下来不知道怎么操作！

![img](http://cdn.gvssimux.com/image-202010072211)



# CentOS7装mysql5.7(yum)

### 检查环境

**（可以只安装node01机器）**

**1、检查本地是否有MySQL相关程序，注意结果的返回值，下面删除的文件名要和屏幕显示的一致**

[root@node01 ~]# rpm -qa|grep mariadb*

**2、卸载系统自带的Mariadb相关文件**

[root@node01 ~]# rpm -e --nodeps mariadb-libs-5.5.65-1.el7.x86_64

![](http://cdn.gvssimux.com/20201027182434.png)



### 安装Yum Repo

由于CentOS 的yum源中没有mysql，需要到mysql的官网下载yum repo配置文件

也可通过本地上传，我这里是下载好的

下载命令：wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm

**然后进行repo的安装：**

```bash
# rpm -ivh /usr/software/mysql57-community-release-el7-9.noarch.rpm 

```

![](http://cdn.gvssimux.com/20201027184416.png)

执行完成后会在/etc/yum.repos.d/目录下生成两个repo文件mysql-community.repo mysql-community-source.repo



### 使用yum命令即可完成安装

**注意：必须进入到 /etc/yum.repos.d/目录后再执行以下脚本**

**1、安装命令：**

```bash
[root@node01 yum.repos.d]# yum install mysql-server
```

**2、启动msyql：**

> systemctl start mysqld #启动MySQL
>
> systemctl status mysqld #查看状态

![](http://cdn.gvssimux.com/20201027185134.png)

**3、获取安装时的临时密码（在第一次登录时就是用这个密码）：**

```bash
[root@node01 ~]# grep 'temporary password' /var/log/mysqld.log

```

**4、倘若没有获取临时密码，则**

4.1、删除原来安装过的mysql残留的数据

rm -rf /var/lib/mysql

4.2.再启动mysql

systemctl start mysqld #启动MySQL

### 配置

1. 登录mysql

    使用上一步查看到的密码登录

    ```shell
    mysql -u root -p
    ```

2. 使用ALTER重置root密码

    ```sql
    ALTER USER 'root'@'localhost' IDENTIFIED BY 'Gvssimux...1';
    ```

    

    （注意这里的密码可能有要求，需包含大小写、数字、符合、8位）

    ![image-20201007220844575](http://cdn.gvssimux.com/image-20201007220844575.png)

    重置完密码后，查看MySQL完整的初始密码规则

    ```sql
    SHOW VARIABLES LIKE 'validate_password%';
    ```

    ![image-20201007221114083](http://cdn.gvssimux.com/image-20201007221114083.png)

    密码的长度是由validate_password_length决定的,但是可以通过以下命令修改

    ```sql
    set global validate_password_length=4;
    ```

    validate_password_policy决定密码的验证策略,默认等级为MEDIUM(中等),可通过以下命令修改为LOW(低)

    ```sql
    set global validate_password_policy=0;
    ```

    **修改完成后密码就可以设置的很简单，比如1234之类的。**

    ```sql
    ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
    flush privileges;
    exit;
    ```

3. 添加密码及安全设置
    运行mysql_secure_installation脚本，该脚本执行一些与安全性相关的操作并设置MySQL根密码

```bash
[root@node01 ~]# mysql_secure_installation 
```

![image-20201008224503083](http://cdn.gvssimux.com/image-20201008224503083.png)

完成！密码为12345

### 还可以配置root的远程登陆

1. 登陆mysql

2. 以此执行以下sql

    ```sql
    use mysql;
    update user set host='%' where user='root';
    flush privileges;
    ```

注意：系统是否开放了3306端口，或者关闭防火墙

#  java安装

1. ### 上传 

    jdk-8u241-linux-x64.tar

2. ### 解压

    ```bash
    [root@node01 ~]# tar -xzvf /usr/software/jdk-8u241-linux-x64.tar.gz -C /usr/service/
    ```

3. ### 配置环境变量

    ```bash
    [root@node01 ~]# vim /etc/profile
    ```

4. ### 在最后一行输入

    ```shell
    export JAVA_HOME=/usr/service/jdk1.8.0_241
    export PATH=.:$JAVA_HOME/bin:$PATH
    export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
    ```

5. ### 立即生效环境变量

    ```bash
    [root@node01 ~]# source /etc/profile
    ```

    

6. ### 查看环境是否生效

    ```bash
    [root@node01 ~]# java -version
    ```

    ![image-20201008231219823](http://cdn.gvssimux.com/image-20201008231219823.png)

    

7. **将jdk1.8.0_241文件夹和/etc/profile复制到其他节点**

    在其他节点`mkdir /usr/service/`

```bash
[root@node01 ~]# scp /etc/profile node02:/etc/
[root@node01 ~]# scp /etc/profile node03:/etc/
[root@node01 ~]# scp -r /usr/service/jdk1.8.0_241/ node02:/usr/service/jdk1.8.0_241/
[root@node01 ~]# scp -r /usr/service/jdk1.8.0_241/ node03:/usr/service/jdk1.8.0_241/

```

然后到其他节点 `source /etc/profile` 下就可以了~



# 装Hadoop2.6.0.tar.gz

**解压hadoop**

类似jdk的方法将hadoop解压到/usr/local/module目录下

```bash
[root@node01 ~]# tar -zxvf /usr/software/hadoop-2.6.0.tar.gz -C /usr/service/
```





**修改几个配置文件，注意命令执行的位置**

1、修改hadoop-env.sh

在文件中找到export JAVA_HOME=${JAVA_HOME}行，注释掉这一行，在下面添加一行

`export JAVA_HOME=/usr/service/jdk1.8.0_241`

```bash
[root@node01 hadoop-2.6.0]# vim etc/hadoop/hadoop-env.sh 
```

2、修改core-site.xml

在解压的hadoop目录下创建子目录tmp

```bash
[root@node01 hadoop-2.6.0]# mkdir tmp
[root@node01 hadoop-2.6.0]# vim etc/hadoop/core-site.xml 
```

添加以下类容

```xml
<configuration>
    <!--指定集群的文件系统类型：分布式文件系统 -->
        <property>
                <name>fs.defaultFS</name>
                <value>hdfs://node01:9000</value>
        </property>
   	    <!-- 缓冲区大小，实际工作中根据服务器性能动态调节-->
        <property>
                <name>io.file.buffer.size</name>
                <value>131072</value>
        </property>
        <!-- 指定临时文件存储目录-->
        <property>
                <name>hadooop.tmp.dir</name>
                <value>/usr/service/hadoop-2.6.0/tmp</value>
        </property>
        <!-- 开启垃圾回收机制，删除掉的数据可以从垃圾桶回收，单位为分钟10080大约为7天可以不配  
        <property>
                <name>fs.trash.interval</name>
                <value>/usr/service/hadoop-2.6.0/tmp</value>
        </property>
    -->
</configuration>

```





3、修改hdfs-site.xml

在解压的hadoop目录下创建三个子目录hdfs,name,data，具体如下：

```bash
[root@node01 ~]# mkdir /usr/service/hadoop-2.6.0/hdfs
[root@node01 ~]# mkdir /usr/service/hadoop-2.6.0/hdfs/name
[root@node01 ~]# mkdir /usr/service/hadoop-2.6.0/hdfs/data
[root@node01 ~]# vim /usr/service/hadoop-2.6.0/etc/hadoop/hdfs-site.xml
```

```xml
<configuration>
        <property>
                <name>dfs.name.dir</name>
                <value>/usr/service/hadoop-2.6.0/hdfs/name</value>
        </property>
        <property>
                <name>dfs.data.dir</name>
                <value>/usr/service/hadoop-2.6.0/hdfs/data</value>
        </property>
    	<!-- 文件切片的副本位置-->
        <property>
                <name>dfs.replication</name>
                <value>3</value>
        </property>
        <property>
                <name>dfs.namenode.http-address</name>
                <value>node01:50070</value>
        </property>
        <property>
                <name>dfs.namenode.secondary.http-address</name>
                <value>node02:50090</value>
        </property>
    	<!-- 设置HDFS的文件权限-->
        <property>
                <name>dfs.permissions</name>
                <value>false</value>
        </property>
</configuration>

```





4、修改mapred-site.xml，需要先从模板文件复制一个文件出来。

```bash
[root@node01 ~]# cp /usr/service/hadoop-2.6.0/etc/hadoop/mapred-site.xml.template /usr/service/hadoop-2.6.0/etc/hadoop/mapred-site.xml
[root@node01 ~]# vim /usr/service/hadoop-2.6.0/etc/hadoop/mapred-site.xml
```

```xml
<configuration>
        <property>
                <name>mapred.job.tracker</name>
                <value>node01:49001</value>
        </property>
        <property>
                <name>mapreduce.framework.name</name>
                <value>yarn</value>
        </property>
</configuration>
```





5、修改yarn.site.xml

```bash
[root@node01 ~]# vim /usr/service/hadoop-2.6.0/etc/hadoop/yarn-site.xml
```

```xml
<configuration>
<!-- Site specific YARN configuration properties -->
        <property>
                <name>yarn.nodemanager.aux-services</name>
                <value>mapreduce_shuffle</value>
        </property>
        <property>
                <name>yarn.resourcemanager.hostname</name>
                <value>node01</value>
        </property>
        <property>
                <name>yarn.resourcemanager.webapp.address</name>
                <value>node01:8088</value>
        </property>
 
        <property>
                <name>yarn.resourcemanager.address</name>
                <value>node01:8032</value>
        </property>
        <property>
        <name>yarn.resourcemanager.scheduler.address</name>
                <value>node01:8030</value>
        </property>
        <property>
                <name>yarn.resourcemanager.resource-tracker.address</name>
                <value>node01:8031</value>
        </property>
        <property>
                <name>yarn.resourcemanager.admin.address</name>
                <value>node01:8033</value>
        </property>
        <property>
                <name>yarn.nodemanager.pmem-check-enabled</name>
                <value>false</value>
        </property>
        <property>
                <name>yarn.nodemanager.vmem-check-enabled</name>
                <value>false</value>
        </property>
</configuration>
```



6、修改slaves

```bash
[root@node01 ~]# vim /usr/service/hadoop-2.6.0/etc/hadoop/slaves 
```

node01            //可以不添加node01作为datanode,注意删掉里面的localhost

node02

node03

![](http://cdn.gvssimux.com/20201028145555.png)

**配置好文件好复制hadoop目录到node02和node03机器**

```bash
[root@node01 ~]# scp -r /usr/service/hadoop-2.6.0/ node02:/usr/service/
[root@node01 ~]# scp -r /usr/service/hadoop-2.6.0/ node03:/usr/service/

```



**配置hadoop环境变量**

[root@node01 ~]# vim /etc/profile

在/etc/profile最后面添加：

```
export HADOOP_HOME=/usr/service/hadoop-2.6.0

export PATH=$JAVA_HOME/bin$PATH:$HADOOP_HOME/bin
```

注意：文件中PATH环境变量只要在之前的基础上添加即可，不要再新起一行重新定义，后面的软件配置时也是一样

![image-20201010200849683](http://cdn.gvssimux.com/image-20201010200849683.png)

[root@node01 ~]# source /etc/profile

使用ssh登录到node01和node02做同样环境变量设置

测试hadoop环境变量是否有效

[hadoop@master ~]$ hadoop version



**格式化namenode**

在node01机器上初始化namenode**（注意只需要在node01机器做）**

[root@node01 ~]# $HADOOP_HOME/bin/hdfs  namenode  -format

![image-20201010201709184](http://cdn.gvssimux.com/image-20201010201709184.png)



**启动hadoop**

[root@node01 ~]# $HADOOP_HOME/sbin/start-all.sh

[root@node01 ~]#  jps

7029 DataNode

6794 NameNode

8282 Jps

7739 NodeManager

7564 ResourceManager

![image-20201010202743576](http://cdn.gvssimux.com/image-20201010202743576.png)



**测试是否可以进行文件操作**

[hadoop@master ~]$ $HADOOP_HOME/bin/hdfs dfs -ls /

[hadoop@master ~]$ $HADOOP_HOME/bin/hdfs dfs -mkdir /user

[hadoop@master ~]$ $HADOOP_HOME/bin/hdfs dfs -ls /

![image-20201010202847684](http://cdn.gvssimux.com/image-20201010202847684.png)



**查看安装的hadoop支持的压缩算法**

```bash
[root@node01 ~]# hadoop checknative
```

![](http://cdn.gvssimux.com/20201027171204.png)

# 未完待续~