module Page.Post exposing (Model, Msg(..), defaultModel, update, view)

import Html exposing (Html, div, text)


type Msg
    = LoadPost Post
    | NoOp


type Post
    = PostFound Int
    | NotFound


type alias Model =
    { currentPost : Post
    }


defaultModel : Maybe Int -> Model
defaultModel num =
    case num of
        Just page ->
            { currentPost = PostFound page
            }

        Nothing ->
            { currentPost = NotFound }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPost post ->
            ( { model | currentPost = post }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    case model.currentPost of
        PostFound post ->
            div [] [ text ("Viewing post: " ++ String.fromInt post) ]

        NotFound ->
            div [] [ text "Post not found :(" ]
