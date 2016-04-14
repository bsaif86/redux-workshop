# Twitter Dashboard 2.0: Redux Revisited

## Table Of Contents



## Task 1: Basic Redux application flow

In this section we'll set up a really simple app from scratch. You'll keep track of a single number starting at zero, incrementing it once for every click inside the browser window. We'll break this rather simple task into four steps, demonstrating the core redux concepts of a store, actions and reducers.

* Step I: Creating a store
* Step II: Retrieving the state
* Step III: Changing the state
* Step IV: Subscribing to store change and re-rendering

We'll also add a final step where we introduce React and use it to render our simple counter app.

* Step V: Using React to render the app

We'll be doing these tasks in the file `src/index.js` in the project root.

### Step I: Creating a store.

We need a store. Redux advocates having all your application data in a single object structure, but we'll need some layer of abstraction instead of just using a plain old javascript object.

Redux gives us a convenient function, namely `createStore()`.

Use this to get yourself a shiny new store, ready to be filled with our application data.
Try to call `createStore` without any parameters initially, and check the browser console.

You'll see an error message. In the far left there's a reference to the file and line number that produced the error message.
Click it to enter the Redux source code to see what `createStore()` was expecting.

--

Ok, so `createStore` is expecting this thing called a reducer as the first argument, which apparently is a function.
The reducer is a core concept in redux - they are functions that perform transformations on your application data.

The function signature for a reducer looks like this:

```haskell
(state, action) => new state
```

The responsibility of a reducer is simply to return a new version of the state whenever something happens. The reducer is passed the current state, and an action object describing the event that happened. This might be a user interaction, or an ajax response - basically everything that might trigger a change in our application state. We'll come back to these in just a bit.

Let's create a simple function just to get our store up and running. This example will serve our purpose:

```javascript
function reducer(state=0, action) {
    return state;
}
```

For now, this function will serve as placeholder and won't actually do anything yet. Note how we use the [default parameter syntax](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/default_parameters) of ES2015 to indicate that the initial state value of this reducer should be the number zero.

Let's try creating that store again:

```javascript
createStore(reducer)
```

Success!
Well, we still have a white page, so we're obviously not quite finished yet.
Let's print the number in our store to the screen.

### Step II: Retrieving the state from the store

The `store` object has a function `getState` that's used to retrieve the current state.
We'll use the good, old DOM API to render to the screen:

```javascript
document.body.innerText = store.getState();
```

Reopen your browser to verify that the number zero is shown.

Great! Now we've initialized a store object to hold our application data, created a simple reducer that describes our state transformations (currently none) and rendered the store contents (a number) to the DOM. 

The next logical step from here would be to perform changes to our state.

### Step III: Changing our state

We'll use another function on `store` for this purpose; the `dispatch` function. This function enables us to declaratively say that something has happened in our app. This would be some user interaction, e.g a button was clicked, or something timed out, or basically whatever action that might require us to update our state.

Let's try doing that dispatch thing:

```javascript
store.dispatch()
```

Did it work? What happened? Check the console again. 

Redux states that an action needs to be a plain javascript object. Try entering the source code again to have a look at what else Redux expects from our actions.

You'll see that the `type` property on our actions are used to distinguish between different kinds of actions.
Next, let's create and dispatch an action:

```javascript
store.dispatch({ type: 'USER_CLICKED' })
```

It's kinda lame saying the user clicked something when that obviously didn't happen, so we'll have to add an event listener:

```javascript
document.addEventListener('click', () => store.dispatch({ type: 'USER_CLICKED' }));
```
*(If the syntax above seems unfamiliar to you, read up on [ES6 arrow functions](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions))*

Click the white background of the browser window to see what happens!

...not much, so far.
Our reducer function actually gets the action passed in as the second argument, so why don't you go ahead and `console.log` the action parameter inside your reducer.

You'll see that upon creating the store, redux will trigger an action called `@@redux/INIT` which is used to set up the initial state in your reducer. Upon clicking the window, you'll see your own `USER_CLICKED`-actions appear.

The last thing we need to do in order to complete the Redux cycle is to update the state.

This involves making our reducer react to certain types of actions - `'USER_CLICKED'`, for instance.
Use an `if`-statement in your reducer function to increment the state only when an action of this type is dispatched.

