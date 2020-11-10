---
title: 大数据比赛环境搭建
date: 2020-10-11 22:54:49
updated: 2020-11-1 23:54:49
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

有的图片不是我截的图，是老师发的环境搭建的文档的图片，我也不确定自己搭建的是否一定正确，所以有的图贴的是老师的，但最终环境是可以用的也没有什么问题。





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











# 安装hive（可以只安装node01机器）



1、解压hive并修改目录名称

```bash
[root@node01 ~]# tar -zxvf /usr/software/apache-hive-1.2.1-bin.tar.gz -C /usr/service/
[root@node01 ~]# mv /usr/service/apache-hive-1.2.1-bin/ /usr/service/hive-1.2.1/
```

2、修改环境变量

添加hive的主目录环境变量，修改后的/etc/profile文件末尾如下：

```
export JAVA_HOME=/usr/service/jdk1.8.0_241
export PATH=.:$JAVA_HOME/bin:$PATH
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export HADOOP_HOME=/usr/service/hadoop-2.6.0
export HIVE_HOME=/usr/service/hive-1.2.1
export PATH=$JAVA_HOME/bin$PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin
```

[root@node01 ~]# vim /etc/profile

![image-20201010204009850](http://cdn.gvssimux.com/image-20201010204009850.png)

[root@node01 ~]# source /etc/profile

在命令行下执行hive --version看是否可以正常执行

[root@node01 ~]# hive --version

![image-20201010204051918](http://cdn.gvssimux.com/image-20201010204051918.png)



3、修改配置文件

在hive目录下创建iotmp子目录供临时文件使用

```bash
[root@node01 ~]# mkdir /usr/service/hive-1.2.1/iotmp
```

按照模板hive-default.xml.template复制一个文件hive-site.xml

```bash
[root@node01 ~]# cp /usr/service/hive-1.2.1/conf/hive-default.xml.template /usr/service/hive-1.2.1/conf/hive-site.xml
[root@node01 ~]# vim /usr/service/hive-1.2.1/conf/hive-site.xml 
```

![image-20201010204253333](http://cdn.gvssimux.com/image-20201010204253333.png)

修改文件hive-site.xml的参数，注意不是重新写，而是找到文件中同样的name行，修改对应value行的值为文档中的内容。

 ```xml
<property>
	<name>javax.jdo.option.ConnectionURL</name>										<value>jdbc:mysql://node01:3306/hive?createDatabaseIfNotExist=true</value>
</property>
<property>
	<name>javax.jdo.option.ConnectionDriverName</name>
	<value>com.mysql.jdbc.Driver</value>
</property>
<property>
	<name>javax.jdo.option.ConnectionUserName</name>
	<value>hive</value>
</property>
<property>
	<name>javax.jdo.option.ConnectionPassword</name>
	<value>hive12345</value>
</property>
<property>
	<name>hive.querylog.location</name>
	<value>/usr/service/hive-1.2.1/iotmp</value>
</property>
<property>
	<name>hive.exec.local.scratchdir</name>
	<value>/usr/service/hive-1.2.1/iotmp</value>
</property>
<property>
	<name>hive.downloaded.resources.dir</name>
	<value>/usr/service/hive-1.2.1/iotmp</value>
</property>

 ```



4、修改hive-env.sh

从模板创建hive-env.sh文件

```bash
[root@node01 ~]# cp /usr/service/hive-1.2.1/conf/hive-env.sh.template /usr/service/hive-1.2.1/conf/hive-env.sh
[root@node01 ~]# vim /usr/service/hive-1.2.1/conf/hive-env.sh
```

在第23行左右输入下面的内容：

```sh
HADOOP_HOME=/usr/service/hadoop-2.6.0
JAVA_HOME=/usr/service/jdk1.8.0_241
HIVE_HOME=/usr/service/hive-1.2.1
```

![image-20201010210324818](http://cdn.gvssimux.com/image-20201010210324818.png)



5、复制mysql的驱动程序到hive/lib下面

![image-20201010211309850](http://cdn.gvssimux.com/image-20201010211309850.png)

```bash
[root@node01 ~]# cp /usr/software/mysql-connector-java-5.1.17-bin.jar /usr/service/hive-1.2.1/lib/
```



6、将hadoop的jline-0.9.94.jar的jar替换成hive的版本。

```bash
[root@node01 ~]# mv /usr/service/hadoop-2.6.0/share/hadoop/yarn/lib/jline-0.9.94.jar /usr/service/hadoop-2.6.0/share/hadoop/yarn/lib/jline-0.9.94.jar.bak
[root@node01 ~]# mv /usr/service/hive-1.2.1/lib/jline-2.12.jar /usr/service/hadoop-2.6.0/share/hadoop/yarn/lib/
```



7、创建mysql中hive的schema

先用root登录进入mysql，然后创建用户hive，设置密码，再创建数据库hive,让hive用户获得hive数据库的所有权限

```bash
[root@node01 ~]# mysql -u root -p
```

执行命令：

```sql
mysql>use mysql;

mysql>create user hive identified by 'hive12345';

mysql>create database hive;

mysql>grant all  on hive.* to 'hive'@'%'  with grant option;

mysql>flush privileges;

mysql>exit;
```

8、初始化hive

[root@node01 ~]# schematool -dbType mysql -initSchema

否则hive数据库内容为空。

![image-20201010214221597](http://cdn.gvssimux.com/image-20201010214221597.png)



9、输入命令hive进入hive执行环境。如下图（首先要hadoop启动）

>**启动hadoop**
>
>[root@node01 ~]# $HADOOP_HOME/sbin/start-all.sh
>
>[root@node01 ~]#  jps
>
>

执行jps确认hadoop是否启动（三台机器都有确认）

![image-20201029155822002](http://cdn.gvssimux.com/image-20201029155822002.png)

![image-20201029155835982](http://cdn.gvssimux.com/image-20201029155835982.png)





# 安装spark

## 安装scala（三台机器同样配置）

**1、解压scala**

```bash
[root@node01 ~]# unzip /usr/software/scala-2.11.0.zip -d /usr/service/
[root@node01 ~]# scp -r /usr/service/scala-2.11.0/ node02:/usr/service/
[root@node01 ~]# scp -r /usr/service/scala-2.11.0/ node03:/usr/service/

```

**2、编辑环境变量**

更改如下

```bash
export SCALA_HOME=/user/service/scala-2.11.0
PATH=$JAVA_HOME/bin$PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin:$PYTHON_HOME/bin:$SCALA_HOME/bin
```

最终效果

```bash
export JAVA_HOME=/usr/service/jdk1.8.0_241
export CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export HADOOP_HOME=/usr/service/hadoop-2.6.0
export HIVE_HOME=/usr/service/hive-1.2.1
export PYTHON_HOME=/root/training/Python-3.6.5
export SCALA_HOME=/user/service/scala-2.11.0
PATH=$JAVA_HOME/bin$PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin:$PYTHON_HOME/bin:$SCALA_HOME/bin
```

**其他节点也配置相同环境变量**

![image-20201029171731974](http://cdn.gvssimux.com/image-20201029171731974.png)

## 安装spark

**1、解压缩**

```bash
[root@node01 ~]# tar -zxvf /usr/software/spark-1.6.0-bin-hadoop2.6.tgz -C /usr/service/
```

**2、编辑环境变量**

```bash
export SPARK_HOME=/usr/service/spark-1.6.0-bin-hadoop2.6PATH=$JAVA_HOME/bin$PATH:$HADOOP_HOME/bin:$HIVE_HOME/bin:$PYTHON_HOME/bin:$SCALA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin
```

**3、修改spark配置文件(spark-env.sh、slaves)**

![image-20201029201614506](http://cdn.gvssimux.com/image-20201029201614506.png)

**spark-env.sh**

```bash
[root@node01 ~]# cp /usr/service/spark-1.6.0-bin-hadoop2.6/conf/spaark-env.sh.template /usr/service/spark-1.6.0-bin-hadoop2.6/conf/spark-env.sh
```

```bash
[root@node01 ~]# vim /usr/service/spark-1.6.0-bin-hadoop2.6/conf/spark-env.sh
```

```sh
export JAVA_HOME=/usr/service/jdk1.8.0_241
export HADOOP_HOME=/usr/service/hadoop-2.6.0
export HADOOP_CONF_DIR=/usr/service/hadoop-2.6.0/etc/hadoop
export SCALA_HOME=/user/service/scala-2.11.0
export SPARK_MASTER_IP=node01
```

![image-20201029202422822](http://cdn.gvssimux.com/image-20201029202422822.png)

>node01主节点

**配置slaves**

进入指定目录 /usr/service/spark-1.6.0-bin-hadoop2.6/conf/

```bash
# mv slaves.template slaves
```

```bash
# vim slaves
```

删除原来的localhost

添加从节点

![image-20201029202833089](http://cdn.gvssimux.com/image-20201029202833089.png)



## 拷贝spark文件到从节点

```bash
# scp -r /usr/service/spark-1.6.0-bin-hadoop2.6/ node02:/usr/service/
# scp -r /usr/service/spark-1.6.0-bin-hadoop2.6/ node03:/usr/service/

```



## 测试执行一个程序

**启动hadoop和spark**

```bash
启动全部
# $HADOOP_HOME/sbin/start-all.sh
启动...
# $HADOOP_HOME/sbin/start-yarn.sh
启动...
# $HADOOP_HOME/sbin/start-dfs.sh
```

![img](http://cdn.gvssimux.com/clip_image006.jpg)

```bash
# $SPARK_HOME/sbin/start-all.sh
# jps
```

![img](file:///C:/Users/单子健/AppData/Local/Temp/msohtmlclip1/01/clip_image008.jpg)

测试spark是否可以正常执行

```bash
# $SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://node01:7077 $SPARK_HOME/lib/spark-examples-1.6.0-hadoop2.6.0.jar
```

![img](http://cdn.gvssimux.com/clip_image010.jpg)

![img](http://cdn.gvssimux.com/clip_image012.jpg)

最终在windows下的浏览器里面输入

http://[node01的ip]:50070

![image-20201029211136461](C:\Users\单子健\AppData\Roaming\Typora\typora-user-images\image-20201029211136461.png)

在浏览器里面输入

http://[node01的ip]:8080

![image-20201029211113890](http://cdn.gvssimux.com/image-20201029211113890.png)

# 安装python3.6.5.tgz(未整理)

https://blog.csdn.net/L_15156024189/article/details/84831045

本文基于如下Linux系统版本：

![img](http://cdn.gvssimux.com/20181205135253731.png)

1、默认情况下，Linux会自带安装Python，可以运行python --version命令查看，如图：

![img](http://cdn.gvssimux.com/20181205114121673.png)

我们看到Linux中已经自带了Python2.7.5。再次运行python命令后就可以使用python命令窗口了（Ctrl+D退出python命令窗口）。

 

2、查看Linux默认安装的Python位置

![img](http://cdn.gvssimux.com/20181205114638860.png)

看到/usr/bin/python和/usr/bin/python2都是软链接，/usr/bin/python指向/usr/bin/python2，而/usr/bin/python2最终又指向/usr/bin/python2.7。所以运行python/python2/python2.7是一样的，如图：

![img](http://cdn.gvssimux.com/watermV0L0x)

3、安装python3

（1）登录https://www.python.org/downloads/source/，找到对应版本（我们以Python 3.6.5为例）如图：

![img](http://cdn.gvssimux.com/20181205140734407.png)

下载[Python-3.6.5.tgz](https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz)

（2）文件上传

将文件上传到Linux系统的某个目录下，根据自己情况上传，本例上传到了/root/tools目录下，如图：

![img](http://cdn.gvssimux.com/20181205141052576.png)

（3）解压

执行tar -zxvf Python-3.6.5.tgz命令，将文件解压到当前目录，如图：

![img](http://cdn.gvssimux.com/20181205131636273.png)

（4）准备编译环境

执行如下命令：

```bash
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gcc make
```

安装python需要的依赖。成功后（Complete!），如图：

![img](http://cdn.gvssimux.com/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHsize_16,color_FFFFFF,t_70)

如果python是3.7版本，还需要安装libffi-devel。整个编译过程1分钟左右。

如果遇到如下问题：

```
Loaded plugins: fastestmirror
 00:00:00   
Could not retrieve mirrorlist http://mirrorlist.centos.org/?release=7&arch=x86_64&repo=os&infra=stock error was
14: curl#6 - "Could not resolve host: mirrorlist.centos.org; Unknown error"


 One of the configured repositories failed (Unknown),
 and yum doesn't have enough cached data to continue. At this point the only
 safe thing yum can do is fail. There are a few ways to work "fix" this:

   \1. Contact the upstream for the repository and get them to fix the problem.

   \2. Reconfigure the baseurl/etc. for the repository, to point to a working
    upstream. This is most often useful if you are using a newer
    distribution release than is supported by the repository (and the
    packages for the previous distribution release still work).
```

>一般是不能连接外网，每个情况不一样，我的解决方案，执行如下命令
>
>vi /etc/sysconfig/network-scripts/ifcfg-ens33
>
>每个人的Linux中ifcfg-ens33名称不一定完全一样。我的配置如下：
>
>TYPE=Ethernet
>
>PROXY_METHOD=none
>
>BROWSER_ONLY=no
>
>\#BOOTPROTO=none
>
>DEFROUTE=yes
>
>IPV4_FAILURE_FATAL=no
>
>IPV6INIT=yes
>
>IPV6_AUTOCONF=yes
>
>IPV6_DEFROUTE=yes
>
>IPV6_FAILURE_FATAL=no
>
>IPV6_ADDR_GEN_MODE=stable-privacy
>
>NAME=ens33
>
>UUID=296fb7a9-961a-46ea-bc1b-678cca49d40a
>
>DEVICE=ens33
>
>ONBOOT=yes
>
>IPADDR=192.168.189.111
>
>GATEWAY=192.168.189.2
>
>NETMASK=255.255.255.0
>
>DNS1=8.8.8.8
>
>PREFIX=24
>
>IPV6_PRIVACY=no
>
>配置好保存，执行service network restart重启网络服务。然后再重新执行上面的yum安装命令即可。



（5）编译安装

执行cd Python-3.6.5进入解压后的Python-3.6.5目录下，依次执行如下三个命令：

```
其中--prefix是Python的安装目录!!! 安装成功后，如图：
./configure --prefix=/root/training/Python-3.6.5

make

make install
```

 ![img](http://cdn.gvssimux.com/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L0xfMTUxNTYwMjQxODk=,size_16,color_FFFFFF,t_70)

我们看到，同时安装了setuptools和pip工具。进入到/root/training/Python-3.6.5安装目录，如图：

![img](http://cdn.gvssimux.com/20181205132418781.png)

（6）创建软链接

还记得开始，Linux已经安装了python2.7.5，这里我们不能将它删除，如果删除，系统可能会出现问题。我们只需要按照与Python2.7.5相同的方式为Python3.6.5创建一个软链接即可，我们把软链接放到/usr/local/bin目录下，如图：

```bash
ln -s /usr/service/Python3/bin/python3 /usr/bin/python3
ln -s /usr/service/Python3/bin/pip3 /usr/bin/pip3
```

![img](http://cdn.gvssimux.com/20181205134913739.png)

 此时，我们在命令窗口运行python3，如图：

![img](http://cdn.gvssimux.com/20181205134959464.png)

 安装成功！当然此时还是可以使用Python2.7.5版本（运行python/python2/python2.7即可）。

 

（7）配置环境变量

配置环境变量主要是能快速使用pip3安装命令。

执行 vi ~/.bash_profile，打开配置文件，添加如下配置：

```
#配置python

export PYTHON_HOME=/root/training/Python-3.6.5

export PATH=$PYTHON_HOME/bin:$PATH
```

保存退出（:wq），执行source ~/.bash_profile命令使配置生效。执行echo命令，查看是否配置成功，如图：

```bash
# echo $PYTHON_HOME
```

![img](http://cdn.gvssimux.com/20181205143055635.png)







#  使用pip3安装pip3 tensorflow 

https://blog.csdn.net/abc781cba/article/details/85229956

## setuptools

下载：

```bash
wget https://pypi.python.org/packages/6f/10/5398a054e63ce97921913052fde13ebf332a3a4104c50c4d7be9c465930e/setuptools-26.1.1.zip#md5=f81d3cc109b57b715d46d971737336db
```

解压、安装：

```bash
unzip /usr/software/setuptools-26.1.1.zip -d /usr/service/
cd setuptools-26.1.1
python setup.py install
```

## pip

下载：

```
wget --no-check-certificate https://github.com/pypa/pip/archive/1.5.5.tar.gz
```

解压、安装：

```
tar -zvxf 1.5.5.tar.gz
cd pip-1.5.5
python setup.py install
```

## pip3

下载：

```bash
wget --no-check-certificate https://pypi.python.org/packages/source/p/pip/pip-8.0.2.tar.gz#md5=3a73c4188f8dbad6a1e6f6d44d117eeb
```

解压及安装：

```bash
tar -zxvf pip-8.0.2.tar.gz -C /user/service
cd pip-8.0.2 
python setup.py build 
python setup.py install
```

升级pip：

```bash
pip install --upgrade pip
```

4 安装python2.7、python3对应的tensorflow

```bash
pip install tensorflow
pip3 install tensorflow 
```

## pip还源

执行了上述的安装可能会出现下载的特别慢的情况，为了解决这个问题，需要修改pip的下载源为国内的镜像库，常用的镜像库有阿里、豆瓣和清华等
具体修改步骤如下：

1、找到系统下的pip.conf 文件（若找不到，可以新建，放在/root/.pip/下），并添加如下内容：

```
[global]
index-url=http://pypi.douban.com/simple
extra-index-url=http://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=
   pypi.douban.com
   mirrors.aliyun.com
```

以上保存后，每次pip安装都会先从index-url中查找，若没有再从extra-index-url中查找。

如果不想修改配置文件，可以手动在命令行中指定镜像库：

```bash
pip --default-timeout=1000 install tensorflow==1.15.0 -i https://pypi.douban.com/simple
或者
pip install tensorflow==1.15.0 -i https://pypi.douban.com/simple
```



# 相关命令

```bash
启动全部
# $HADOOP_HOME/sbin/start-all.sh
启动...
# $HADOOP_HOME/sbin/start-yarn.sh
启动...
# $HADOOP_HOME/sbin/start-dfs.sh

# $SPARK_HOME/sbin/start-all.sh
# jps

测试spark是否可以正常执行
# $SPARK_HOME/bin/spark-submit --class org.apache.spark.examples.SparkPi --master spark://node01:7077 $SPARK_HOME/lib/spark-examples-1.6.0-hadoop2.6.0.jar

重新格式化 namenode（测试虚拟环境，生产环境严禁执行此操作）
# hadoop namenode -format

启动 hdfs
[root@flink sbin]# ./start-all.sh 

```



# 完~