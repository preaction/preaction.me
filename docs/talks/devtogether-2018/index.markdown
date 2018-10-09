---
title: What I Wish I Learned: Docs
layout: reveal.html
data:
    topic_url: preaction.me/docs
---

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title
<section>
<section>
<h1>Documentation</h1>
<aside class="notes">Since this talk is about documentation...</aside>
</section>
<section>
<h1>Code</h1>
<aside class="notes">Let's start by looking at some code</aside>
</section>
<section>
<pre>

    <span class="fragment highlight-current-blue" data-fragment-index="1">float y = number;</span>
    <span class="fragment highlight-current-blue" data-fragment-index="2">long i = *(long*) &y;</span>
    <span class="fragment highlight-current-blue" data-fragment-index="4">i = 0x5f3759df -</span> <span class="fragment highlight-current-blue" data-fragment-index="3">( i >> 1 )</span>;
    <span class="fragment highlight-current-blue" data-fragment-index="5">y = *(float*) &i;</span>
    <span class="fragment highlight-current-blue" data-fragment-index="6">y = y * ( 1.5F - ( ( number * 0.5F ) * y * y ) );</span>

 </pre>
<aside class="notes">Alright, what does this code do? Looks like we have
a floating-point number. Then we cast the bits to a long integer, do
some bit-shifting, subtract some magic number, cast it back to
a float, and do some more math on it. Well, I still don't know what this
code does, so let's back up a bit.</aside>
</section>
<section>
<pre>
float reciprocal_sqrt( float number ) {
    float y = number;
    long i = *(long*) &y;
    i = 0x5f3759df - ( i >> 1 );
    y = *(float*) &i;
    y = y * ( 1.5F - ( ( number * 0.5F ) * y * y ) );
    return y;
}</pre>
<aside class="notes">Okay, now that our function has a name, I know that
this function is calculating the reciprocal of the square root of
a number. This is hugely important in video games. However, if I were
to see this code, one of two things would happen:</aside>
</section>
<section>
<h3>1. It's too complex to understand, it must be</h3>
<h1>important</h1>
</section>
<section>
<h3>2. It's too complex to understand, it must be</h3>
<h1>replaced</h1>
</section>
<section>
<pre>#include &lt;cmath&gt;
float reciprocal_sqrt( float number ) {
    return 1 / sqrt( number );
}





</pre>
<aside class="notes">With this. If every language has a standard way to
create a square root, why would I have that big complicated mess?</aside>
</section>
<section>
<pre> 
float reciprocal_sqrt( float number ) {
    float y = number;
    long i = *(long*) &y;
    i = 0x5f3759df - ( i >> 1 );
    y = *(float*) &i;
    y = y * ( 1.5F - ( ( number * 0.5F ) * y * y ) );
    return y;
}</pre>
<aside class="notes">So, the answer to that is pretty fascinating: This
function uses a bit-shifting hack to very quickly calculate an approximate
reciprocal square root: Division is slow, and precisely calculating a square root is
slow, and 3d games need to do this a lot. This code was made famous by Quake 3
Arena, though it existed long before that.</aside>
</section>
<section>
<pre>#include &lt;cmath&gt;
float reciprocal_sqrt( float number ) {
    return 1 / sqrt( number );
}





</pre>
<aside class="notes">But now I've replaced it with cleaner code and as
a result broken my game.</aside>
</section>
</section>
<section>
<h2>There must be</h2>
<img src="betterway.gif" style="height: 50vh" alt="GIF of someone trying
to cut bread with a wedge of wood normally used to hold doors open">
<h2>a better way</h2>
<aside class="notes">There must be a way to stop this from happening.</aside>
</section>
<section>
<section>
<h1>Documentation</h1>
<aside class="notes">And that way is documentation</aside>
</section>
<section>
<pre>
/**
 * <span class="fragment highlight-current-blue">Calculate the reciprocal square root.</span>
 * <span class="fragment highlight-current-blue">@param number The input number</span>
 * <span class="fragment highlight-current-blue">@return The reciprocal square root of the input</span>
 */
float reciprocal_square_root( float number ) { ... }
</pre>
<aside class="notes">Here's an example of documentation I would've
written when I first accepted that documentation was needed. First we
have a sentence describing the function, then an explanation of the
input, and finally an explanation of the output.
</aside>
</section>
<section>
<pre>
/**
 * <span class="fragment highlight-current-blue" data-fragment-index="1">Calculate the reciprocal square root.</span>
 * <span class="fragment highlight-current-blue" data-fragment-index="2">@param number The input number</span>
 * <span class="fragment highlight-current-blue" data-fragment-index="3">@return The reciprocal square root of the input</span>
 */