Running your app with these additions yields disappointing results in the browser. The problem is that even though we are updating the value of our state, we're not rendering this new state to the page. 

### Step IV: Subscribing to store change and re-rendering

Lets refactor our rendering method into its own function:

```javascript
function render() {
    document.body.innerText = store.getState();
}
```

All that's left is to tell the store object to let us know whenever something changes. The store supplies us with a function called  `subscribe()` for this purpose, which allows us to easily rerender on every data change.

Make sure you still render the initial state upon app startup by calling render manually.

```javascript
store.subscribe(render);
```

Now the counter in your app should increase with every click inside the browser window.

That's it!
This is basically all there is to Redux.

Of course, this example app is trivial and only serves to help explain the core Redux concepts.

### Step V: Using React to render the app

React is a wildly popular frontend library by Facebook for creating graphical user interfaces. Hopefully you've got some experience with React before starting this workshop, but if that's not the case - fear not! React, when used with Redux, it pretty simple and can be learned pretty quickly.

We've created a separate document explaining the very basics of React, located [here](./react-intro.md).

If you're new to React you should read that before continuing on with the workshop.
You can safely skip that part if you already are somewhat acquainted with React.

### Creating a component

Let's get back to our simple counter application from Task 1 and render it using React. We'll have to create a simple component that accepts the current state as an argument and renders this in a `<div>`. Arguments are commonly referred to as `props` in the context of a React component.

The component might look something like this:

```javascript
function Counter(props) {
  return <div>{props.counter}</div>;
}
```

... and we'll instantiate it like this:

```javascript
<Counter counter={store.getState()} />
```

To actually render it on the screen, we need to import a couple of things from the `react` and `react-dom` libraries. The `render()` function accepts two parameters: a component to render and a DOM-reference to render it in.

```javascript
import React from 'react';
import { render } from 'react-dom';

render(component, document.querySelector('#app'))
```

##### Note on ES6 modules

