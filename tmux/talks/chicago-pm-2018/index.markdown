---
title: Organized Development With Tmux
layout: reveal.html
data:
    topic_url: preaction.me/tmux
    reveal:
        minScale: 1
        maxScale: 1
---

<div class="slides">
%= include 'deck/title.html.ep', title => $self->title

<section>
    <h1>Tmux</h1>
    <aside class="notes">Since showing is better than telling, I'm
    going to show you what Tmux does.</aside>
</section>

<section>
    <h1><code>screen</code></h1>
    <aside class="notes">But first, who has used GNU screen? Okay, so
    a lot of this will be familiar to you.</aside>
</section>

<section>
    <h1>Installing</h1>
    <aside class="notes">We're not going to go over installing Tmux.
    It's available from all major package managers including Homebrew
    for MacOS, Cygwin, and works inside Windows Subsystem for Linux
    (Ubuntu-in-Windows)</aside>
</section>

<section>
    <section>
        <h1>Starting Tmux</h1>
        <aside class="notes">To start Tmux, we need to run the <code>tmux</code>
        command</aside>
    </section>
    <section>
        <img alt="Terminal window with the command 'tmux' typed-in" src="starting-tmux-1-run-tmux.png">
        <aside class="notes">Once we run this command...</aside>
    </section>
    <section>
        <img alt="Terminal window running 'tmux'" src="starting-tmux-2-inside-tmux.png">
        <aside class="notes">We get a shell prompt again, but now we
        have a bar at the bottom of the window. This is the Tmux status
        bar.</aside>
    </section>
    <section data-background-color="#111">
        <img alt="Tmux window with session name highlighted" src="starting-tmux-2.1-session-name.png">
        <aside class="notes">Over in the bottom left in square brackets
        we have the session name, which defaults to <code>0</code>.
        We'll talk about using session names later.</aside>
    </section>
    <section data-background-color="#111">
        <img alt="Tmux window with window information highlighted" src="starting-tmux-2.2-window.png">
        <h1 class="fragment solarized-bar-text absolute-center">
            <span class="fragment highlight-current-purple">0</span>:<span class="fragment highlight-current-purple">zsh</span><span class="fragment highlight-current-purple">*</span>
        </h1>
        <!-- It took 30 minutes to make this work correctly, so I need
             to stop thinking that I can just "do my slides" in the hour
             before the talk, after I've written the full talk in prose
             -->
        <aside class="notes">Next to that we have window information.
        &gt;&gt; We have one window, &gt;&gt; window 0, currently
        running <code>zsh</code> (my shell), &gt;&gt; and the asterisk
        says it is the selected window. Creating and managing windows is
        the most useful part of Tmux, and we'll spend a lot of time
        talking about them. </aside>
    </section>
    <section data-background-color="#111">
        <img alt="Tmux window with bottom right corner highlighted" src="starting-tmux-2.3-info-box.png">
        <aside class="notes">Finally, on the right, we have some
        information about our machine: My laptop's hostname is
        &quot;gwen.local&quot;, and this screenshot was taken at 8:32 PM
        on May 22, 2018.</aside>
    </section>
    <section>
        <img alt="Tmux window with 'ps u' typed in a shell prompt" src="starting-tmux-3-type-command.png">
        <aside class="notes">Otherwise, this is just what we had without
        Tmux. We can type a command into our shell and execute
        it...</aside>
    </section>
    <section>
        <img alt="Tmux window with output from 'ps u'" src="starting-tmux-4-run-command.png">
        <aside class="notes">and the output is displayed on our screen. Amazing!</aside>
    </section>
    <section>
        <img alt="Tmux window with 'exit' typed in a shell prompt" src="starting-tmux-5-type-exit.png">
        <aside class="notes">And then when we're done, we can exit our shell</aside>
    </section>
    <section>
        <img alt="Terminal window after exiting Tmux" src="starting-tmux-6-exited.png">
        <aside class="notes">And we exit Tmux.</aside>
    </section>
</section>

<section>
    <section>
        <h1>Detach</h1>
        <h1 class="fragment">Attach</h1>
        <aside class="notes">However, instead of exiting, we can detach
        from our Tmux session and re-attach to it later. When we detach
        from a session, Tmux stays running in the background. Everything
        in our session keeps running, too, waiting for us to
        return.</aside>
    </section>
    <section>
        <img alt="Terminal window with the command 'tmux' typed-in" src="starting-tmux-1-run-tmux.png">
        <aside class="notes">So let's start Tmux again</aside>
    </section>
    <section>
        <img alt="Terminal window running 'tmux'" src="starting-tmux-2-inside-tmux.png">
        <h1 class="fragment absolute-center bg-solarized">
            <kbd>
                <span class="fragment highlight-current-red">Ctrl+b</span>
                <span class="fragment highlight-current-red">d</span>
            </kbd>
        </h1>
        <aside class="notes">But this time let's detach from our session
        instead of exiting. We do this by typing &quot;Ctrl+b d&quot;.
        &gt;&gt; &quot;Ctrl+b&quot; is the prefix. Typing this tells
        Tmux we're about to give it a command. &gt;&gt; And then
        &quot;d&quot; for &quot;detach&quot;. If you're a screen user,
        screen uses &quot;Ctrl+a&quot; as its prefix by default, and
        later I'll show how to configure what the prefix is if you
        prefer &quot;Ctrl+a&quot;.</aside>
    </section>
    <section>
        <img alt="Terminal showing as detached from tmux session 0" src="detach-1-detached.png">
        <aside class="notes">When we detach, we're back in our terminal
        window where we left off. But our Tmux session is still running.</aside>
    </section>
    <section>
        <img alt="Terminal showing &quot;tmux attach-session&quot; typed in a prompt" src="detach-2-run-attach.png">
        <aside class="notes">To get back to our session, we can run
        &quot;tmux attach-session&quot;, or for brevity &quot;tmux
        attach&quot;, or for even more brevity &quot;tmux
        a&quot;.</aside>
    </section>
    <section>
        <img alt="Terminal window running 'tmux'" src="detach-3-back-inside-tmux.png">
        <aside class="notes">When we do that, we're right back where we left off.</aside>
    </section>
    <section>
        <h1>SSH</h1>
        <aside class="notes">Why is this useful? The most common use is
        over SSH. Connect to a remote machine via SSH and then run Tmux.
        If you detach, or get disconnected, you can later reattach and
        pick up where you left off. For some people, this is the only
        reason they use Tmux.</aside>
    </section>
    <section>
        <h1>Detached Tasks</h1>
        <aside class="notes">This is also good for just putting local
        tasks in the background, unattached to any terminal. There are
        other ways to do this, nohup and disown, but Tmux makes it
        easier to get back to those tasks later (it's not impossible
        with nohup/disown, just more difficult / annoying).</aside>
    </section>
</section>

