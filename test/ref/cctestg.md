% A C++ example

This is supposed to illustrate the `ldoc` processor used on a C++
example.  Let's pretend that we're documenting a class!

## A very stupid class

{% highlight cc %}
/*
 * This is an ordinary block comment that should not be touched by
 * the ldoc processor.
 */
class Stupid {
public:
    Stupid(int x) : x(x) {}
    int let_us_get_x_as_wordily_as_possible() { return x; }
private:
    int x;
};

{% endhighlight %}

# Main routine

Ideally, we should lose the initial space-star-space after processing.

{% highlight cc %}
int main()
{
    return 0;
}
{% endhighlight %}


