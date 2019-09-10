module Page.Home exposing (Model, Msg(..), defaultModel, update, view)

import Html exposing (Html, div, text)



-- Model


type Msg
    = NoOp


type alias Model =
    {}


defaultModel =
    {}



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )



-- View


view : Model -> Html Msg
view _ =
    div [] [ text "On home page" ]
