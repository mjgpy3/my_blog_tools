I just started learning Go recently and I must say, it's been a lot of fun. The first real difficulty I've had with the language has been trying to use reflection to set a field on a `struct`, inside of a function. I found some decent examples, but none that were quite fitting, so I thought I'd share my solution here.

So, just for the fun of it, let's say we have a `struct` that we know will "always" have a field `Brewery`:
```
type Beer struct {
    Brewery string
}
```

Note that `Brewery` is `public` (sorry for the term, my non-Go experience is showing).

Now let's say we want to create a function that always sets the `Brewery` to `"Dogfish Head"`, but we want it to operate on the general interface and use reflection (for whatever reason):
```
import "reflect"

func breweryToDFH(thing interface{}) {
    reflect.ValueOf(thing).
        Elem().
        FieldByName("Brewery").
        SetString("Dogfish Head")
}
```

Finally, to call it, a pointer must be used, e.g.
```
beer := Beer{}
breweryToDFH(&beer)
```

And *that's all!* As one coming from the dynamicity of Ruby, this seems kind of roundabout. So if you know a way to simplify, please feel free to comment. Also, there is a good deal of error handling that should be done here, so for that, I will defer to a [stackoverflow post]{http://stackoverflow.com/questions/6395076/in-golang-using-reflect-how-do-you-set-the-value-of-a-struct-field}.

Happy "Go-ing"!
