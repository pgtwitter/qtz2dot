###qtz2dot
====
[Quartz Composer](http://en.wikipedia.org/wiki/Quartz_Composer)のCompositions(.qtz file)からパッチ間の関係を抜き出し，[DOT言語](http://ja.wikipedia.org/wiki/DOT言語)形式で出力します．

####使い方
----
    $ ./qtz2dot path/to/quartzcomposer.qtz > out.dot

グラフ画像を得るにはdot( [graphviz](http://www.graphviz.org) )などを利用します．

    $ dot -Tpng -o out.png out.dot

####dot(graphviz)のインストール
----
Homebrew

    $ brew install graphviz

MacPorts

    $ sudo port install graphviz

#### 利用条件
----
* いかなる種類の使用, 改造, 転載を行っても構いません.
* 改変, 部分的な利用したものはあなたのものになります. 公開するときはあなたの名前の元に公開してください.
* これによるいかなる損害も作者は責任を負わないものとします.
