# Hexo快速、简洁且高效的博客框架

大三开学，在把部门和学校的事情忙的差不多后，暂时停滞了对JavaWeb的学习，

## Hexo安装

**我这里使用的是阿里云的学生机，系统是CentOS7**

### 安装前提

安装 Hexo 相当简单，只需要先安装下列应用程序即可：

- [Node.js](http://nodejs.cn/) (Node.js 版本需不低于 10.13，建议使用 Node.js 12.0 及以上版本)
- [Git](http://git-scm.com/)

如果您的电脑中已经安装上述必备程序，那么恭喜您！你可以直接前往安装 Hexo步骤。

如果您的电脑中尚未安装所需要的程序，请根据以下安装指示完成安装。

#### 安装Git

```bash
$ sudo yum install git-core
```



#### 安装Node.js





#### 安装 Hexo

1. 新建个目录hexo

```bash
$ mkdir /hexo
```

2. 进入建好的hexo中执行以下操作

    

```bash
$ npm install -g hexo-cli
$ hexo init /hexo
$ cd /hexo
$ npm install
```



#### 安装 Nginx

1. 服务器环境搭建

    我们需要nginx作为我们的服务器，所以我们首先要安装nginx。可以使用yum命令直接进行安装。
    安装执行命令如下

    ```bash
    yum install -y nginx
    ```

    启动服务器：

    ```bash
    systemctl start nginx
    systemctl enable nginx
    ```

    我们要记住的是/etc/nginx/是nginx默认的配置路径，一会要用到。

    

1. 配置服务器路由

    安装并启动服务器后，我们就完成了第一步，现在我们可以尝试使用自己的电脑去访问服务器的公网IP。我们可以惊喜地发现，公网IP可以打开一个nginx的默认网页。这样，我们就成功了第一步。

    

1. 修改配置文件

    但是我们实际上是想要让这个地址指向我们的博客，而不是nginx的默认网址，这就需要我们去配置**nginx的配置文件**。阿里云默认的库下载的是fedora版本的nginx ，配置文件为**etc/nginx/** 下的 **nginx.conf** 。

    打开/etc/nginx/目录下的nginx.conf文件

    注释掉原来的root，添加博客地址
    

`vim /etc/nginx/nginx.conf`

![image-20201015233104198](D:\笔记\hexo\image\image-20201015230221942.png)


​    
    保存并退出
       
    `:wq`

主题
[stun](https://github.com/liuyib/hexo-theme-stun)

[Volantis](https://github.com/xaoxuu/hexo-theme-volantis)



```
navbar:
  logo: # choose [img] or [icon + title]
    img:
    icon:
    title:
  menu:
    # The following can be written in `blog/source/_data/menu.yml`
    - name: 博客
      icon: fas fa-rss
      url: /
    - name: 分类
      icon: fas fa-folder-open
      url: categories/
    - name: 标签
      icon: fas fa-tags
      url: tags/
    - name: 归档
      icon: fas fa-archive
      url: archives/
    - name: 友链
      icon: fas fa-link
      url: friends/
    - name: 关于
      icon: fas fa-info-circle
      url: about/
  search: 搜索   # Search bar placeholder
```





## 生成的index.html为空

![im8](http://cdn.gvssimux.com/20201016090216.png)

![](http://cdn.gvssimux.com/20201016090606.png)

![](http://cdn.gvssimux.com/20201016090713.png)

```bash
[root@iZm7vqs5ssz3w4Z hexo]# hexo clean
INFO  Validating config
INFO  Deleted database.
INFO  Deleted public folder.
[root@iZm7vqs5ssz3w4Z hexo]# hexo g
INFO  Validating config
INFO  Start processing
INFO  Files loaded in 4.77 s
ERROR TypeError: /hexo/themes/stun/layout/_third-party/search/localsearch.pug:4
    2|   function initSearch() {
    3|     var isXML = true;
  > 4|     var search_path = '!{ config.search.path }';
    5| 
    6|     if (!search_path) {
    7|       search_path = 'search.xml';

Cannot read property 'path' of undefined
    at eval (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:2671:60)
    at template (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:5894:72)
    at _View._compiled (/hexo/node_modules/hexo/lib/theme/view.js:136:50)
    at _View.render (/hexo/node_modules/hexo/lib/theme/view.js:39:17)
    at /hexo/node_modules/hexo/lib/hexo/index.js:64:21
    at tryCatcher (/hexo/node_modules/bluebird/js/release/util.js:16:23)
    at /hexo/node_modules/bluebird/js/release/method.js:15:34
    at RouteStream._read (/hexo/node_modules/hexo/lib/hexo/router.js:47:5)
    at RouteStream.Readable.read (_stream_readable.js:479:10)
    at resume_ (_stream_readable.js:966:12)
    at processTicksAndRejections (internal/process/task_queues.js:80:21) {
  path: '/hexo/themes/stun/layout/_third-party/search/localsearch.pug'
}
ERROR TypeError: /hexo/themes/stun/layout/_third-party/search/localsearch.pug:4
    2|   function initSearch() {
    3|     var isXML = true;
  > 4|     var search_path = '!{ config.search.path }';
    5| 
    6|     if (!search_path) {
    7|       search_path = 'search.xml';

Cannot read property 'path' of undefined
    at eval (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:2582:60)
    at template (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:5805:72)
    at _View._compiled (/hexo/node_modules/hexo/lib/theme/view.js:136:50)
    at _View.render (/hexo/node_modules/hexo/lib/theme/view.js:39:17)
    at /hexo/node_modules/hexo/lib/hexo/index.js:64:21
    at tryCatcher (/hexo/node_modules/bluebird/js/release/util.js:16:23)
    at /hexo/node_modules/bluebird/js/release/method.js:15:34
    at RouteStream._read (/hexo/node_modules/hexo/lib/hexo/router.js:47:5)
    at RouteStream.Readable.read (_stream_readable.js:479:10)
    at resume_ (_stream_readable.js:966:12)
    at processTicksAndRejections (internal/process/task_queues.js:80:21) {
  path: '/hexo/themes/stun/layout/_third-party/search/localsearch.pug'
}
ERROR TypeError: /hexo/themes/stun/layout/_third-party/search/localsearch.pug:4
    2|   function initSearch() {
    3|     var isXML = true;
  > 4|     var search_path = '!{ config.search.path }';
    5| 
    6|     if (!search_path) {
    7|       search_path = 'search.xml';

Cannot read property 'path' of undefined
    at eval (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:2582:60)
    at template (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:5805:72)
    at _View._compiled (/hexo/node_modules/hexo/lib/theme/view.js:136:50)
    at _View.render (/hexo/node_modules/hexo/lib/theme/view.js:39:17)
    at /hexo/node_modules/hexo/lib/hexo/index.js:64:21
    at tryCatcher (/hexo/node_modules/bluebird/js/release/util.js:16:23)
    at /hexo/node_modules/bluebird/js/release/method.js:15:34
    at RouteStream._read (/hexo/node_modules/hexo/lib/hexo/router.js:47:5)
    at RouteStream.Readable.read (_stream_readable.js:479:10)
    at resume_ (_stream_readable.js:966:12)
    at processTicksAndRejections (internal/process/task_queues.js:80:21) {
  path: '/hexo/themes/stun/layout/_third-party/search/localsearch.pug'
}
ERROR TypeError: /hexo/themes/stun/layout/_third-party/search/localsearch.pug:4
    2|   function initSearch() {
    3|     var isXML = true;
  > 4|     var search_path = '!{ config.search.path }';
    5| 
    6|     if (!search_path) {
    7|       search_path = 'search.xml';

Cannot read property 'path' of undefined
    at eval (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:2582:60)
    at template (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:5805:72)
    at _View._compiled (/hexo/node_modules/hexo/lib/theme/view.js:136:50)
    at _View.render (/hexo/node_modules/hexo/lib/theme/view.js:39:17)
    at /hexo/node_modules/hexo/lib/hexo/index.js:64:21
    at tryCatcher (/hexo/node_modules/bluebird/js/release/util.js:16:23)
    at /hexo/node_modules/bluebird/js/release/method.js:15:34
    at RouteStream._read (/hexo/node_modules/hexo/lib/hexo/router.js:47:5)
    at RouteStream.Readable.read (_stream_readable.js:479:10)
    at resume_ (_stream_readable.js:966:12)
    at processTicksAndRejections (internal/process/task_queues.js:80:21) {
  path: '/hexo/themes/stun/layout/_third-party/search/localsearch.pug'
}
ERROR TypeError: /hexo/themes/stun/layout/_third-party/search/localsearch.pug:4
    2|   function initSearch() {
    3|     var isXML = true;
  > 4|     var search_path = '!{ config.search.path }';
    5| 
    6|     if (!search_path) {
    7|       search_path = 'search.xml';

Cannot read property 'path' of undefined
    at eval (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:2567:60)
    at template (eval at wrap (/hexo/node_modules/pug-runtime/wrap.js:6:10), <anonymous>:5790:72)
    at _View._compiled (/hexo/node_modules/hexo/lib/theme/view.js:136:50)
    at _View.render (/hexo/node_modules/hexo/lib/theme/view.js:39:17)
    at /hexo/node_modules/hexo/lib/hexo/index.js:64:21
    at tryCatcher (/hexo/node_modules/bluebird/js/release/util.js:16:23)
    at /hexo/node_modules/bluebird/js/release/method.js:15:34
    at RouteStream._read (/hexo/node_modules/hexo/lib/hexo/router.js:47:5)
    at RouteStream.Readable.read (_stream_readable.js:479:10)
    at resume_ (_stream_readable.js:966:12)
    at processTicksAndRejections (internal/process/task_queues.js:80:21) {
  path: '/hexo/themes/stun/layout/_third-party/search/localsearch.pug'
}
INFO  Generated: archives/index.html
INFO  Generated: archives/2020/index.html
INFO  Generated: archives/2020/10/index.html
(node:1452) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(Use `node --trace-warnings ...` to show where the warning was created)
(node:1452) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:1452) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
(node:1452) Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
(node:1452) Warning: Accessing non-existent property 'column' of module exports inside circular dependency
(node:1452) Warning: Accessing non-existent property 'filename' of module exports inside circular dependency
INFO  Generated: index.html
INFO  Generated: images/cc-by-nc-nd.svg
INFO  Generated: images/icons/favicon-16x16.png
INFO  Generated: images/cc-by-nc-sa.svg
INFO  Generated: images/cc-by-nc.svg
INFO  Generated: images/cc-by-nd.svg
INFO  Generated: images/cc-by-sa.svg
INFO  Generated: images/cc-by.svg
INFO  Generated: images/loading.svg
INFO  Generated: images/icons/favicon-32x32.png
INFO  Generated: images/icons/stun-logo.svg
INFO  Generated: images/algolia.svg
INFO  Generated: js/header.js
INFO  Generated: js/scroll.js
INFO  Generated: js/sidebar.js
INFO  Generated: js/stun-boot.js
INFO  Generated: 2020/10/15/hello-world/index.html
INFO  Generated: js/utils.js
INFO  Generated: css/index.css
INFO  22 files generated in 1.41 s

```

