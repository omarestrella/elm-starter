module Page.Post exposing (Model, Msg(..), defaultModel, update, view)

import Html exposing (Html, div, text)


type Msg
    = LoadPage Page
    | NoOp


type Page
    = PageFound Int
    | NotFound


type alias Model =
    { currentPage : Page
    }


defaultModel : Maybe Int -> Model
defaultModel num =
    case num of
        Just page ->
            { currentPage = PageFound page
            }

        Nothing ->
            { currentPage = NotFound }



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadPage page ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view _ =
    div [] [ text "Viewing a page!" ]