<section>
    <section>
        <h1>Windows</h1>
        <aside class="notes">Now that we've reattached, we can try some other features. The name
        &quot;Tmux&quot; stands for &quot;Terminal Multiplexer&quot;, making one terminal act like
        multiple terminals. The first way we can do that is with windows.</aside>
    </section>
    <section>
        <img alt="Terminal window running 'tmux'" src="starting-tmux-2-inside-tmux.png">
        <aside class="notes">Here we are back in Tmux.</aside>
    </section>
    <section>
        <img alt="Terminal window running 'tmux'" src="windows-1-running-vim.png">
        <aside class="notes">Remember that we already have one window, window 0. Let's open a
        program in this window. I'll open my editor, Vim.</aside>
    </section>
    <section>
        <img alt="Terminal window showing the vim startup screen" src="windows-2-inside-vim.png">
        <h1 class="fragment absolute-center bg-solarized">
            <kbd>
                <span class="fragment highlight-current-red">Ctrl+b</span>
                <span class="fragment highlight-current-red">c</span>
            </kbd>
        </h1>
        <aside class="notes">Okay, now this window is busy running Vim. In order to also do
        something else, we will need to open a new window. &gt;&gt; We can open a new
        window with &quot;Ctrl+b c&quot;. &quot;Ctrl+b&quot; is the prefix, and &quot;c&quot; for &quot;create
        window&quot;.</aside>
    </section>
    <section>
        <img alt="Tmux window showing a command prompt and two windows in the status bar" src="windows-3-new-window.png">
        <aside class="notes">Now we have a new window, with a new shell.</aside>
    </section>
    <section data-background-color="#111">

<img alt="Tmux window with the new window in the status bar highlighted" src="windows-3.1-new-window.png">

<h1 class="fragment solarized-bar-text absolute-center">
    <span class="fragment highlight-current-purple">1</span>:<span class="fragment highlight-current-purple">zsh</span><span class="fragment highlight-current-purple">*</span>
</h1>

<aside class="notes">Our new window is &gt;&gt; window number 1, &gt;&gt; running &quot;zsh&quot;, &gt;&gt; and is our
current window.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window with the previous window in the status bar highlighted" src="windows-3.2-old-window.png">

<h1 class="fragment solarized-bar-text absolute-center">
    0:vim<span class="fragment highlight-current-purple">-</span>
</h1>

<aside class="notes">And notice our old window now has a &gt;&gt; dash (&quot;-&quot;) instead of an
asterisk. This means it was the previous window we were looking at.
There's a lot of information packed in to a tiny space down
here.</aside>

    </section>
    <section>

<img alt="Tmux window showing a command prompt and two windows in the status bar" src="windows-3-new-window.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b l</kbd>
    <kbd class="fragment">Ctrl+b p</kbd>
    <kbd class="fragment">Ctrl+b 0</kbd>
</h1>

<aside class="notes">Now, how do we get back to our Vim window? We have multiple ways. &gt;&gt;
Since it was the previous window, we can use &quot;Ctrl+b l&quot; (&quot;l&quot; for the
last window we were on). &quot;Ctrl+b l&quot; allows you to quickly toggle between
two windows. &gt;&gt; We can use &quot;Ctrl+b p&quot; to go back to the previous window
numerically in the list &gt;&gt; Or we can choose our window by its number
with &quot;Ctrl+b 0&quot;. The last one is made more difficult because the first
window is window 0, but we'll go over how to configure that to make the
windows start at 1.</aside>

    </section>
    <section>

<img alt="Terminal window showing the vim startup screen" src="windows-4-back-to-vim.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b l</kbd>
    <kbd class="fragment">Ctrl+b n</kbd>
    <kbd class="fragment">Ctrl+b 1</kbd>
</h1>

<aside class="notes">Doing any one of these will bring us back to our Vim window. Then, to
get back to our new window, we can do &gt;&gt; &quot;Ctrl+b l&quot; again, since it was
our last window &gt;&gt; &quot;Ctrl+b n&quot;, to move to the next window numerically &gt;&gt;
or &quot;Ctrl+b 1&quot; to go directly to window 1.</aside>

    </section>
    <section>

<img alt="Tmux window showing a command prompt and two windows in the status bar" src="windows-3-new-window.png">

<aside class="notes">Then we can run commands in this new window</aside>

    </section>
    <section>

<img alt="Tmux window showing the manual page for Tmux" src="windows-5-run-command.png">

<aside class="notes">Like look up some documentation for Tmux</aside>

    </section>
    <section>

<img alt="Tmux window showing the word &quot;exit&quot; typed into the command prompt" src="windows-6-type-exit.png">

<aside class="notes">And then when we're done, we exit the
shell</aside>

    </section>
    <section>

<img alt="Tmux window showing our first window with Vim after the second window is destroyed" src="windows-7-back-to-vim-again.png">

<aside class="notes">We're back to our last window.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the area of the status bar where the destroyed window was" src="windows-7.1-window-destroyed.png">

<aside class="notes">And our new window is destroyed.</aside>

    </section>
</section>
<section>
    <section>

<h1>Scroll Buffer</h1>

<aside class="notes">The next thing a new Tmux user comes across is that their terminal's
scroll bar doesn't work anymore.</aside>

    </section>
    <section>

<img alt="Tmux window showing a &quot;ps au&quot; command typed in" src="scroll-1-run-verbose-command.png">

<aside class="notes">We can run a command...</aside>

    </section>
    <section>

<img alt="Tmux window showing the bottom of the output of &quot;ps
au&quot;" src="scroll-2-ps-au-output.png">

<aside class="notes">... that prints out a lot of data, and when we use our mouse to try to
scroll our terminal window back up to see the top...</aside>

    </section>
    <section>

<img alt="Terminal window with a Tmux status bar in the middle instead of on the
bottom" src="scroll-3-scroll-fail.png">

<aside class="notes">We scroll through the terminal, not the output. Sometimes, we won't
scroll at all.</aside>

    </section>
    <section>

<img alt="Tmux window showing the bottom of the output of &quot;ps
au&quot;" src="scroll-2-ps-au-output.png">

