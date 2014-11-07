Lecture/Lab 9: Authentication
=====

The app from last week is functional but has huge security issues! Let's fix
them in our extended lab for this week.

First, find a partner! You and your partner will alternate between questions.
Pretend it's your actual project by branching, commititng, making a pull
request, and having your partner merge it in before starting on the next
question.

Designate one person as person A, and the other as person B.
Follow these steps as person A:
- Make a new empty repo called `lab9` on github
- `git clone (this railsdecal repo)`
- `git remote rm origin`
- `git remote add origin https://github.com/<your username/lab9`
- `git push origin master`
- 
Then on Github go to Settings -> Collaborators, and add
person B to the repo.

Now partner B should run

    git clone https://github.com/<partner A username>/lab9

to start working on the app. There is a written portion of this lab, so write
down your answers in ```lab9.txt``` and [submit them through the form](https://docs.google.com/forms/d/1wP6s8MEMzYgTYUKYeBcABGCi664EwrNLq763nCogTSg/viewform)!

1. Make your first pull requests! Both teammates should edit the README.md file
so that the blank "Person A:" lines have the person's name. At the end the two
blank lines above should look like:

    Person A: Sam Lau

    Person B: Jessica Lin

    Start with ```git checkout -b <readme-A or readme-B>```. The ```-b``` option
    to ```git checkout``` tells git to make a new branch and switch to it right
    away. Then make your changes, add, commit, and push to person A's Github.
    Make a pull request for your changes, and have the other person merge it
    into master. Congratulations! You just made your first pull request.

2. _(Person A codes)_ Remember how we included
[devise](https://github.com/plataformatec/devise) in step 2 of the lecture app?
We never actually had the user sign in at any point! Since devise is already set
up we should be able to log in. Test it out by first finding the route that ends
in ```/sign_in``` using ```rake routes``` and visiting it in your browser.

    a. What happens when you log in? What happens if you try to log in again? Does
    it work as you expect?

    Let's now add log in and log out links to the navbar so it's easier to see
    when we're logged in. [Devise has some helpers](https://github.com/plataformatec/devise#controller-filters-and-helpers) that allow you to check if a user is signed in or not, we'll
    have to use them now.

    b. What is the helper that devise creates that checks if a user is logged in
    or not?

    Add two ```<li>``` elements below the existing link to 'Users' in
    ```application.html.erb``` that link to the sign in/out paths depending on
    if the user is signed in (only one of those li elements will be visible at
    any time to the user). You should add 5-6 lines of extra code.

3. _(Person B codes)_ So now we have logging in and out. Now we want to make
sure that if a user is not signed in that we only allow them to view the sign in
page - all pages should redirect to the sign in page if there isn't a signed in
user.

    a. How would you go about implementing this with the knowledge you have now?
    (If you know about ```before_filter``` you can't use it - that's coming up.)

    Luckily Rails provides a handy ```before_filter``` method! It takes in a
    procedure name as a symbol as an argument and runs that procedure before any
    of the actions in the controller are hit (if you want to limit the methods
    that it runs before, ```before_filter``` takes in another argument, ```except```.
    See the docs for more info.) which is exactly what we need! Devise also has
    a handy method to redirect someone to the log in page if they aren't logged
    in; how convenient. Write _one_ line of code in ```application_controller.rb```
    that enforces a signed in user. Hint: you should probably check the devise
    docs again.

    b. Why does that line of code work for all actions in all controllers?

4. _(Person A codes)_ As you may have noticed, the app isn't very informative
when you try to visit a page without signing in: it just throws you back to the
sign in page without any explanation. And, if you log in with bad credentials
nothing shows up to tell you you messed up. It turns out that devise is trying
to tell the user that something messed up but you aren't showing it! Stick a
```<%= 1/0 %>``` somewhere in ```application.html.erb``` and try visiting the
home page while not logged in.

    a. In the console in the error page, check the value of ```flash```. What do
    you notice about it?

    In general, we use ```flash``` to store temporary messages we want to show
    the user only once. We've actually used it in ```quits_controller.rb``` to
    tell the user that a quit was updated. ```flash``` is a hash where the key
    is the type of message and the value is the message. Devise does
    ```flash[:alert] = '<some message>'``` when you try to visit a page while
    not logged in, so let's show the user that message.

    Write 3 lines of code right above the ```yield``` statement in ```application.html.erb```
    that loops through each key-value pair in ```flash``` and outputs the
    following code where ```key``` is the key and ```value``` of each thing in ```flash```:

        <%= content_tag(:div, value, class: "alert alert-#{key}") %>

    You should now see pretty messages when you log in, update a quit, and more!

5. _(Person B codes)_ Remember how we allowed ```user_id``` to pass through in
the params and how it caused problems in the past? In fact, the way we
implemented quit creation in general isn't ideal since we're forced to pass the
user_id through the form. Since we're always going to create/update quits in the
context of a specific user, it makes more sense to route our app to make this
easier.

    a. Check the [Rails Guides](http://guides.rubyonrails.org/routing.html) for
    something related to routes that are made for a belongs_to/has_many
    relationship. What was the section title?

    Change ```routes.rb``` so that quits are nested under users. To verify that
    your answer is on the right track, the URL for a new quit should look like
    ```/users/:user_id/quits/new``` now (all the other quit routes will be
    changed too). You should have to modify/add very few lines of code, 2-3 at
    max.

    b. A lot of routes will now be broken! Why?

    Update the routes everywhere in the controllers/views so that they use the
    new routes which you just created. This is a difficult question since it
    involves multiple views/controllers! Start by changing all the old routes to
    new ones. If you're not sure if the routes work or not, you can always check
    them with a ```1/0``` and using the console that better errors starts.

    Hint: just like how we could do ```edit_quit_path(@quit)``` before,
    now we can do ```edit_user_quit_path(@user, @quit)``` given that @user
    and @quit are defined.

    Hint 2: Notice that a lot of routes have ```:user_id```. That means you can
    get the user related to that URL with ```User.find params[:user_id]``` and
    not have to worry about setting it manually in your routes.

    Hint 3: You'll get an error of 'undefined method `quit_path'' when you try
    to render the form view for a quit. To fix this, use ```simple_form_for [@user, @quit], ...```.
    Of course, this only works if @user and @quit are not nil.

    Hint 4: You'll make changes to 1 line in each view in the ```quits```
    folder, and 2 line changes in ```users/show.html.erb```. In
    ```quits_controller.rb```, you only have to add one line to the
    ```edit``` action and a one line addition + one line modification in the
    ```create``` action.

    Now you should be able to stop permitting ```:user_id``` in the ```quit_params```
    method of ```quits_controller.rb```. Verify that all actions still work
    correctly.


6. _(Person A codes)_ So we have some basic authorization going on since we
require a user to sign in before viewing quits. But, a logged in user can still
create/edit quits for other people! Verify this is true. Make changes to
```quits_controller.rb``` so that a person can only create/modify quits that
belong to him. If a person tries to create/change a quit that belongs to another
person, redirect hiim to the ```root_path``` with an alert message in flash
```"Can't create/edit a quit for another person!"```.

    a. Why don't we need to make changes to ```application_controller.rb```?

    b. Why don't we need to make changes to ```users_controller.rb```?

7. _(Person B codes)_ Now, if we have administrators, they should be able to
create and edit quits at will. First, we'll have to designate some users as
administrators. Create a migration that adds the ```:admin``` attribute to
users, and default it to false. After migration, create one admin in your seeds.
You can now do something like ```User.first.admin?```, which returns true or
false. Then make the necessary changes so that users who are admins can create
and edit quits of all users.

You made it! Submit the written portion of the lab [here](https://docs.google.com/forms/d/1wP6s8MEMzYgTYUKYeBcABGCi664EwrNLq763nCogTSg/viewform).
