Lately I've been looking into ways of [DRY]{http://en.wikipedia.org/wiki/Don%27t_repeat_yourself}-ing up ruby classes. One of the first, and perhaps most scarily powerful, is the `class_eval` method.

# What does it do?
`class_eval` takes in a block or a string and executes it at the class-level. It's that simple!

# Is it useful?
Yeah, it's scary useful. Here's an example where I you can define a bunch of similar methods on a class:
```
foobar
```

This short little example used `class_eval` to define *6* methods on the person class: `with_age`, `and_age`, `with_name`, `and_name`, `with_favorite_color` and `and_favorite_color`! Pretty cool, huh?