<h1 class="fragment absolute-center bg-solarized">
    <span class="nowrap">Copy Mode</span>
    <kbd class="fragment">Ctrl+b [</kbd>
</h1>

<aside class="notes">This happens because Tmux is keeping the output in a buffer. This is
good, it means we can come back to it later. But it means that we need
to tell Tmux we want to scroll through the buffer by &gt;&gt; entering &quot;copy
mode&quot;. We enter &quot;copy mode&quot; by &gt;&gt; pressing &quot;Ctrl+b&quot; and then the left
square bracket (&quot;[&quot;).</aside>

    </section>
    <section>

<img alt="Tmux window in copy mode" src="scroll-4-copy-mode.png">

<aside class="notes">In &quot;copy mode&quot; we have two changes to our window.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the window name in the status bar enclosed in
square brackets" src="scroll-4.1-window-name-brackets.png">

<h1 class="fragment solarized-bar-text absolute-center nowrap">
    1:[tmux]*
</h1>

<aside class="notes">The window name in the bottom bar is &gt;&gt; changed to &quot;tmux&quot; enclosed in
square brackets to show we're in copy mode</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the scroll position indicator in the upper
right" src="scroll-4.2-scroll-position.png">

<h1 class="fragment solarized-search-text absolute-center nowrap">
    [<span class="fragment highlight-current-white">0</span>/<span class="fragment highlight-current-white">198</span>]
</h1>

<aside class="notes">And there are two numbers in the upper right of the screen. &gt;&gt; The
first one shows the line we're on (0 is the bottom of the screen) &gt;&gt; The
second shows the total number of lines in the buffer</aside>

    </section>
    <section>

<img alt="Tmux window in copy mode" src="scroll-4-copy-mode.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>⬅️ ⬇️ ⬆️ ➡️ </kbd>
    <kbd class="fragment">PgUp PgDn</kbd>
</h1>

<aside class="notes">We move through the buffer using &gt;&gt; arrow keys &gt;&gt; Page Up / Page Down
keys ...</aside>

    </section>
    <section>

<img alt="Tmux window in copy mode" src="scroll-4-copy-mode.png">

<h1 class="absolute-center bg-solarized">
    <kbd>h j k l</kbd>
    <kbd class="fragment">Ctrl+f Ctrl+b</kbd>
    <kbd class="fragment">g G</kbd>
</h1>

<aside class="notes">... or Tmux also comes set up with less-style bindings &gt;&gt; (Ctrl+b
goes down, Ctrl+f goes up) &gt;&gt; &quot;g&quot; goes to the top, &quot;G&quot; to the bottom.
and you can configure other styles (vim and emacs)</aside>

    </section>
    <section>

<img alt="Tmux window scrolled to the top" src="scroll-5-over-the-top.png">

<aside class="notes">I hit the &quot;g&quot; key, and I scrolled all the way to the top. Now I can
hit the &quot;G&quot; key and scroll back to the bottom.</aside>

    </section>
    <section>

<img alt="Tmux window in copy mode" src="scroll-4-copy-mode.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>?</kbd>
    <kbd class="fragment">/</kbd>
</h1>

<aside class="notes">We can also move through our buffer searching for keywords using the
question mark (&quot;?&quot;) key to search up, &gt;&gt; and the slash (&quot;/&quot;) key to
search down.</aside>

    </section>
    <section>

<img alt="Tmux window showing (search up) in the status
bar" src="scroll-6-search-up.png">

<aside class="notes">So, to search up we hit the &quot;?&quot;
key.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window showing (search up) in the status bar,
highlighted" src="scroll-6.1-search-up-highlights.png">

<h1 class="fragment absolute-center solarized-search-text nowrap">
    (search up)
    <kbd class="fragment">tmux</kbd>
</h1>

<aside class="notes">Tmux shows us that we're searching up. &gt;&gt; Then we type what we want to
look for, and press Enter.</aside>

    </section>
    <section>

<img alt="Tmux window showing search results highlighted" src="scroll-7-results.png">

<aside class="notes">Now Tmux shows us our results</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the highlighted search
results" src="scroll-7.1-highlight-search-words.png">

<aside class="notes">... highlights the matched text...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the highlighted search
results" src="scroll-7.2-highlight-cursor.png">

<aside class="notes">... putting our cursor on the bottom one, since we're searching up ...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the search status bar at the
top" src="scroll-7.3-highlight-result-status.png">

<aside class="notes">and tells us how many results are found.</aside>

    </section>
    <section>

<img alt="Tmux window showing search results highlighted" src="scroll-7-results.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>n</kbd>
    <kbd class="fragment">N</kbd>
</h1>

<aside class="notes">We can see the next search result &gt;&gt; by pressing &quot;n&quot;, and the previous
result by &gt;&gt; pressing &quot;N&quot;.</aside>

    </section>
    <section>

<img alt="Tmux window showing cursor on the next
result" src="scroll-8-next-result.png">

<aside class="notes">Pressing &quot;n&quot; to go to the next result...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window showing cursor on the next
result, highlighted" src="scroll-8.1-next-result-highlighted.png">

<aside class="notes">... takes me up the page (because I'm searching up).</aside>

    </section>
    <section>

<img alt="Tmux window showing cursor on the next
result" src="scroll-8-next-result.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>q</kbd>
</h1>

<aside class="notes">We can exit copy mode by &gt;&gt; pressing &quot;q&quot;...</aside>

    </section>
    <section>

<img alt="Tmux window showing the bottom of the output of &quot;ps
au&quot;" src="scroll-2-ps-au-output.png">

<aside class="notes">and we're back at our command prompt at the bottom of our window</aside>

    </section>
    <section>

<img alt="Tmux window scrolled to the top" src="scroll-5-over-the-top.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Space</kbd>
</h1>

<aside class="notes">Finally, it's called &quot;copy mode&quot; because we can copy text from the
buffer and paste it later. &gt;&gt; Start selecting text by pressing the space
bar</aside>

    </section>
    <section>

<img alt="Tmux window showing selected text" src="scroll-9-select-text.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+w</kbd>
    <kbd class="fragment">Enter</kbd>
</h1>

<aside class="notes">Now moving through the text will select it. When we've selected the
text we want, we can &gt;&gt; press &quot;Ctrl+w&quot; &gt;&gt; or &quot;Enter&quot; to copy the text.</aside>

    </section>
    <section>

<img alt="Tmux window showing vim" src="scroll-10-switch-window.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b ]</kbd>
</h1>

<aside class="notes">And then we can move to another window and &gt;&gt; press &quot;Ctrl+b&quot; and the
right square bracket (&quot;]&quot;) to paste the text</aside>

    </section>
    <section>

<img alt="Tmux window showing vim with pasted text
inside" src="scroll-11-paste-text.png">

<aside class="notes">And now our selected text is in our editor. Some of this is a little
awkward. I admit that I rarely use copy mode for its copy/asideaste
features, mostly for searching program output, which I then select with
my mouse. But there have been some times where copy/paste using copy
mode was the only solution. For example, if the text I want to copy
takes up more lines than can be displayed on the screen.</aside>

    </section>
</section>
<section>
    <section>

<h1>Window Panes</h1>

<aside class="notes">Okay, so, Tmux can create multiple windows, that's great. But what if
I want to look at my editor and my program's output at the same time?
For this, Tmux allows splitting windows into panes.</aside>

    </section>
    <section>

<img alt="Tmux window showing vim" src="panes-1-editor-window.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b %</kbd>
</h1>

<aside class="notes">To split the editor window vertically, use &gt;&gt; &quot;Ctrl+b&quot; and the percent
sign (&quot;%&quot;).</aside>

    </section>
    <section>

<img alt="Tmux window split vertically showing vim on the left, a shell on the
right" src="panes-2-split-vertically.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b &quot;</kbd>
</h1>

<aside class="notes">Now our window is split in two, with a new shell on the right side. We
can also &gt;&gt; split horizontally using &quot;Ctrl+b&quot; and double quote ('&quot;').</aside>

    </section>
    <section>

<img alt="Tmux window split vertically with the right pane split
horizontally" src="panes-3-split-horizontally.png">

<aside class="notes">So, now we split our right pane in two horizontally. And we can keep
going...</aside>

    </section>
    <section>

<img alt="Tmux window split vertically, with the right pane split horizontally,
and then the right-bottom pane split vertically" src="panes-4-split-more.png">

<aside class="notes">and going...</aside>

    </section>
    <section>

<img alt="Tmux window split vertically, with the right pane split horizontally,
the right-bottom pane split vertically, and then the right-bottom-right
pane split horizontally" src="panes-5-split-alive.png">

<aside class="notes">and going on in to uselessness. Each pane has its own shell and scroll
buffer. When we're done with a pane, we can exit our shell...</aside>

    </section>
    <section>

<img alt="Tmux window split vertically, with the right pane split horizontally,
and then the right-bottom pane split vertically" src="panes-4-split-more.png">
<aside class="notes">... and the space gets reclaimed</aside>
    </section>
    <section>

<img alt="Tmux window split vertically with the right pane split
horizontally" src="panes-3-split-horizontally.png">

    </section>
    <section>

<img alt="Tmux window split vertically showing vim on the left, a shell on the
right" src="panes-2-split-vertically.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b ⬅️</kbd>
    <kbd class="fragment">⬅️ ⬇️ ⬆️ ➡️ </kbd>
</h1>

<aside class="notes">Now we're back to our editor on one side, our shell on the other. To
switch panes to get back to our editor, we can use &gt;&gt; &quot;Ctrl+b&quot; and Left.
&quot;Ctrl+b&quot; and the arrow keys moves between the panes in the window.</aside>

    </section>
    <section>

<img alt="Tmux window split vertically showing vim on the left, a shell on the
right, with the cursor in the vim window" src="panes-6-editor-selected.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b z</kbd>
</h1>

<aside class="notes">Now we're back in our editor. If we've split our window, but we need
to look at a pane using all available space temporarily, we can use &gt;&gt;
&quot;Ctrl+b z&quot; to zoom in to the current pane.</aside>

    </section>
    <section>

<img alt="Tmux window with editor pane zoomed" src="panes-7-zoom.png">

<aside class="notes">Now our editor takes up the full window...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window with editor pane zoomed showing window in status bar
highlighted" src="panes-7.1-zoom-highlighted.png">

<h1 class="fragment solarized-bar-text absolute-center nowrap">
    0:vim*<span class="highlight-purple">Z</span>
</h1>

<aside class="notes">... and down here next to our window &gt;&gt; we can see a &quot;Z&quot; to show we're
zoomed.</aside>

    </section>
</section>
<section>

<h1>The Basics of Tmux</h1>

<h3 class="fragment">Start / Stop</h3>

<h3 class="fragment">Attach / Detach</h3>

<h3 class="fragment">Windows</h3>

<h3 class="fragment">Scroll buffer</h3>

<h3 class="fragment">Panes</h3>

<aside class="notes">Those are the basics of Tmux: &gt;&gt; Starting and stopping Tmux, &gt;&gt;
Attaching and detaching from Tmux, &gt;&gt; Creating, destroying, and
switching windows &gt;&gt; Using the scroll buffer and copy mode &gt;&gt; And
creating, destroying, and switching panes. With only this, Tmux is
a very useful tool.</aside>

</section>
<section>
    <section>

<h1>Configuration</h1>

<aside class="notes">But, we can make it even more useful. The first thing we can do to
maximize Tmux's usefulness is to customize it for our needs. Tmux is
highly configurable, so we can only go over some of the most useful
things here.</aside>

    </section>
    <section>

<h1>Examples</h1>

<aside class="notes">These are just examples of things you could do, copied from my own
configs.</aside>

    </section>
    <section>

<h1>Config File</h1>

<h2><code>~/.tmux.conf</code></h2>

<aside class="notes">The Tmux configuration file is <code>.tmux.conf</code> in our home directory. If
you've never configured Tmux, you'll have to create this file.</aside>

    </section>
    <section>

<img alt="Vim window showing &quot;:e&quot; command to edit
~/.tmux.conf" src="config-1-edit-tmux-conf.png">

<aside class="notes">I'm going to open up ~/.tmux.conf in my editor</aside>

    </section>
    <section>

<h1>Setting the Prefix</h1>

<aside class="notes">The first thing I do in my Tmux is change the prefix.</aside>

    </section>
    <section>

<h1>Tmux</h1>

<h1><code>Ctrl+b</code></h1>

<aside class="notes">Remember &quot;Ctrl+b&quot; is called the &quot;prefix&quot;. It's what we use to tell
Tmux we're about to give it a command. But, to me, Ctrl+B is a finger
workout.</aside>

    </section>
    <section>

<h1>Screen</h1>

<h1><code>Ctrl+a</code></h1>

<aside class="notes">Screen users often switch this to Ctrl+A, but Ctrl+A is useful
in shells (it moves the cursor to the start of the line).</aside>

    </section>
    <section>

<h1>Custom</h1>

<h1><code>Ctrl+s</code></h1>

<aside class="notes">So I use Ctrl+S: The &quot;S&quot; key is on the home row under my fingers, next
to A. And I rarely use Ctrl+S for its original purpose, sending SIGSTOP
to stop a process.</aside>

    </section>
    <section>

<img alt="vim window editing ~/.tmux.conf, a new
file" src="config-1-edit-tmux-conf.png">

<h2 class="fragment solarized-text absolute-center nowrap">
    <code>
        <span>set</span>
        <span class="fragment">-g</span>
        <span class="fragment">prefix</span>
        <span class="fragment">
            <span class="fragment highlight-current-red">C</span>-s
        </span>
    </code>
</h2>

<aside class="notes">To change the prefix, &gt;&gt; we use the <code>set</code> command. &gt;&gt; we give a <code>-g</code>
option to make it a global setting &gt;&gt; and we set the &quot;prefix&quot; &gt;&gt; to
&quot;C-s&quot;. The &gt;&gt; capital-C is &quot;control&quot;</aside>

    </section>
    <section>

<img alt="vim window showing set prefix in config file" src="config-2-set-prefix.png">

<h1 class="fragment solarized-text absolute-center nowrap">
    <code>
        <span>unbind</span>
        <span class="fragment">C-b</span>
    </code>
</h1>

<aside class="notes">After we change the prefix, we have to do two more things. First, the
default behavior for pressing &quot;Ctrl+b&quot; twice is to send &quot;Ctrl+b&quot; to the
currently-running program. We can stop that behavior by &gt;&gt; using the
<code>unbind</code> command to &gt;&gt; stop &quot;Ctrl+b&quot; from doing anything.</aside>

    </section>
    <section>

<img alt="vim window showing unbind command added to config
file" src="config-3-unbind-old-prefix.png">

<h2 class="fragment solarized-text absolute-center nowrap">
    <code>
        <span>bind</span>
        <span class="fragment">C-s</span>
        <span class="fragment">send-prefix</span>
    </code>
</h2>

<aside class="notes">Finally, we need a way to send Ctrl+s to the current program just in
case we need to. So, we'll make pressing Ctrl+s twice send a Ctrl+s to
the currently-running program. We configure a key using &gt;&gt; the &quot;bind&quot;
command, which takes &gt;&gt; the key to bind (Ctrl+s) &gt;&gt; and the command to
run (&quot;send-prefix&quot;, which sends the configured prefix to our current
program)</aside>

    </section>
    <section>

<img alt="vim window showing bind for send-prefix added to
config" src="config-4-bind-send-prefix.png">

<aside class="notes">Now our prefix is Ctrl+s, Ctrl+b is just Ctrl+b, and pressing Ctrl+s
twice sends one Ctrl+s to our current program. Note: I will keep calling
the prefix &quot;Ctrl+b&quot; for the rest of this talk, to try to limit
confusion, or increase it, whichever.</aside>

    </section>
    <section>

<h1>Window Index</h1>

<aside class="notes">Next, let's renumber our windows.</aside>

    </section>
    <section>

<h1 class="fragment">1 2 3 ... 0</h1>

<h1>0 1 2 ... 9</h1>

<aside class="notes">Having the window number start at 0 is annoying: &gt;&gt; Our keyboards all
start numbering at 1 on the left, with 0 on the right.</aside>

    </section>
    <section>

<h1>1 2 3 ... <span class="highlight-red">0</span></h1>

<h1><span class="highlight-red">0</span> 1 2 ... 9</h1>

<aside class="notes">If we use the number keys to switch windows, we have to use the right
side of the keyboard to get to the first window on the left.</aside>

    </section>
    <section>

<img alt="vim window showing bind for send-prefix added to
config" src="config-4-bind-send-prefix.png">

<h2 class="fragment solarized-text absolute-center nowrap">
    <code>
        <span>set -g</span>
        <span class="fragment">base-index</span>
        <span class="fragment">1</span>
    </code>
</h2>

<aside class="notes">To fix this, let's &gt;&gt; set (globally) the &gt;&gt; base-index to &gt;&gt; 1.</aside>

    </section>
    <section>

<img alt="vim window showing set base-index" src="config-5-set-base-index.png">

<aside class="notes">Now our windows will start numbering from 1, not 0</aside>

    </section>
    <section>

<h1>Escape Time</h1>

<aside class="notes">Next thing we should configure: The default behavior of Tmux is to
have a 1-second delay between when the Escape key is pressed and when it
is sent to the underlying program.</aside>

    </section>
    <section>

<h1>Escape Sequence</h1>

<h2>
    <kbd class="fragment">Esc [D</kbd><br>
    <kbd class="fragment">Esc [C</kbd><br>
    <kbd class="fragment">Esc [1m</kbd>
</h2>

<aside class="notes">This is because the Escape character is the first character in an ANSI
escape sequence, a way to send special commands to terminals. Extremely
special commands like pressing the left arrow to move cursor left,
pressing the right arrow to move cursor right, and making text
bold</aside>

    </section>
    <section>

<h1>🏃 ^[D</h1>

<h1 class="fragment">🚶 ^   [   D</h1>

<h1 class="fragment">🕺  ^      [      D</h1>

<aside class="notes">Since we use the arrow keys to change panes, Tmux has to wait after it
sees an Escape character to see if it's part of an escape sequence.
Normally, this takes almost no time. &gt;&gt; But, if you're on a network, the
gaps between the bytes &gt;&gt; could take a lot longer.</aside>

    </section>
    <section>

<h1>Vim + Tmux</h1>

<aside class="notes">But, as a Vim user, I use Escape a lot to escape back to &quot;normal&quot;
mode, the mode that lets me navigate my code. I use it so much I've
gotten extremely fast at it. So fast that the escape delay ends up
ruining whatever I'm trying to do.</aside>

    </section>
    <section>

<img alt="vim window showing set base-index" src="config-5-set-base-index.png">

<h2 class="fragment solarized-text absolute-center nowrap">
    <code>
        <span>set -g</span>
        <span class="fragment">escape-time</span>
        <span class="fragment">20</span>
    </code>
</h2>

<aside class="notes">So, let's configure Tmux to spend less time waiting for an Escape
sequence. Let's &gt;&gt; set the &gt;&gt; escape-time to ... &gt;&gt; 20 ms sounds about
right to me.</aside>

    </section>
    <section>

<img alt="vim window showing set escape-time" src="config-6-escape-time.png">

<table class="fragment absolute-center bg-solarized character-map">
    <tr><td>⬅️</td><td>⬇️</td><td>⬆️</td><td>➡️</td></tr>
    <tr class="fragment"><td>H</td><td>J</td><td>K</td><td>L</td></tr>
</table>

<aside class="notes">With that out of the way, let's make it easier to navigate around
panes. &gt;&gt; I'm a Vim user, so in my head I've mapped left, down, up, right
to &gt;&gt; H, J, K, L.</aside>

    </section>
    <section>

<img alt="vim window showing set escape-time" src="config-6-escape-time.png">

<h3 class="fragment solarized-text absolute-center">
    <code class="nowrap">
        bind
        <span class="fragment">h</span>
        <span class="fragment">select-pane</span>
        <span class="fragment">-L</span>
    </code>
    <code class="fragment nowrap">bind j select-pane -D</code>
    <code class="fragment nowrap">bind k select-pane -U</code>
    <code class="fragment nowrap">bind l select-pane -R</code>
</h3>

<aside class="notes">So, let's &gt;&gt; bind the &gt;&gt; h key &gt;&gt; to select the pane &gt;&gt; to the left.
Now, &quot;Ctrl+b h&quot; will run the select-pane command with the -L option,
which goes left. Then let's &gt;&gt; bind j &gt;&gt; to down, bind k &gt;&gt; to up, and
bind l &gt;&gt; to right</aside>

    </section>
    <section>

<img alt="vim window showing binds for
select-pane" src="config-7-bind-select-pane.png">

<aside class="notes">But we're not limited to only using the prefix: We can bind keys so
they work all the time, not just after the prefix. I can make it so
holding the Alt key and pressing h, j, k, or l will also switch between
panes.</aside>

    </section>
    <section>

<img alt="vim window showing binds for
select-pane" src="config-7-bind-select-pane.png">

<h3 class="solarized-text absolute-center fragment" data-fragment-index="0">
    <code class="nowrap">
        bind <span class="fragment" data-fragment-index="2">-n</span> <span class="fragment" data-fragment-index="1">M-</span>h select-pane -L
    </code>
    <code class="nowrap">
        bind <span class="fragment" data-fragment-index="2">-n</span> <span class="fragment" data-fragment-index="1">M-</span>j select-pane -D
    </code>
    <code class="nowrap">
        bind <span class="fragment" data-fragment-index="2">-n</span> <span class="fragment" data-fragment-index="1">M-</span>k select-pane -U
    </code>
    <code class="nowrap">
        bind <span class="fragment" data-fragment-index="2">-n</span> <span class="fragment" data-fragment-index="1">M-</span>l select-pane -R
    </code>
</h3>

<aside class="notes">So this time we use &gt;&gt; bind with the -n flag for &quot;no prefix&quot;. We bind &quot;Alt&quot; &quot;h&quot;.
The &quot;M&quot; stands for Meta, but since keyboards rarely have Meta keys, the
Alt key is usually used. &gt;&gt; And Alt-h selects the pane to the left.
Again, we do this for &gt;&gt; down, &gt;&gt; up, and &gt;&gt;
right.</aside>

    </section>
    <section>

<h1>Reloading Config</h1>

<aside class="notes">Now that we've changed our configuration file, we need to load it. We
could just restart Tmux, but we could also load our new configuration
inside our current session.</aside>

    </section>
    <section>

<img alt="vim window showing saved config file" src="config-8-config-saved.png">

<h1 class="fragment absolute-center bg-solarized">
    <kbd>Ctrl+b :</kbd>
</h1>

<aside class="notes">We can load a config file using Tmux's &quot;source&quot; command. This command
isn't bound to a key, but we can use Tmux's command prompt to use it.
To show the command prompt, &gt;&gt; press Ctrl+b and then the colon key (<code>:</code>).</aside>

    </section>
    <section>

<img alt="tmux window showing the command prompt" src="config-9-command-prompt.png">

<aside class="notes">The status bar changes to the command bar</aside>

    </section>
    <section data-background-color="#111">

<img alt="tmux window highlighting the command
bar" src="config-9.1-command-prompt-highlighted.png">

<aside class="notes">The command bar lets us execute Tmux commands. Everything we've
written in our configuration file so far has been a Tmux command, and
there are a lot more Tmux commands (and we'll get in to fun things you
can do with them a bit later)</aside>

    </section>
    <section>

<img alt="tmux window showing the command prompt" src="config-9-command-prompt.png">

<h2 class="fragment absolute-center solarized-search-text nowrap">
    :<kbd class="fragment">source</kbd>
    <kbd class="fragment">~/.tmux.conf</kbd>
</h2>

<aside class="notes">To load the config file, &gt;&gt; we use the &quot;source&quot; command, &gt;&gt; and give
it the file we want to load, &quot;~/.tmux.conf&quot;. This acts like your shell's
source (or '.') command: it reads the file and executes the commands
inside to change your current settings.</aside>

    </section>
    <section>

<img alt="vim window showing saved config file" src="config-10-configured.png">

<aside class="notes">With that done, our prefix is now Ctrl+s, and we can use our HJKL keys
to move between our panes. Notice that our windows are not numbered from
1 yet. This is because our config doesn't change existing windows. We
could fix this session with another command, but we won't.</aside>

    </section>
</section>
<section>
    <section>

<h1>Theming</h1>

<aside class="notes">Of course, we cannot be maximally productive if we can't change how
things look.</aside>

    </section>
    <section>

<img alt="vim window showing the config file" src="theme-1-config-file.png">

<aside class="notes">Tmux lets us change the color and position of anything in the status
bar.</aside>

    </section>
    <section>

<img alt="vim window highlighting the tmux status bar" src="theme-1.1-status-bar.png">

<aside class="notes">For example, the bottom bar's dark text doesn't have good contrast
against the medium green background.</aside>

    </section>
    <section>

<img alt="vim window highlighting the right status area" src="theme-1.2-right-status-area.png">

<aside class="notes">And this right side here takes up a lot of space for things I don't
need. I may sometimes forget what day it is, but that's what my
smartphone is for...</aside>

    </section>
    <section>

<img alt="vim window showing the config file" src="theme-1-config-file.png">

<h2 class="fragment solarized-text absolute-center">
    <code class="nowrap" style="display: block">
        set -g
        <span class="fragment">status-bg</span>
        <span class="fragment">black</span>
    </code>
    <code class="fragment nowrap" style="display: block">
        set -g
        <span class="fragment">status-fg</span>
        <span class="fragment">white</span>
    </code>
</h2>

<aside class="notes">So let's configure a couple things. First, let's make the status bar
to have white text on a black background. So, we &gt;&gt; set (globally) the
status background &gt;&gt; to black. And we &gt;&gt; set the &gt;&gt; status foreground
to white</aside>

    </section>
    <section>

<img alt="vim window showing config file with status-bg and
status-fg" src="theme-2-status-colors.png">

<h3 class="fragment solarized-text absolute-center">
    <code class="nowrap" style="display: block">
        set -g
        <span class="fragment">status-left-length</span>
        <span class="fragment">20</span>
    </code>
    <code class="fragment nowrap" style="display: block">
        set -g
        <span class="fragment">status-right-length</span>
        <span class="fragment">20</span>
    </code>
</h3>

<aside class="notes">Next let's configure the amount of space the left side (our session
name) and the right side (the date/time) are allowed to take up. We'll
need some more space for the session name soon, so let's set the
status-left-length to 20. We don't want the right side to take up as
much space as it is, so let's set that to 20 as well.</aside>

    </section>
    <section>

<img alt="vim window showing config file with status left/right
length" src="theme-3-status-length.png">

<div class="fragment absolute-center bg-solarized">
    <h1>
        <kbd>Ctrl+b :</kbd>
    </h1>
    <h2 class="fragment solarized-search-text">
        <kbd>:source ~/.tmux.conf</kbd>
    </h2>
</div>

<aside class="notes">Now we've got all this configured, so let's reload our configuration.
Remember that's &quot;Ctrl+b :&quot; to open the prompt, and then &gt;&gt; &quot;source
~/.tmux.conf&quot; to reload the config</aside>

    </section>
    <section>

<img alt="vim window showing new colors and layout" src="theme-4-new-theme.png">

<aside class="notes">Voila! Our bottom bar is now
black-and-white.</aside>

    </section>
    <section>

<img alt="vim window highlighting the bottom right status
area" src="theme-4.1-new-theme-right.png">

<aside class="notes">And only the hostname and the current time are shown on the right side
here</aside>

    </section>
    <section>

<img alt="vim window showing new colors and layout" src="theme-4-new-theme.png">

<aside class="notes">There are lots of other theme-related things you can do. There are
even plugins that add charts and other distractions down in the status
bar. Customize to your needs!</aside>

    </section>
    <section>

<h1>Mouse 🐭 Tmux</h1>

<h2><code>set -g mouse on</code></h2>

<aside class="notes">There are a lot more configuration options, including enabling the
mouse to select and scroll through the scroll buffer. I don't enable the
mouse, because I prefer how the mouse works in iTerm (my terminal), but
it can make selecting text easier than using the keyboard to move
around.</aside>

    </section>
</section>
<section>
    <section>

<h1>Organizing Sessions and Windows</h1>

<aside class="notes">Remember that detaching and attaching sessions is one of Tmux's core
features. But what if we don't want to reattach to our running session?</aside>

    </section>
    <section>

<img alt="Terminal window with &lt;code&gt;tmux&lt;/code&gt; command typed-in" src="sessions-1-run-tmux.png">

<aside class="notes">If we just run <code>tmux</code> again without trying to attach...</aside>

    </section>
    <section>

<img alt="Tmux window with session 1 in the bottom left" src="sessions-2-new-session.png">

<aside class="notes">we get a new session.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window with session 1 highlighted" src="sessions-2.1-session-name.png">

<aside class="notes">Notice in the lower left of the Tmux status bar, our session is now
<code>1</code></aside>

    </section>
    <section>

<img alt="Tmux window with session 1 in the bottom left" src="sessions-2-new-session.png">

<aside class="notes">Now we have a new Tmux session completely unrelated to our last
session. We can open windows, split them into panes, start programs, and
etc... just like our previous session.</aside>

    </section>
    <section>

<img alt="Terminal window showing detached from session
1" src="sessions-3-detach.png">

<aside class="notes">When we detach, tmux tells us we detached from session 1. Let's try
attaching again.</aside>

    </section>
    <section>

<img alt="Terminal window showing &quot;tmux attach&quot; typed-in" src="sessions-4-attach.png">

<aside class="notes">When we run <code>tmux attach</code>...</aside>

    </section>
    <section>

<img alt="Tmux window showing session 1" src="sessions-5-attached.png">

<aside class="notes">... we get the last session we attached to. Handy!</aside>

    </section>
    <section>

<img alt="Tmux window showing session 1" src="sessions-6-attach-to-0-inside-tmux.png">

<aside class="notes">But now how do we get to our first session, session <code>0</code>? If we use
<code>tmux attach</code> with the <code>-t</code> option, we can specify the target session we
want to attach to. In this case, session 0.</aside>

    </section>
    <section>

<img alt="Tmux window showing error for trying to attach inside
tmux" src="sessions-7-attach-error.png">

<aside class="notes">Okay, well, Tmux doesn't like being run inside Tmux. I forgot to
detach first.</aside>

    </section>
    <section>

<img alt="Terminal window showing &lt;code&gt;tmux attach -t 0&lt;/code&gt; typed
in" src="sessions-8-attach-to-0.png">

<aside class="notes">Okay, so then I run <code>tmux attach -t 0</code>...</aside>

    </section>
    <section>

<img alt="Tmux window showing session 0" src="sessions-9-attached-to-0.png">

<aside class="notes">... and now I'm back to session 0 looking at the window I detached
from.</aside>

    </section>
    <section>

<img alt="Terminal window showing &lt;code&gt;tmux ls&lt;/code&gt; typed-in" src="sessions-10-tmux-ls-typed.png">

<aside class="notes">If you want to know what Tmux sessions exist, or even whether Tmux is
running, you can run <code>tmux ls</code>.</aside>

    </section>
    <section>

<img alt="Terminal window showing output from &lt;code&gt;tmux ls&lt;/code&gt;" src="sessions-11-tmux-ls-output.png">

<aside class="notes">This will list the running sessions and some information about them.
If there is no Tmux server running, it will tell you.</aside>

    </section>
    <section>

<h1>Naming Sessions</h1>

<aside class="notes">But in order for us to use multiple sessions effectively, we need to
do something better than leaving them named as <code>0</code> and <code>1</code>. We can
instead give our sessions descriptive names: The project we're working
on, or the issue number we're working on.</aside>

    </section>
    <section>

<img alt="Tmux window showing session 1" src="sessions-5-attached.png">

<div class="fragment absolute-center bg-solarized">
    <h1>
        <kbd>Ctrl+b :</kbd>
    </h1>
    <h1 class="fragment">
        <kbd>Ctrl+b $</kbd>
    </h1>
</div>

<aside class="notes">We can rename a session we've created by using the <code>rename-session</code>
command. We can either use the Tmux prompt &gt;&gt; (<code>Ctrl+b :</code>) to run
<code>rename-session</code>, or we can use &gt;&gt; <code>Ctrl+b $</code>. I tend to end up using
the Tmux prompt a lot more, because it's easier to remember that
I rename sessions with <code>rename-session</code> than it is to remember I rename
sessions with <code>Ctrl+b $</code></aside>

    </section>
    <section>

<img alt="Tmux window showing command line open" src="sessions-12-command-open.png">

<h2 class="fragment absolute-center solarized-search-text nowrap">
    :<kbd class="fragment">rename-session</kbd>
    <kbd class="fragment">talk</kbd>
</h2>

<aside class="notes">So we just need to type &gt;&gt; Ctrl+b, colon... &gt;&gt; <code>rename-session</code> and
then the session's name. &gt;&gt; Let's call it &quot;talk&quot;.</aside>

    </section>
    <section>

<img alt="Tmux window showing 'rename-session' command
typed-in" src="sessions-13-rename-command.png">

<aside class="notes">Then when we run that command...</aside>

    </section>
    <section>

<img alt="Tmux window showing new session name" src="sessions-14-renamed.png">

<aside class="notes">our session is renamed.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting session
name" src="sessions-14.1-name-highlight.png">

<aside class="notes">... our new name shows up in the bottom
left.</aside>

    </section>
    <section>

<img alt="Terminal window showing &lt;code&gt;tmux ls&lt;/code&gt; output with new session
name" src="sessions-15-tmux-ls-new-name.png">

<aside class="notes">It now also shows up in <code>tmux
ls</code>...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Terminal window showing &lt;code&gt;tmux ls&lt;/code&gt; output with new session name
highlighted" src="sessions-15.1-tmux-ls-name-highlight.png">

<aside class="notes">... with our new name.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Terminal window showing &lt;code&gt;tmux ls&lt;/code&gt; output with attached
highlighted" src="sessions-15.2-tmux-ls-attached-highlight.png">

<aside class="notes">Also notice that <code>tmux ls</code> tells us that this session is attached.
I took this screenshot in another window while my other window was
attached to this session.</aside>

    </section>
    <section>

<img alt="Terminal window showing &lt;code&gt;tmux new&lt;/code&gt; typed in" src="sessions-16-tmux-new-s.png">

<div class="fragment absolute-center bg-solarized">
    <h2>
        <kbd>tmux new-session</kbd>
    </h2>
</div>

<aside class="notes">We can also create new sessions with a name by using &gt;&gt; <code>tmux
new-session</code> </aside>

    </section>
    <section>

<img alt="Terminal window showing &lt;code&gt;tmux new&lt;/code&gt; typed in" src="sessions-16-tmux-new-s.png">

<div class="absolute-center bg-solarized">
    <h2 class="nowrap">
        <kbd>tmux new
            <span class="fragment">-s</span>
            <span class="fragment">bugfix</span>
        </kbd>
    </h2>
</div>

<aside class="notes">... (or, for brevity, &gt;&gt; <code>tmux new</code>). &gt;&gt; The <code>-s</code> option lets us
specify a &gt;&gt; name when we create the session.</aside>

    </section>
    <section>

<img alt="Tmux window showing 'bugfix' session
name" src="sessions-17-bugfix-session.png">

<aside class="notes">And now we have a session named &quot;bugfix&quot;</aside>

    </section>
    <section>

<h1>Session Organization</h1>

<aside class="notes">I use sessions a lot. My current job has me bouncing around between
tickets 4-5 times per day. Each ticket touches different files and has
different tests.</aside>

    </section>
    <section>

<img alt="Terminal window showing tmux ls with multiple
sessions" src="sessions-18-ticket-names.png">

<aside class="notes">So, for each ticket I start working on, I create a new session, named
after the ticket. Then I can attach to the session I want to work on,
do a bunch of work, and when I get interrupted to do some quick work on
another ticket, my workspace is safe in my Tmux session. This has helped
reduce the inertia of context-switching for me.</aside>

    </section>
    <section>

<h1>Naming Windows</h1>

<aside class="notes">In addition to naming sessions, Tmux also lets you name windows.</aside>

    </section>
    <section>

<img alt="Tmux window showing vim and zsh windows" src="naming-1-tmux-window.png">

<aside class="notes">Like I may have mentioned before, windows are generally named with the
program that's currently running</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the vim window" src="naming-1.1-vim.png">

<aside class="notes">This window is running vim, my editor.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the zsh window" src="naming-1.2-zsh.png">

<aside class="notes">And this window is running zsh, my shell.</aside>

    </section>
    <section>

<img alt="Tmux window showing vim and zsh windows" src="naming-1-tmux-window.png">

<aside class="notes">This is a pretty useful default, but let's create a new window.</aside>

    </section>
    <section>

<img alt="Tmux window showing vim and 2 zsh windows" src="naming-2-too-many-shells.png">

<aside class="notes">Now I have two windows named
&quot;zsh&quot;.</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window showing vim and 2 zsh windows" src="naming-2.1-zshs.png">

<aside class="notes">Which is which? Which one am I using to run my tests, and which one am
I using to look up documentation?</aside>

    </section>
    <section>

<img alt="Tmux window showing vim and 2 zsh windows" src="naming-2-too-many-shells.png">

<div class="fragment absolute-center bg-solarized">
    <h1>
        <kbd>Ctrl+b ,</kbd>
    </h1>
    <h2 class="fragment solarized-search-text nowrap">
        <kbd>:rename-window</kbd>
    </h2>
</div>

<aside class="notes">To rename a window, we can use &gt;&gt; <code>Ctrl+b</code> and comma, or the &gt;&gt;
rename-window command. This one I use so often that I remember the
shortcut.</aside>

    </section>
    <section>

<img alt="Tmux window showing (rename-window) command prompt" src="naming-3-rename-prompt.png">

<h2 class="fragment absolute-center solarized-search-text nowrap">
    <kbd>(rename-window)</kbd>
    <span style="position: relative; display: inline-block; width: 3.5em; text-align: left;">
        <kbd class="fragment">zsh</kbd>
        <kbd class="fragment" style="position: absolute; top: 0; left: 0; right: 0; bottom: 0; background: rgb( 180, 136, 29 );">edit</kbd>
    </span>
</h2>

<aside class="notes">Then, in the command prompt, we delete the current name and add our
own. Now the window will stay this name, even if we run a different
program in it.</aside>

    </section>
    <section>

<img alt="Tmux window showing windows named &quot;edit&quot;, &quot;test&quot;, and
&quot;docs&quot;" src="naming-4-renamed-windows.png">

<aside class="notes">Now I can easily remember...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the &quot;edit&quot; window" src="naming-4.1-edit.png">

<aside class="notes">... which window has my editor...</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the &quot;test&quot; window" src="naming-4.2-test.png">

<aside class="notes">... which window is for tests</aside>

    </section>
    <section data-background-color="#111">

<img alt="Tmux window highlighting the &quot;docs&quot; window" src="naming-4.3-docs.png">

<aside class="notes">... and which is for docs...</aside>

    </section>
</section>
<section>
    <section>

<h1>Automation</h1>

<aside class="notes">Eventually (longer than it should have taken) I realized that I was
doing the same thing over and over again. When this happens, I've
learned to examine my process and see if something can be
automated.</aside>

    </section>
    <section>

<h1>Tmux Session</h1>

<aside class="notes">In this case, I was creating the same Tmux sessions with the same
windows running the same programs over and again</aside>

    </section>
    <section>

<h3 class="absolute-center">Blog Session</h3>

<img alt="tmux session named &quot;blog&quot; with one window, editor on the left, shell
on the right" src="automation-1-blog-session.png">

<aside class="notes">When writing blog posts, I need a single window with my editor on one
side and a shell to run my website locally for testing.</aside>

    </section>
    <section>

<h3 class="absolute-center">Backend Session</h3>

<img alt="tmux session named &quot;backend&quot; with one window named &quot;edit&quot;, and another
named &quot;test&quot;" src="automation-2-backend-session.png">

<aside class="notes">When working on the CPAN Testers backend, I prefer having one window
for my editor, so I can open multiple panes of code, and another window
for tests so I can quickly switch between testing and editing.</aside>

    </section>
    <section>

<h3 class="absolute-center">CMS Session</h3>

<img alt="tmux session named &quot;yancy&quot; with three windows, &quot;edit&quot;, &quot;test&quot;, and
&quot;db&quot;" src="automation-3-yancy-session.png">

<aside class="notes">And when working on Yancy, my CMS, I need one window for editing, one
for testing (with one pane for automated tests and one pane for a demo
site), and a third window to run two databases I support: Postgres and
MySQL. The tests require some environment variables as well.</aside>

    </section>
    <section>

<h1>Tedious Setup</h1>

<aside class="notes">If I had to do this every day, I'd go nuts. Even if I had to do it
weekly, I'd get frustrated.</aside>

    </section>
    <section>

<h1>Don't Forget!</h1>

<aside class="notes">Worse, in the last example, if I forgot to set everything up correctly,
I might fail my tests, or not run all my tests, resulting in releasing
bad code, which will start a fire and we'd all die.</aside>

    </section>
    <section>

<h1>Automatic Session</h1>

<aside class="notes">So, to prevent this, I can automate the setup of my Tmux session.</aside>

    </section>
    <section>

<h1>Tmux Commands</h1>

<aside class="notes">And we do that using Tmux commands. We've used Tmux commands to rename
sessions and windows, to move between panes, and to configure Tmux key
bindings. Tmux also has commands to create windows and panes, which
we've used the default key bindings to do.</aside>

    </section>
    <section>

<h1>Run</h1>

<h1>Tmux Commands</h1>

<h1>Anywhere</h1>

<aside class="notes">But we don't need to be inside Tmux to run Tmux commands. We can run
Tmux commands for any of our running sessions from outside of Tmux. This
way, we can run a bunch of commands to set up our session before we
attach to it!</aside>

    </section>
    <section>

<img alt="Empty shell window" src="automation-4-empty-shell.png">

<div class="absolute-center bg-solarized">
    <h2 class="nowrap">
        <kbd>tmux new
            <span class="fragment">-s yancy</span>
            <span class="fragment">-d</span>
        </kbd>
    </h2>
</div>

<aside class="notes">So I create a new session, name it "Yancy", and
then pass <code>-d</code> to immediately "detach".</aside>

    </section>
    <section data-transition="slide-out">

<img alt="Shell window with &quot;tmux new&quot; command executed&quot;" src="automation-5-new-session.png">

<aside class="notes">And... nothing happened. I'm back at my shell
prompt.</aside>

    </section>
    <section data-transition="slide-in slide-out">

<img alt="Shell window with &quot;tmux ls&quot; command executed&quot;" src="automation-6-tmux-ls.png">

<aside class="notes">But my session was created. Now, I can run other
commands to build my session.</aside>

</section><section>

<h1>Shell Script</h1>

<aside class="notes">And since I'll be doing this a lot, I can write
a shell script to do it for me.</aside>

</section><section>

<div style="text-align: left; font-size: 80%" class="bg-solarized"><code>
<span class="fragment" data-fragment-index="8">if ! tmux has-session -t yancy; then</span><br>
tmux new -s yancy -d<br>
<span class="fragment" data-fragment-index="1">&nbsp;&nbsp;tmux new-window -t yancy:2</span><br>
<span class="fragment" data-fragment-index="2">&nbsp;&nbsp;tmux split-window -t yancy:2 -v</span><br>
<span class="fragment" data-fragment-index="3">&nbsp;&nbsp;tmux send-keys -t yancy:1 vim Enter</span><br>
<span class="fragment" data-fragment-index="4">&nbsp;&nbsp;tmux send-keys -t yancy:2.0 \<br>&nbsp;&nbsp;&nbsp;&nbsp;morbo bin/yancy Enter</span><br>
<span class="fragment" data-fragment-index="5">&nbsp;&nbsp;tmux send-keys -t yancy:2.1 \<br>&nbsp;&nbsp;&nbsp;&nbsp;export TEST_YANCY_EXAMPLES=1 Enter</span><br>
<span class="fragment" data-fragment-index="6">&nbsp;&nbsp;tmux new-window -t yancy:3 \<br>&nbsp;&nbsp;&nbsp;&nbsp;postgres -D perl/Yancy/db/pg</span><br>
<span class="fragment" data-fragment-index="7">&nbsp;&nbsp;tmux split-window -t yancy:3 \<br>&nbsp;&nbsp;&nbsp;&nbsp;mysqld --datadir=$HOME/db/mysql</span><br>
<span class="fragment" data-fragment-index="8">fi</span><br>
<span class="fragment" data-fragment-index="9">tmux attach -t yancy</span>
</code></div>

    </section>
    <section>

<h1>Other Solutions</h1>
<h2 class="fragment">Tmuxifier</h2>
<h2 class="fragment">Teamocil</h2>

<aside class="notes">There are some existing solutions for building Tmux sessions, if you
don't want to manage it yourself.</aside>

    </section>
</section>
<section>

<h1>Wrap-Up</h1>

</section>
<section>

<h1>Questions?</h1>
<ul>
<li>Full slides: <a href="http://preaction.me/tmux">http://preaction.me/tmux</a></li>
</ul>
<div style="text-align: center">
    <a href="http://preaction.me">
        <img src="http://preaction.me/images/avatar-small.jpg" style="display: inline-block; max-width: 100%"/>
    </a>
</div>
</section>

</div>
