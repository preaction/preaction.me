---
title: Mark Todo Completed - Todo App - Yancy Tutorial
links:
    prev:
        href: display-todo-list.html
        title: 6. Display the to-do list
    next:
        href: bootstrap.html
        title: 8. Design a UI with Bootstrap
template: tutorial-page.html
---

Once we've displayed our to-do list, we need to be able to mark our
to-do items as completed. We will turn each of our todo log entries into
a form with a button. Clicking on the button will mark the item as
completed, or, if it's already completed, will mark it as incomplete (in
case we mistakenly complete something we haven't done).

First, we should build a route to mark an entry as completed. This will
be a `POST` request, so we use the `post` function. We're going to put
the ID of the log entry in the URL to make it REST-like.

    post '/log/:log_id' => sub {
        my ( $c ) = @_;

The `:` in the route path introduces a placeholder. The text following
the `:` is where Mojolicious will save the value in the `stash`, which
is a general storage area for the current request. So, we can get the ID
out using the `stash()` method of the controller object.

        my $id = $c->stash( 'log_id' );

Our form will have a button that will have a value of true (`1`) or
false (`0`) if we are marking the item as complete or incomplete. Form
values are retrieved by using the `param()` method of the controller
object. If the item is complete, we want to store the date that the item
was completed. Otherwise we want to set the completed date to `null`
(from the Perl side, we use `undef`).

        my $complete = $c->param( 'complete' )
            ? DateTime->today->ymd
            : undef;

Then we can execute a SQL `UPDATE` query to update our log entry.

        my $sql = 'UPDATE todo_log SET complete = ? WHERE id = ?';
        $c->pg->db->query( $sql, $complete, $id );

Finally, we redirect the user back to where they were, our `index` page,
with the `redirect_to()` method.

        return $c->redirect_to( 'index' );

This route needs a name, so we'll give it a name of `update_log`. We're
going to use this name to build a form that gets submitted to the right
URL.

Down in our template, rather than displaying an unordered list, now
we're going to render a form for every item in the list.

    @@ index.html.ep
    %% layout 'default';
    %% title 'Welcome';
    <h1><%%= $date->ymd %></h1>
    %% for my $item ( @$items ) {
        %%= form_for 'update_log', { log_id => $item->{id} }, begin
            %%= $item->{title}
            %% if ( !$item->{complete} ) {
                <button name="complete" value="1">Complete</button>
            %% }
            %% else {
                <button name="complete" value="0">Undo</button>
            %% }
        %% end
    %% }

This uses the `form_for` helper. Helper functions are also available in
every template (making them truly helpful). The `form_for` helper is
part of a set of helpers installed by default called the TagHelpers. It
takes the name of a route, a hash reference of placeholder values (in
this case, we need to give it the ID of the log entry), and then we use
the `begin` function.

The `begin` function allows us to add a template as an argument to
a function. The `end` function marks the end of the content, and then
the whole thing is given to the original function (in this case,
`form_for`). In this way, the `form_for` function will wrap our content
in `<form>` HTML tags.

Inside our form we print out the text of the todo item.

Finally, we add the button. If the item is not completed, we'll make
a button that marks the item as complete. If the item is completed,
we'll make a button that marks the item as incomplete.

Now we can see our button and click on it to complete our to-do list!

![The todo list with complete/undo
buttons](mark-todo-completed.png)

