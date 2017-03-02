---
layout: post
title:  "Welcome to my Jekyll Blog"
date:   2017-02-26 12:39:43 +0000
categories: jekyll update
---

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.ext` and includes the necessary front matter. Take a look at the source for this post to get an idea about how it works.


## Videos

{% ted ken_robinson_says_schools_kill_creativity 640 360 %}

{% vimeo 22439234 640 360 %}

{% youtube 9bZkp7q19f0 640 360 %}

{% ustream 6540154 640 360 %}

## Math Blocks
inline \\(a^2 + b^2 = c^2\\) or paragrapth format $$a^2 + b^2 = c^2$$

some complex examples

\\[ \mathbf{X} = \mathbf{Z} \mathbf{P^\mathsf{T}} \\]

$$ \mathbf{X}\_{n,p} = \mathbf{A}\_{n,k} \mathbf{B}\_{k,p} $$


## Code Blocks
Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

## And Graphs

{% digraph some digraph title %}
    rankdir=LR;
    size="8"
    node [shape = doublecircle]; LR_0 LR_3 LR_4 LR_8;
    node [shape = circle];
    LR_0 -> LR_2 [ label = "SS(B)" ];
    LR_0 -> LR_1 [ label = "SS(S)" ];
    LR_1 -> LR_3 [ label = "S($end)" ];
    LR_2 -> LR_6 [ label = "SS(b)" ];
    LR_2 -> LR_5 [ label = "SS(a)" ];
    LR_2 -> LR_4 [ label = "S(A)" ];
    LR_5 -> LR_7 [ label = "S(b)" ];
    LR_5 -> LR_5 [ label = "S(a)" ];
    LR_6 -> LR_6 [ label = "S(b)" ];
    LR_6 -> LR_5 [ label = "S(a)" ];
    LR_7 -> LR_8 [ label = "S(b)" ];
    LR_7 -> LR_5 [ label = "S(a)" ];
    LR_8 -> LR_6 [ label = "S(b)" ];
    LR_8 -> LR_5 [ label = "S(a)" ];
    overlap=false;
    fontsize=10;
{% enddigraph %}

## Ditta graphs
This needs Java but its cool!

{% ditaa %}
/----+  DAAP /-----+-----+ Audio  /--------+
| PC |<------| RPi | MPD |------->| Stereo |
+----+       +-----+-----+        +--------+
   |                 ^ ^
   |     ncmpcpp     | | mpdroid /---------+
   +--------=--------+ +----=----| Nexus S |
                                 +---------+
{% endditaa %}

More info : [plugin docs](https://github.com/kui/jekyll-graphviz)

## More info
Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs](http://jekyllrb.com/docs/home)
[jekyll-gh](https://github.com/jekyll/jekyll)
[jekyll-talk](https://talk.jekyllrb.com/)
