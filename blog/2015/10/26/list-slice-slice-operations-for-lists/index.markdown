---
tags: perl, cpan
title: 'List::Slice - Slice operations for lists'
links:
    canonical:
        href: http://blogs.perl.org/users/preaction/2015/10/listslice---slice-like-operations-for-lists.html
        title: blogs.perl.org
---

How many times have you needed to do this?

    my @found_names = grep { /^[A-D]/ } @all_names;
    my @topfive = @found_names[0..4];

Or worse, this.

    my @topfive = ( grep { /^[A-D]/ } @all_names )[0..4];

![There's got to be a better way](cheetos.gif)

Or this.

    my @bottomfive = @names < 5 ? @names : @names[$#names-5..$#names];

Or this.

    my @names
            = map { $_->[0] }
            sort { $a->[1] <=> $b->[1] }
            grep { $_->[1] > $now }
            map { [ $_->{name}, parse_date( $_->{birthday} ) ] }
            @all_users;
    my @topfive = @names[0..4];

There's got to be a better way!

![There's got to be a better way](cheetos-2.gif)

Now there is! Introducing: [List::Slice](http://metacpan.org/pod/List::Slice)!

---

With [List::Slice](http://metacpan.org/pod/List::Slice), you can grab
the front or back of any list without clumsy syntax or wasteful arrays.

Get the first elements of a list with the `head` function.

    use List::Slice qw( head );
    my @topfive = head 5, grep { /^[A-D]/ } @all_names;

Get the last elements of a list with the `tail` function.

    use List::Slice qw( tail );
    my @bottomfive = tail 5, @names;

You can even insert functions in to the middle of long stream processes
to improve performance! Why deref things that will just be thrown away?

    use List::Slice qw( head );
    my @topfive
            = map { $_->[0] }
            head 5,
            sort { $a->[1] <=> $b->[1] }
            grep { $_->[1] > $now }
            map { [ $_->{name}, parse_date( $_->{birthday} ) ] }
            @all_users;

Stop taking up useless space with arrays that are sliced once and
discarded. Stop searching for postfix slice syntax around lengthy list
processing operations.

Slice your lists, with
[List::Slice](http://metacpan.org/pod/List::Slice)!

