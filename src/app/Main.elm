module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Html exposing (Html, div, text)
import Routing exposing (Route(..), routeLink, routeTo)
import Url exposing (Url)



-- Models


type Msg
    = NoOp
    | ClickedLink UrlRequest
    | ChangedUrl Url


type alias Model =
    { navKey : Navigation.Key }


defaultModel =
    {}



-- Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        route =
            routeTo model.navKey
    in
    case msg of
        ChangedUrl url ->
            ( model, Cmd.none )

        ClickedLink request ->
            case request of
                Internal url ->
                    ( model
                    , route url
                    )

                External url ->
                    ( model, Navigation.load url )

        NoOp ->
            ( model, Cmd.none )



-- Views


navView : Html Msg
navView =
    div []
        [ div [] [ routeLink "Home" ( HomeRoute, Nothing ) ]
        , div [] [ routeLink "Page 1" ( PageRoute 1, Nothing ) ]
        ]


mainView : Model -> Html Msg
mainView model =
    div []
        [ navView
        , div [] [ text "Welcome to a basic Elm application!" ]
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Elm App"
    , body = [ mainView model ]
    }



-- Main


init : String -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    ( { navKey = key }, Cmd.none )


main : Program String Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = ClickedLink
        , onUrlChange = ChangedUrl
        }