*We'll be utilizing ES6 modules in this workshop, which means we'll use the keywords [`import`](https://developer.mozilla.org/en/docs/web/javascript/reference/statements/import) and [`export`](https://developer.mozilla.org/en/docs/web/javascript/reference/statements/export). This is the new way of sharing code between JavaScript files that was standardised in the 2015-version of the JavaScript standard. Hopefully the syntax is intuitive enough to understand, but just ask if you have any questions*


## Task 2: Rendering a Tweet Component

Now we've explored the basic concepts of an application built using React and Redux. The rest of the workshop consist mostly of applying these concepts at scale - e.g how do we build real world applications, how do we do asynchronous network calls, how do compose our component hierarchy, etc.

We'll do this by building a Twitter Dashboard app, as you've probably understood by now. Let's do the first small step of this process by creating a React component that will render a Tweet. This will be a central part of our app and we'll use it throughout the rest of the workshop.

The component should output the following HTML. This is needed to get the correct styling (we've written the CSS for you already).

*TODO*
```html
<div className="tweet">
        <div className={'tweet-header'}>
          <img className="tweet-image" src="https://pbs.twimg.com/profile_images/553711083064541184/9VsY9i09.jpeg" />
          <div className="tweet-image-offset tweet-name">Dan Abramov</div>
          <div className="tweet-image-offset tweet-screen-name">@DanAbramov</div>
        </div>

        <div className="tweet-content">
          <div className="tweet-text">Good luck on your quest to learn Redux!</div>
          <div className="tweet-stats">
            <span className="tweet-user-followers">
              <strong>26 587</strong>
              <span className="tweet-stats-desc">followers</span>
            </span>
          </div>
          <span className="tweet-country tweet-stats-desc">UK</span>
          <div className="tweet-city tweet-stats-desc">London</div>
        </div>
      </div>
```

##### Do the following:

* Create a `Tweet` component and put it in  `components/Tweet.jsx` (existing file)
* The component should return the given HTML structure
* The component should accept a prop called `tweet`
* The component should be passed a tweet datastructure, found in `example-tweet.js`

When this is done you should see a tweet rendered on the page.

Instead of manually sending in some hardcoded data from a file to the component, we should be getting the tweet data from the store, and adding the tweet to the store by dispatching an action.

##### Do the following:

* Change the initial state from a single number (the counter) to a an empty object, in anticipation of a tweet
* Dispatch an action with type `'TWEET_RECEIVED'` containing the tweet data
* Make the reducer return the received tweet as the new state
* Make sure the component is rendered each time the state is updated

Now you should still see the tweet on the page, but you should feel warm and fuzzy inside knowing that you've done it all according to protocol, Redux style!

## Task 3: Receiving real tweets from the Twitter API

We'll tire quickly of the same old hardcoded tweet, even if its really cool that it's being added to our shiny Redux store through an action. Using the Twitter streaming API we'll instead get access to live tweets from around the world. 

All you need to do is to paste the following code snippet into your `index.js`:

```javascript
const ws = new WebSocket('ws://twitterws.herokuapp.com');
const MAX_TWEETS = 1000;

ws.onmessage = ms => {
  const tweet = JSON.parse(ms.data);
  if (store.getState().tweets.length < MAX_TWEETS) {
	// add new tweet here by dispatching action
  }
};
```

Read the snippet carefully. We'll query the state to see if we have more than a certain threshold number of tweets, and if not, we'll dispatch a certain action.

Now that we're keeping more than just one tweet at a time, we'll have to change the shape of our state.  Also, as our app is growing, having the reducer function in our `index.js` feels like the college student still living with his parents - lets move it into its own file.

##### Do the following:

* Change the initial state from just an object to an empty array.
* Dispatch `'TWEET_RECEIVED'` whenever a new tweet is received through the WebSocket
* Move the tweet reducer function to `/reducers/tweets.js` (use `export default`)
* Make sure the tweet reducer adds any new tweets that it receives to the array of existing tweets
* Change the input (props) passed to our `<Tweet>` component so it only receives the newest tweet in the array

Voila! Now our app is set up to receive lots of tweets from the streaming API, showing the most recently received tweet.

Cool stuff! We're slowly moving towards a real application.

## Task 4: Building A Larger Application
Did you know the average human adult can read about 300 words per minute? Since a tweet is capped at 140 characters, the amount of tweets we should be able to read per second is about... nevermind that.

The important thing is that the streaming API sends tweets way faster than what we're actually able to absorb with our puny human comprehension. We can't really see what people are tweeting about as new tweets replace the older ones faster than we can read. Let's render a list of tweets instead!

#### Step I: Refactoring Into A New Top Level Component
As this will be the beginning of a larger application we want to create a root component for our app. Create this component in `containers/App.jsx`. This component should take a list called `tweets` as a `prop` and render an `<ul>` with the css class `tweetlist` and `<li>`s containing a `<Tweet>` for each of the tweets.

*(Protip: all JavaScript arrays have a very convenient method: [`map`](https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Array/map))*

*(Protip 2: you can "escape" the JSX syntax with curlybraces to execute JavaScript code and map arrays to JSX elements)*

*TODO: eksempel HTML her*

##### Do the following:

* Render our new `<App>` instead of `<Tweet>` in `index.js`
* Pass the entire list of tweets to `<App>`
* Have `<App>` render all the tweets
* Verify that you see an ever growing list of incoming tweets


#### Step II: Getting Familiar With `react-redux`
Now, we don't really want to handle store changes and rendering of the app manually (by having our own store subscriber and calling `render`), and this is where the package `react-redux` helps us. `react-redux` has a component called `<Provider>` that takes our `store` as a prop and takes care of subscribing to the store and updating its children.

So, in `index.js`, remove the `store.subscribe` bit and replace it with

```javascript
import { Provider } from 'react-redux';
render(
  <Provider store={ store }>
    <App />
  </Provider>,
  document.querySelector('#app')
);
```

You might notice that `<App>` is not getting the `tweets` list as a prop here. This is because we want `<App>` to get them from the store itself. How do we do this from `<App>`? Again, `react-redux` comes to the rescue with its `connect` function.

`connect` is a so-called higher order component that, simply put, "connects" a component to our redux store. It's first argument is a function that gets the state as an argument and returns an object. This function is called `mapStateToProps`. The object returned from `mapStateToProps` will be given as props to the component that `connect` wraps.

In other words - `connect` lets us describe what parts of the state a component is interested in, and automatically injects it as props to the component.

Your task now is to write a `mapStateToProps` function that takes the state as an argument and returns an object with the list of `tweets` as one of the properties. When you have done this, export the `<App>` component like this:

```javascript
export default connect(mapStateToProps)(App);
```

Now check that the list of tweets is still rendered and updated when new tweets come in.

##### Do the following:
* Connect the `<App>` to the Redux store
* Write the `mapStateToProps` function for `<App>`
* Verify that you see a list of tweets in the browser

#### Step III: Avoiding A Monolithic Component
It isn't immediately obvious that `<App>` renders a list of tweets, and we may want to render more things than just this tweet list in our app so we want to refactor a bit.

Move the rendering of the tweet list to `components/TweetFeed.jsx`. The tweets should be passed down to this component from `App.jsx` (and thus we won't need to `connect` `TweetFeed`).
There should be no visible changes from before but we have the beginnings of a nicer application architecture.

#### Step IV: Developer Tools
As our application is starting to grow we want to take advantage of a really nice tool that exists for `redux` applications, namely the `redux-devtools`. This will help us during application development by allowing us to see every action that flows through our application and how they affect the state.

We have done some of the boring setup so you don't have to. Go to `index.js` and replace your store initialization with
```javascript
import configureStore from './configureStore';
const store = configureStore();
```

While you're at it, import the `<DevTools>` component we've made (`./containers/DevTools`) and modify your `render` call so it looks like this:

```javascript
import DevTools from './containers/DevTools';
render(
  <Provider store={ store }>
    <div>
      <App />
      <DevTools />
    </div>
  </Provider>,
  document.querySelector('#app')
);
```

When you now open your app you should see a nice dark blue thingy on the right side of the screen that keeps showing `TWEET_RECEIVED`. Pretty cool, huh? You can even hide the devtools by pressing `ctrl+h` and move it by pressing `ctrl+q`!

Because of the large amount of tweets coming in we won't be able to notice other actions so we want to filter these out. Go to `containers/DevTools` and do as the instructions there say.
Now when you open your app you will only see the `@@INIT` action in the devtools, along with the store state after this initial action.

## Task 5: Creating Your Own Router
So far our whole app state has only consisted of a list of tweets. Now that we want to create our own little router we also need the current route as part of our app state.

### Step I: A Wild Reducer Appears
In `reducers/index.js` create another reducer function called `routeReducer`. Its initial state should be an empty string.
This reducer should handle an action of type `ROUTE_CHANGED` that has a `route` attached to it. Also create the corresponding action creator (in `actions/index.js`).

### Step II: Combining Reducers
To get the current route as part of our application state we have to somehow combine our two reducers (`tweetsReducer` and `routeReducer`) into an object.

Let's create another reducer called `rootReducer`. It's initial state should be an object like this:
```javascript
{
  tweets: [],
  route: ''
}
```

Now, this reducer should not handle any actions on is own, but rather delegate this to the other two reducers.

---

```javascript
const initialState = {
  tweets: [],
  route: ''
}
function rootReducer(state = initialState, action) {
  return {
    tweets: tweetReducer(state.tweets, action),
    route: routeReducer(state.route, action)
  };
}
```

This works, but will become cumbersome when we have more than two reducers. Luckily, Redux provides the aptly named function `combineReducers`. This function turns an object whose values are reducers into a combined reducer that works like the one we made. The shape of the resulting combined state will match the keys of the passed object of reducers.

In our case it will look like this:
```javascript
import { combineReducers } from 'redux';

const rootReducer = combineReducers({
  cards: cardsReducer,
  route: routeReducer
});

export default rootReducer;
```

Notice that we export this as default.

Now, if you open the app you will see that the list of tweets is not working. Fix this.
Hint: we changed the shape of the `state` so you will have to modify the `mapStateToProps` function we created earlier.

When you're done with this the app should work exactly as before.

### Step III: `redux`-enabled links!
We are making a single page app, and as such we want to be able to navigate around our app without needing round trips to the server. We have done the ground work for this by having a place to store the current route (the store) and a way to change the active route (our `changeRoute` actionCreator).

Now, create a new component, `containers/Link.jsx`.
This component should accept three props:
1. `to` - relative URL
1. `dispatch` - the same function as we earlier called on the `store` object
1. `className` - a regular CSS class

The component should render an `<a>` with ``href={ `#${to}` }`` and an `onClick` function that calls dispatch with the `changeRoute` action with the url passed as a prop.

Earlier when we dispatched actions we had access to our `store` object but here we don't. Again, `react-redux`'s `connect` function comes to the rescue. When we "connect" a component it will always get the `dispatch` function as a `prop`. Here we do not need anything other than `dispatch`, so we can just connect our link component like this (remember to import `connect` from `react-redux`):

```javascript
export default connect()(Link);
```

### Step IV: Navigating between views
A nice place to show these links is in `containers/App.jsx`.
Place the following markup above where you're rendering `TweetFeed` (remember to import `<Link>`):
```html
<div className="app-header">
  <div>
    <h1 className="heading">Twitter redux stuff</h1>
    <div className="menu-item">
      <Link to="/" className="img img-icon img-icon-dashboard"/>
      <Link to="/feed" className="img img-icon img-icon-settings"/>
    </div>
  </div>
</div>
```

Lastly we want to actually render one thing when the active route is `/` and another thing when it is `/feed`.

Update `mapStateToProps` to also send the active route to our `App` component. When the route is `/feed` we want to render our `TweetFeed` component, and when the route is `/` you can render whatever you want.

Now you should be able to click the nice links and see that the view switches between the tweet feed and the other view.

## Task 6: Displaying Tweets On A Map


## Task 7: Filtering Tweets

### Step I:
To make our twitter stream a bit more interesting, we can implement a filtering mechanism.
Let's say we filter the tweets based on text and hashtags.
This way we can use the map to see in what parts of the world they talk about "Trump" for instance.
Create a filter reducer that will handle an array of filters with the following data structure:
```javascript
{
  color: 'yellow',
  name: 'Trump',
  text: 'Trump',
  hashtags: ['Trump'],
  active: true
},
```
The active flag indicates if the filter is turned on or off.
The color indicates the map marker color, where the following colors are supported: 
* "blue" 
* "green"
* "pink" 
* "lightblue" 
* "purple"
* "yellow"
* "red"


For now, the only action the reducer will handle is of type `FILTER_ACTIVE_TOGGLE`.
Create the corresponding action creator `toggleActiveFilter()`.

To display the filters, we need a filter component. Create the file `Filter.jsx` with a component that renders the following HTML when given a filter
Substitute FILTERNAME and FILTERCOLOR with the values from the actual filter.
FILTERACTIVE should be either nothing or "inactive".

```html
<span className="FILTERACTIVE">
 <div className="circle FILTERCOLOR" />
 FILTERNAME
</span>
```

We would like to render a list of different filters, thus, create a `FilterList` component:

```html
<div className="filter-container">
  <ul className="filterList">
   <li>
    <Filter>
   </li>
  </ul>
</div>
```

Put the `FilterList` component in a new file and let this component be a child of the `Map` and `Feed` components.
Pass the state from your newly created `filters`-reducer down to the `FilterList` component.
Hint: In the `mapStateToProps` function at the bottom of the `Map` and `Feed`components, you should pick up `filters`from the `state` object.

Remember to combine the new reducer in the `reducers/index.js` file, as you did before with the `route`-reducer and the `tweets`reducer.

You may want to put some initial state data into the reducer, for instance the Trump filter, so that you have some data to work with in the UI.
When the filter list is successfully displayed on both routes, you can start on the onClick handler of the `Filter` component.

When you have finished this task, you should be able to toggle filters on and off by clicking on them.
If you have used the correct css-classes, this should be visible in the ui.

### Step II:
Now it is time to actually filter the tweets. Let's start with the tweets displayed in the feed route.
In the function `mapStateToProps` we pick up `filters`and `tweets`, thus, here we have everything we need.
Make a utility function `getViewTweets(tweets, filters)` that returns an array of all the tweets that match one or more of the active filters.
If there are no active filters, the function should return the 100 most recent tweets, as before.
Inside `mapStateToProps`, instead of returning a sliced array of tweets, use you newly created utility-function to return the "view" tweets.
Hint: It might be an idea to create a filter with a high match rate, so that you can quicly see if your implementation is correct.
For instance:
```
{
    color: 'orange',
    name: 'Frequent filter',
    text: 'the',
    active: false,
  }
```
Now, we are going to need the exact same functionality in the `Map` component.
Let's make our utility function reusable by putting it into a separate file and exporting it into both the `Map` and `Feed` component.
When you have completed this task, only tweets that match the active filter should show up in the Feed and on the Map.

### Step III: Adding color
Edit your `getViewTweets` function so that it not only filters the tweets, but also adds the prop color of the filter it matches.
If it does not match any filters, add the color red.
If you have used the correct CSS classes, both the Map and the Feed should now clearly indicate which filter the tweets match.


## Task 8: Creating new filters
### Step I:
It would be nice to be able to add new filters in the GUI instead of changing the initial state of the `filters`-reducer every time we want a new filter.
For this, we need a form component with the exotic name `FilterForm`.
We will start by only rendering the html, with no form logic.
The HTML should look something like this
 ```html
 <form className="filter-form">
       <h3>New filter</h3>
       <div className="input-wrapper">
           <label for="name">Name</label>
           <input type="text" id="name" name="name"/>
       </div>
       <div className="input-wrapper">
           <label for="hashtag">#</label>
           <input type="text" id="hashtags" name="hashtags"/>
       </div>
       <div className="input-wrapper">
          <label for="text">Text</label>
          <input type="text" id="text" name="text"/>
        </div>
        <div className="input-wrapper">
            <label for="color">Marker color</label>
            <select name="color">
              <option key="green" value="green">Green</option>
              <option key="pink" value="green">Pink</option>
            </select>
        </div>
        <button>Save</button>
     </form>
 ```
Tip: You may want to make a separate `InputField` component to DRY things up.

Before we put the new component into our GUI, let's make a wrapper component `FilterContainer` that wraps both the `FilterForm` and the `FilterList`:

```html
<div className="filter-container">
  <h2>Filters & Stats</h2>
  <FilterList/>
  <FilterForm/>
</div>
```

Note: remove the `className="filter-container"` prop in the `FilterList`, otherwise the html will look strange.
Replace the `FilterList` child component in `Feed` and `Map` with your newly created `FilterContainer`.
When you have completed this task there should be a form in the GUI.

### Step II
In React, form components have two props that control user interaction: `onChange` and `value`.
We will be using these two props to activate our input and select fields, the React Form documentation will be helpful here:
https://facebook.github.io/react/docs/forms.html.

In the example they are using in the React documentation they use `setState` inside the `handleChange` function.
Using `setState` means storing the state locally, in the component.
However, since we have a tool for handling state, namely, Redux, we don't need to use `setState`.
We can just use actions and reducers and make the form a part of our redux state tree. So, guess what? Time to make a new reducer `form`.
The initial state of the `form` should have the following representation:
```javascript
const initialState = {
  name: '',
  hashtags: '',
  text: '',
  color: ''
}
```
The new reducer should handle two cases `FORM_UPDATED` with the `formUpdate(field)` action creator and `FORM_SUBMITTED` with the `formSubmit()`action creator.
The field shoud be an object with a key (the field name) and a value (the field value).

You may want to connect the `FilterForm` component so that you don't have to pass form callbacks and form state all the way from `Feed` down to the input fields.
Once the `FilterForm` component is connected, you can hook up the form state with the `value` prop of the input and select form elements.
You can also create a callback function `updateForm` that dispatches `formFilterUpdate(field)`.
Pass the `updateForm` function down to the input field, so that you end up with something along the lines of
```
<input type="text" id={name} name={text} value={value} onChange={(event) => updateForm({key: 'text', value: event.target.value  })} />
```

When you have completed this task you should be able to fill the form fields and there should be actions firing in the Redux panel on every key stroke.

### Step III Submitting the form
When the user presses the save button in the form, three things should happen
1) The form should not be displayed in the GUI, we should only see the filters.
Thus we need to extend our `view` state object with a new prop: `formVisibility`.
The reducer should be extended with two cases `FORM_HIDE` and `FORM_SUBMITTED`, the latter action type we created in Step II.
When the `Form` is hidden, that is, when `formVisibilty: false`, the `FilterList` should be visible, along with a button ```<button>New filter</button>```.
When the `Form` is displayed, the `FilterList` and the button should be hidden. Hint: You may want to use the `If`-components introduced in task 5.

2) The form fields should be cleared

3) The form data should be submitted into our json






