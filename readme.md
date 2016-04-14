# Redux workshop
## Introduction

README.md


# Task 1: Basic Redux application flow

In this section we'll set up a really simple app from scratch. You'll keep track of a single number starting at zero, incrementing it once for every click inside the browser window. We'll break this rather simple task into four steps, demonstrating the core redux concepts of a store, actions and reducers.

* Step 1: Creating a store
* Step 2: Retrieving the state
* Step 3: Changing the state
* Step 4: Subscribing to store change and re-rendering

## Step 1: Creating a store.

We need a store. Redux advocates having all your application data in a single object structure, but we'll need some layer of abstraction instead of just using a plain old javascript object.

`redux` gives us a convenient method - `createStore`.

Use this to get yourself a shiny new store, ready to be filled with our application data.
Try to call `createStore` without any params initially, and check the browser console.

You'll see an error message. In the far left there's a reference to the file and line number that produced the error message.
Click it to enter the `redux` source code to see what `createStore` was expecting.

--

Ok, so `createStore` is expecting this thing called a reducer as the first argument, which apparently is a function.
The reducer is a core concept in redux - they are functions that describe how your state is changed, or mutated, as we like to say.

The function signature for a reducer looks like this:

`(state, action) => state`

Let's create a simple function just to get our store up and running. This example will serve our purpose:

```
function reducer(state=0, action) {
    return state;
}
```

For now, this function will serve as placeholder and won't actually do anything. Note how we use the default parameter syntax of ES2015 to indicate that the initial state value of this reducer should be the number zero.

Let's try creating that store again:

```
createStore(reducer)
```

Success! 
Well, we still have a white page, so we're not quite finished yet.
Let's print the number in our store to the screen.

## Step 2: Retrieving the state from the store

The `store` object has a function `getState` that's used to retrieve the current state.
We'll use the good, old DOM API to 

```
document.body.innerText = store.getState();
```

Great! Now we've initialized a store object to contain all our data, created a simple pass-through reducer that describes our state mutations and rendered the store content to the DOM.The next logical step from here would be to perform changes to our state. 

## Step 3: Changing our state

We'll use another function on `store`  - the `dispatch` function. This function enables us to declaratively say that something has happened in our app. This would be some user interaction, e.g a button was clicked, or something timed out, or basically whatever action that might require us to update our state.

Let's try doing that dispatch thing:

```
store.dispatch()
```

Check the console again. Redux states how an action needs to be a plain javascript object. Try entering the source code again to have a look at what else Redux expects from our actions.

You'll see that the `type` property on our actions are used to distinguish between different kinds of actions.
Next, let's create and dispatch an action:

```
store.dispatch({ type: 'USER_CLICKED' })
```

It's kinda lame saying the user clicked something when we obviously didn't, so we'll have to add an event listener:


```
document.addEventListener('click', () => store.dispatch({ type: 'USER_CLICKED' }));
```

Click the white background of the browser window to see what happens!

...not much, so far.
Our reducer function actually gets the action passed in as the second argument, so why don't you go ahead and `console.log` the action parameter inside your reducer.

You'll see that upon creating the store, redux will trigger an action called `@@redux/INIT` which is used to set up the initial state in your reducer. Upon clicking the window, you'll see your own `USER_CLICKED`-actions appear.

The last thing we need to do in order to complete the Redux cycle is to update the state. 

This involves making our reducer react to certain types of actions - `'USER_CLICKED'`, for instance.
Use an `if`-statement in your reducer to increment the state.

Running your app with these additions yields disappointing results in the browser. The problem is that even tho we are updating the value of our state, we're not rendering this new state to the page. This brings us to the fourth and final step of the cycle:

### Step 4: Subscribing to store change and re-rendering

Lets refactor our rendering method into its own function:

```
function render() {
    document.body.innerText = store.getState();
}
```

All thats left now is to use the final API-method on the `store` object - `subscribe` to rerender on every change.
Make sure you still render the initial state upon app startup by calling render manually.

```
store.subscribe(render);
```

That's it!
This is basically all there is to Redux.

Of course, this example app is trivial and only serves to help explain the core Redux concepts.
Over the course of the next tasks, we'll start handling a larger datastructure instead of just a single number and use React as the rendering engine.

## Task 2: Rendering with React

React is a wildly popular frontend library by Facebook for creating graphical user interfaces. Hopefully you've got some experience with React before starting this workshop, but if that's not the case - fear not! React, when used with Redux, it pretty simple and can be learned pretty quickly.

### A very brief overview of React

React allows us to express our GUI as a series of functions. These functions can be seen as transformations that accept some sort of data structure as input and return a representation of how that data structure should be rendered in HTML. We typically refer to these functions describing our GUI as "components" or just "React components".

Here an example of a component:

```
function MyCoolComponent(props) {
    return <div>Hello World</div>
}
```

Whoa, what was that? HTML in my JavaScript? Get outta here, you fish-eyed swashbuckler!
Long story short, this syntax called JSX allows us to transpile what looks like HTML into function calls that in turn will return objects describing HTML.

```
<div class="ninja">
Hello World!
</div>
```

would be represented as a data structure in this manner:

```
{
    type: 'div',
    props: {
        className: 'ninja'
    },
    children: ['Hello World!']
}
```

### Creating a component

Lets dive right in an create a simple React component that we'll use to render a Tweet later on.

```
function Tweet(props) {
    return <div>This will totally contain a tweet later!</div>
}
```



### Task 7
#### a)
To make our twitter stream a bit more interesting, we can implement a filtering mechanism.
Let's say we filter the tweets based on text and hashtags.
This way we can use the map to see in what parts of the world they talk about "Trump" for instance.
Create a filter reducer that consists of an array of filters with the following data structure:
```
{
  color: 'yellow',
  name: 'Trump',
  text: 'Trump',
  hashtags: ['Trump'],
  active: true
},
```
The color indicates the marker color. The active flag indicates if the filter is turned on or off.
For now, the only case the reducer will handle is `FILTER_ACTIVE_TOGGLE`.
Create the corresponding action creator.

Create a Filter component :

```javascript
function Filter({ name, color, active}) {
  const className = active ? '' : 'inactive';
  return (
    <span className={ className } onClick = {() => console.log('filter click')}>
      <div className={`circle ${color} ${className}`}/>
      { name }
    </span>
  );
}

Filter.propTypes = {
  name: PropTypes.string.isRequired,
  active: PropTypes.bool,
};

function FilterList({ filters}) {
  return (
    <ul className="filterList">
      { filters.map(f =>
        <li key={ f.name }>
          <Filter
            {...f}
          />
        </li>)}
    </ul>
  );
}

FilterList.propTypes = {
  filters: PropTypes.array.isRequired,
  onFilterActiveChange: PropTypes.func.isRequired
};
```
Create a file with the `FilterList` component and let this component be a child of the `Map` and `Feed` components.
Pass the state from your newly created `filters` reducer down to the `FilterList` component.
Remember to combine the new reducer in the `reducers/index.js` file.
You may want to put some initial state data into the reducer, for instance the Trump filter, so that you have some data to work with in the UI.
When the filter list is successfully displayed on both routes, you can start on the onClick handler of the `Filter` component.
When you click on a filter, you should be able to toggle the active flag.

#### b)
Now it is time to actually filter the tweets.