float <span class="fragment highlight-current-blue" data-fragment-index="1">reciprocal_square_root</span>( <span class="fragment highlight-current-blue" data-fragment-index="2">float number</span> ) { ... }
</pre>
<h1>&nbsp;</h1>
<aside class="notes">what does the documentation provide here? The function
name tells me that it calculates a reciprocal square root, so I don't need to
say that do I? It also seems redundant to say that the input is a number (it's
declared as a double), or that the result of the reciprocal square root
function is the reciprocal square root of the input.</aside>
</section>
<section>
<pre>
/**
 * Calculate the reciprocal square root.
 * @param number The input number
 * @return The reciprocal square root of the input
 */
float reciprocal_square_root( float number ) { ... }
</pre>
<h1>Self-documenting Code</h1>
<aside class="notes">Descriptive function names and descriptive
parameter names go a long way to making functions easier to understand
and use. So much so that some have advocated _against_ documentation.
And, if all your documentation is like this, I don't really blame
them.</aside>
</section>
</section>
<section>
<section>
<h1>Good Documentation</h1>
<ol>
<li><h3>What does the function do?</h3></li>
<li class="fragment"><h3>What are the inputs?</h3></li>
<li class="fragment"><h3>Why does this function exist?</h3></li>
<li class="fragment"><h3>How do I use the function?</h3></li>
</ol>
<aside class="notes">Good documentation has a few parts. Questions 1 and
2 can be answered by code alone, though it's better documentation if you
answer them too. Questions 3 and 4 can only be answered by
documentation.</aside>
</section>
<section>
<pre>/**
 * <span class="fragment highlight-current-blue">Quickly calculate the reciprocal of the square root of
 * the given number.</span> <span class="fragment highlight-current-blue">This is used instead of the
 * standard sqrt function for performance.</span> <span class="fragment highlight-current-blue">Used by
 * [the vector2 class] to calculate magnitudes and unit
 * vectors.</span>
 *
<span class="fragment highlight-current-blue"> *   // Calculate the normalized vector of an input vector
 *   vector2 input( 5, 6 );
 *   double len = pow(input.x, 2.0) + pow(input.y, 2.0);
 *   double mag = rsqrt( len );
 *   vector2 normalized( input.x * mag, input.y * mag );</span>
 *
 * <span class="fragment highlight-current-blue">See https://en.wikipedia.org/wiki/Fast_inverse_square_root</span>
 */
float reciprocal_square_root( float number ) { ... }
</pre>
<aside class="notes">Here's an example of good documentation. I describe
what the function does. Explain why I'm doing this as opposed to
anything else. Then I link this function to the larger project, giving
the reader a place to go next. Then I have some example code, and I even
include a link to the Wikipedia article explaining this code. Links are
good, use them a lot in your documentation.</aside>
</section>
</section>
<section>
<section>
<h1>Great Documentation</h1>
<aside class="notes">Really great documentation</aside>
</section>
<section>
<h1>More Than What</h1>
<aside class="notes">is more than what the code does</aside>
</section>
<section>
<h1>More Than How</h1>
<aside class="notes">is more than how the code is used</aside>
</section>
<section>
<h1>Why</h1>
<aside class="notes">it explains why the code is useful</aside>
</section>
<section>
<h1>Teaches</h1>
<h1 class="fragment">Concepts</h1>
<aside class="notes">Good documentation teaches the concepts around the
code</aside>
</section>
<section>
<h1>Teaches</h1>
<h1>Business Rules</h1>
<aside class="notes">The business rules implemented by the code</aside>
</section>
<section>
<h1>Teaches</h1>
<h1>Domain Model</h1>
<aside class="notes">And as much of the domain knowledge, the real
problems this software is solving, as is needed to understand the code</aside>
</section>
<section>
<h1>When to Use</h1>
<h1>Something Else</h1>
<aside class="notes">The best documentation even explains when to use
something else. When your code is not the right code for the job.</aside>
</section>
<section>
<h1>Remembers</h1>
<aside class="notes">I write down documentation so I don't have to
remember. For future me to read and understand the code.</aside>
</section>
</section>
<section>
<section>
<h1>Write Good</h1>
<h1>Documentation</h1>
<aside class="notes">So, to write good documentation.</aside>
</section>
<section>
<h1>Modules</h1>
<h3 class="fragment">Description</h3>
<h3 class="fragment">Examples</h3>
<h3 class="fragment">Cross-References</h3>
<aside class="notes">Make sure all your modules, classes, libraries,
collections, or otherwise have clear descriptions, numerous examples,
and plenty of internal and external links for cross-references.</aside>
</section>
<section>
<h1>Functions</h1>
<h3 class="fragment">Description</h3>
<h3 class="fragment">Examples</h3>
<h3 class="fragment">Cross-References</h3>
<aside class="notes">And repeat the same thing for every function,
method, subroutine, or other piece of runnable code.</aside>
</section>
</section>
<section>
<h1>Documentation Answers Why</h1>
<aside class="notes">Remember that documentation answers why</aside>
</section>
<section>
<h1>Software</h1>
<h2>Is More Than</h2>
<h1>Code</h1>
<aside class="notes">And that software is more than just the code we
write.</aside>
</section>
<section>
<h1>Thank You</h1>
</section>
</div>




