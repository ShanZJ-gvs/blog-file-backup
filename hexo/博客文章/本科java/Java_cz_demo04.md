---
title: 读取下列文本数据，计算每个单词出现多少次
date: 2020-10-19
updated: 2020-10-19
comments: false
excerpt: （本科Java核心编程课）老师布置的一份课后作业
categories:
  - Java
tags:
  - Java
---
（本科Java核心编程课）老师布置的一份课后作业

读取下列文本数据，以空格或者“,”“.”作为单词分隔符统计出现次数最多的10个单词，以及这些单词现了多少次


>This article is about the men's football club. For the women's football club, see Chelsea FC. Women. For other uses, see Chelsea . Chelsea Chelsea FC.svg Full name    Chelsea Football Club Nickname(s) The Blues, The Pensioners Short name   CFC Founded  10 March 1905. 113 years ago Ground Stamford BridgeCapacity Owner    Roman Abramovich Chairman    Bruce Buck Head coach    Maurizio Sarri League    Premier League 2017–18   Premier League, 5th of 20 Website    Club website Home colours Away colours Current season
>
>Chelsea Football Club is a professional football club in London, England, that competes in the Premier League. Founded in 1905, the club's home ground since then has been Stamford Bridge
>
> Chelsea won the First Division title in 1955, followed by various cup competitions between 1965 and 1971. The past two decades have seen sustained success, with the club winning 23 trophies since 1997. In total, the club has won 28 major trophies; six titles, eight FA Cups, five League Cups and four FA Community Shields, one UEFA Champions League, two UEFA Cup Winners' Cups, one UEFA Europa League and one UEFA Super Cup.
>
>Chelsea's regular kit colours are royal blue shirts and shorts with white socks. The club's crest has been changed several times in attempts to re-brand the club and modernise its image. The current crest, featuring a ceremonial lion rampant regardant holding a staff, is a modification of the one introduced in the early 1950s. The club have the sixth-highest average all-time attendance in English football, and for the 2017–18 season at 41,280. Since 2003, Chelsea have been owned by Russian billionaire Roman Abramovich. In 2018, they were ranked by Forbes magazine as the seventh most valuable football club in the world, at £1.54 billion ($2.06 billion) and in the 2016–17 season it was the eighth highest-earning football club in the world, having earned €428 million

## 编写类

### ReadFile.java



```java
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class ReadFile {
    //读取文件
    public static String readFile(String fileName){
        File file = new File(fileName);
        BufferedReader reader = null;
        StringBuffer sbf = new StringBuffer();
        try {
            reader = new BufferedReader(new FileReader(file));
            String tempStr;
            while ((tempStr = reader.readLine()) != null) {
                sbf.append(tempStr);
            }
            reader.close();
            return sbf.toString();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        }
        return sbf.toString();
    }
}
```



### main.java

**main.java做为主函数，里面有静态方法countWord(String[] str)，返回一个处理过的HashMap<String, Integer>其中key是单词，value是单词出现的次数**

```java
import java.util.HashMap;
import java.util.Set;

public class mian {
    public static void main(String[] args) {
        //读取文件
        String s = ReadFile.readFile("要读取的文件：文件名.txt");
        //拆分字符串，如何拆分可以根据自己喜欢来，这里是以 “ ,.空格;()回车换行 ” 进行拆分的
        String[] str = s.split(",|\\.| |;|\\(|\\)|\r|\n");
        //执行方法返回HashMap
        System.out.println(countWord(str));
    }

    public static HashMap<String, Integer> countWord(String[] str){
        //将str压缩，使得单词不会重复
        HashMap<String, Integer> wordsHashMap = new HashMap<String, Integer>();
        for (int i = 0; i < str.length; i++) {
            wordsHashMap.put(str[i],1);
        }

        //取出压缩过的单词
        Set<String> keys = wordsHashMap.keySet();

        //new一个新的HashMap2去接受处理过的单词
        HashMap<String, Integer> wordsHashMap2 = new HashMap<String, Integer>();
        int count = 0;
        for (int i = 0; i < wordsHashMap.size(); i++) {
            count = 0;
            for (int j = 0;j< str.length;j++){
                if (str[j].equals(keys.toArray()[i])){
                    count++;
                }
            }
            wordsHashMap2.put((String) keys.toArray()[i],count);
        }

        //查看过程中集合的长度以及内容
        //System.out.println("String[] str"+Arrays.toString(str));
        //System.out.println("Set<String> keys"+keys);
        //System.out.println("String[] str "+str.length);
        //System.out.println("keys.size() "+keys.size());
        //System.out.println("wordsHashMap.size() "+wordsHashMap.size());
        //System.out.println("wordsHashMap2.size() "+wordsHashMap2.size());

        return wordsHashMap2;
    }

}

```

## 结果

![](http://cdn.gvssimux.com/20201019204729.png)

## 思路

1. 先读取文件为一个字符串s，再讲字符串拆分为一个数组str
2. 数组str中有重复的字符串，使用countWord(String[] str) 的第一部分压缩为一个wordsHashMap，里面的key为字符串，且字符串不重复
3. 取出压缩后的wordsHashMap的key为一个Set集合keys，把Set集合keys里的字符串重新与之前的数组str进行一一比较，得出出现次数count，并生成wordsHashMap2，key为唯一字符串，value为出现次数。
4. 返回这个处理好的HashMap(wordsHashMap2)就可以了。