# Short intro to elm

---

## What is elm?

***Elm is a domain-specific programming language for declaratively creating web browser-based graphical user interfaces. Elm is purely functional, and is developed with emphasis on usability, performance, and robustness.***

Tools

- elm repl : repl
- elm reactor : development server
- elm make : compiler
- elm package : package manager

---

### In practice

- Null safe(No runtime error. 'undefined is not a function' can't happen)  <!-- .element: class="fragment fadeIn"  -->
- Compiler Errors for Humans <!-- .element: class="fragment fadeIn"  -->
- Mostly one way to do it(Hard to write bad code) <!-- .element: class="fragment fadeIn"  -->
- All in one (redux/ramda.js/flow.js/data.maybe/immutable.js ...) <!-- .element: class="fragment fadeIn"  -->

---

## Examples

- [Examples](http://elm-lang.org/examples)
- [Mario](http://debug.elm-lang.org/edit/Mario.elm)
- [elm-todomvc](https://github.com/evancz/elm-todomvc)

---

## Elm architecture

<img src="https://guide.elm-lang.org/architecture/effects/beginnerProgram.svg" width='80%' style="background: white;" />

- Model -  the state of your application
- Update -  a way to update your state
- View - a way to view your state as HTML

---

http://elm-lang.org/examples/buttons

```
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = Int

model : Model
model =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (toString model) ]
    , button [ onClick Increment ] [ text "+" ]
    ]
```

---

## Types

<!-- .slide: class="list-left-aligned" -->

```
type Message = Increment | Decrement
```
<!-- .element: class="fragment fadeIn"  -->

- type Message is either Icrement or Decrement.
<!-- .element: class="fragment fadeIn"  -->

```
type User = Anonymous | Named String
```
<!-- .element: class="fragment fadeIn"  -->

- Type User is either Anonymous, or String
<!-- .element: class="fragment fadeIn"  -->
- Named is also a constructor, and used for creating the value(Named "John")
<!-- .element: class="fragment fadeIn"  -->

```
type Tree a = Empty | Node a (Tree a) (Tree a)
```
<!-- .element: class="fragment fadeIn"  -->

- represents a binary tree
<!-- .element: class="fragment fadeIn"  -->
- type Tree is Either Empty, or a node of kind 'a' (convention for any type)
<!-- .element: class="fragment fadeIn"  -->

---

## Record

<!-- .slide: class="list-left-aligned" -->

```
{ title = "Steppenwolf", author = "Hesse", pages = 237 }
```

- Labeled light weight structure

```
type alias Point =
  { x : Float
  , y : Float
  }
```

- Type alias to define record structure

```
{ point2D | y = 1 }           -- { x=0, y=1 }
{ point3D | x = 0, y = 0 }    -- { x=0, y=0, z=12 }
{ steve | name = "Wozniak" }  -- { name="Wozniak", age=56 }
```

- Update fields

---

## Pattern Matching

<!-- .slide: class="list-left-aligned" -->

```
type Message = Increment | Decrement | Restore Int | NoOp

case msg of
  Increment -> "increment"
  Decrement -> "decrement"
  Restore count -> toString count
  _ -> ""
```

- _ to capture the other patterns
- Compiler detects non-exhausive conditions


```
type alias Coupon = {
  id: String,
  expireDate: Maybe String
}
let
  coupon = { id = "abc", expireDate = Just "2016-12-12" }
in
  case coupon.expireDate of
    Just date -> date
    Nothing -> "" -- (oneliner) Maybe.withDefault "" coupon.expireDate
```

---

## Pattern Matching

```
maximum : List comparable -> Maybe comparable
maximum list =
  case list of
    x :: xs ->
      Just (foldl max x xs)

    _ ->
      Nothing
```

- Destructure list element and assign variables(x for first elment, xs for the rest elements)
- [Elm Destructuring (or Pattern Matching) cheatsheet](https://gist.github.com/yang-wei/4f563fbf81ff843e8b1e)

---

## Effects

<img src="https://guide.elm-lang.org/architecture/effects/program.svg" width='60%' style="background: white;" />


- Commands
  - A Cmd lets you do stuff
- Subscriptions
  - A Sub lets you register that you are interested in something

---

### Command

```
type Msg = Click | NewBook (Result Http.Error String)

type alias Model = String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Click ->
      ( model, getWarAndPeace )
    NewBook (Ok book) ->
      ( book, Cmd.none)
    NewBook (Err _) ->
      ( model, Cmd.none)

getWarAndPeace : Cmd Msg
getWarAndPeace =
  let
    request = Http.getString NewBook "/"
  in
    Http.send request
```

- Pass commands to elm runtime
- When a command finishses, update is called with Result type

---

## Tips

---

### Split nested conditions into modules

<!-- .slide: class="list-left-aligned" -->

```
type Msg =
         ....
				 | OrderList
         | OrderDetail String
         | OrderSearch String

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ...
    OrderList ->
      ...
    OrdersDetail orderId ->
      ...
    OrderSearch productName ->
      ...
```

- branches gets longer and longer

---

### Split nested conditions into modules(cond)

<!-- .slide: class="list-left-aligned" -->

```
type Msg = 
         ...
				 | OrderMessage Order.Msg

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ...
    OrdersMessage subMessage ->
      let
       (orderModel, orderMessage) = Orders.Update.update subMessage model.order
      in
       ({model|order=orderModel}, Cmd.map OrdersMessage orderMessage)
```

- Split branches into sub modules

---

### Use infix operators to improve readability

<!-- .slide: class="list-left-aligned" -->


```
ngon 5 30
  |> filled blue
  |> move (10,10)
  |> scale 2
```

- forward function application
-  ```arg |> func``` == ```func arg```
- cleaner than below

```
scale 2 (move (10,10) (filled blue (ngon 5 30)))
```

- args comes first(left side), and |> is left-associative(meaning a |> b |> c |> d is ((a |> b) |> c) |> d )
- That's why we don't need to specify precedence with parentheses

---

### Use infix operators to improve readability(Cond)

<!-- .slide: class="list-left-aligned" -->

```
leftAligned <| monospace <| fromString "code"
```

- backwoard function application
- ```func <| arg``` == ```func arg```

```
leftAligned (monospace (fromString "code"))
```

- ```<|``` is right-associative(meaning ```a |> b |> c |> d``` is a ```|> (b |> (c |> d))``` )

---

### Use compiler to guide coding

---

### Duplication over reusability

---

