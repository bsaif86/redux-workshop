module Update
    exposing
        ( Msg(..)
        , update
        , init
        , subscriptions
        )

import WebSocket
import Model exposing (Model, maxTweets)
import Model.Route exposing (Route(..), routeToString)
import Model.Tweet exposing (Tweet, TweetId, jsonDecodeTweetString, toMarker)
import Model.GMaps exposing (Marker, IconUrl)
import Model.MarkerColor as MarkerColor exposing (Color, defaultColor, toIconUrl)
import Model.Filter exposing (Filter, findFilterMatch, emptyFilter, decodeFilters)
import Model.ApiData as ApiData exposing (ApiData(..))
import GMaps exposing (showMap, hideMap, showMarkers, changeMarkerIcon, markerClicked)
import Api exposing (Msg(..))
import Util


init : ( Model, Cmd Msg )
init =
    let
        initialModel =
            { tweets = []
            , route = Main
            , currentTweet = Nothing
            , filters = Loading
            , formVisible = False
            , formState = emptyFilter
            }
    in
        ( initialModel
        , Cmd.batch
            [ showMap ()
            , Api.getFilters () |> Cmd.map ApiMsg
            ]
        )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ WebSocket.listen "ws://twitterws.herokuapp.com" NewTweet
        , markerClicked MarkerClicked
        ]


type Msg
    = NewTweet String
    | RouteChanged Route
    | MarkerClicked TweetId
    | ToggleFilterActive Filter
    | ShowForm
    | ChangeFormState Filter
    | FormSubmit Filter
    | ApiMsg Api.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged r ->
            updateRoute r model

        NewTweet t ->
            addTweet t model

        MarkerClicked m ->
            setCurrentTweet m model

        ToggleFilterActive f ->
            toggleFilterActive f model

        ShowForm ->
            ( { model | formVisible = True }, Cmd.none )

        ChangeFormState f ->
            ( { model | formState = f }, Cmd.none )

        FormSubmit f ->
            ( { model
                | filters = ApiData.map ((::) f) model.filters
                , formState = emptyFilter
                , formVisible = False
              }
            , Cmd.none
            )

        ApiMsg msg ->
            let
                filters =
                    case msg of
                        FetchFailed err ->
                            Failed "Error fetching filters"

                        FiltersFetched fs ->
                            Loaded fs
            in
                ( { model
                    | filters = filters
                  }
                , Cmd.none
                )


updateRoute : Route -> Model -> ( Model, Cmd Msg )
updateRoute r model =
    case r of
        Main ->
            ( { model | route = r }
            , showMap ()
            )

        Feed ->
            ( { model | route = r }
            , hideMap ()
            )


addTweet : String -> Model -> ( Model, Cmd Msg )
addTweet tweetStr model =
    let
        tweetMb =
            tweetStr
                |> jsonDecodeTweetString
                |> Result.toMaybe

        tweets =
            case tweetMb of
                Just t ->
                    t :: model.tweets

                Nothing ->
                    model.tweets

        updatedModel =
            { model
                | tweets = List.take maxTweets tweets
            }
    in
        ( updatedModel
        , updateMarkers model updatedModel
        )


setCurrentTweet : TweetId -> Model -> ( Model, Cmd Msg )
setCurrentTweet tId model =
    let
        newCurrentTweet =
            model.tweets
                |> Util.find (\t -> t.id == tId)
                |> (\ct ->
                        if Util.maybeEquals ct model.currentTweet then
                            Nothing
                        else
                            ct
                   )

        updatedModel =
            { model | currentTweet = newCurrentTweet }
    in
        ( updatedModel
        , updateMarkers model updatedModel
        )


tweetToMarker : Tweet -> Color -> ( Marker, IconUrl )
tweetToMarker tweet color =
    ( toMarker tweet, toIconUrl color )


updateMarkers : Model -> Model -> Cmd Msg
updateMarkers oldModel newModel =
    if
        oldModel.tweets
            == newModel.tweets
            && oldModel.currentTweet
            == newModel.currentTweet
            && oldModel.filters
            == newModel.filters
    then
        Cmd.none
    else
        let
            getColor tweet =
                if Util.maybeEquals (Just tweet) newModel.currentTweet then
                    MarkerColor.Blue
                else
                    tweet
                        |> findFilterMatch (ApiData.withDefault [] newModel.filters)
                        |> Maybe.map .color
                        |> Maybe.withDefault defaultColor

            showMarkersCmd =
                newModel.tweets
                    |> List.map (\t -> ( toMarker t, toIconUrl <| getColor t ))
                    |> showMarkers
        in
            showMarkersCmd


toggleFilterActive : Filter -> Model -> ( Model, Cmd Msg )
toggleFilterActive filter model =
    let
        updatedFilters =
            model.filters
                |> ApiData.map
                    (List.map
                        (\f ->
                            if f == filter then
                                { f | active = not f.active }
                            else
                                f
                        )
                    )
    in
        ( { model | filters = updatedFilters }
        , Cmd.none
        )
