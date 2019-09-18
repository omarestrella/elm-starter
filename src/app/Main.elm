module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Page.Home as Home
import Page.Post as Post
import Routing exposing (Route(..))
import Session exposing (Session)
import Url exposing (Url)



-- Models


type Msg
    = NoOp
    | ClickedLink UrlRequest
    | ChangedUrl Url
    | LoggedIn
    | GotPostMsg Post.Msg
    | GotHomeMsg Home.Msg


type PageModel
    = Home Home.Model
    | Post Post.Model
    | NotFound


type alias Model =
    { session : Session
    , currentRoute : Route
    , pageModel : PageModel
    }



-- Update


updateModel : (subModel -> PageModel) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateModel toModel toMsg model ( subModel, subCmd ) =
    let
        pageModel =
            toModel subModel
    in
    ( { model | pageModel = pageModel }
    , Cmd.map toMsg subCmd
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        route =
            Routing.routeTo model.session.key
    in
    case ( msg, model.pageModel ) of
        -- Handle messages from individual pages
        ( GotPostMsg postMsg, Post postModel ) ->
            Post.update postMsg postModel
                |> updateModel Post GotPostMsg model

        ( GotHomeMsg homeMsg, Home homeModel ) ->
            Home.update homeMsg homeModel
                |> updateModel Home GotHomeMsg model

        -- Handle URL changes
        ( ChangedUrl url, _ ) ->
            let
                currentRoute =
                    Routing.routeFromUrl url
            in
            ( { model | currentRoute = currentRoute, pageModel = defaultPageModel currentRoute }, Cmd.none )

        ( ClickedLink request, _ ) ->
            case request of
                Internal url ->
                    ( model
                    , route url
                    )

                External url ->
                    ( model, Navigation.load url )

        ( NoOp, _ ) ->
            ( model, Cmd.none )

        -- Dummy login to set session user
        ( LoggedIn, _ ) ->
            let
                session =
                    model.session

                updatedSession =
                    { session | user = Session.User { firstName = "Marcus", lastName = "Aurelius" } }
            in
            ( { model | session = updatedSession }, Cmd.none )

        -- Mismatched messages dont do anything
        ( GotHomeMsg _, _ ) ->
            ( model, Cmd.none )

        ( GotPostMsg _, _ ) ->
            ( model, Cmd.none )


defaultPageModel : Route -> PageModel
defaultPageModel route =
    case route of
        PostRoute post ->
            Post (Post.defaultModel (Just post))

        HomeRoute ->
            Home Home.defaultModel

        NotFoundRoute ->
            NotFound



-- Views


navView : Html Msg
navView =
    div [ class "navigation" ]
        [ span [] [ Routing.routeLink "Home" ( HomeRoute, Nothing ) ]
        , span [] [ Routing.routeLink "Post 1" ( PostRoute 1, Nothing ) ]
        ]


userView : Session.User -> Html Msg
userView user =
    case user of
        Session.Guest ->
            div []
                [ text "Welcome, guest!"
                , text " "
                , a [ href "#", onClick LoggedIn ] [ text "Login" ]
                ]

        Session.User data ->
            let
                name =
                    data.firstName ++ data.lastName
            in
            div [] [ text ("Welcome, " ++ name) ]


pageView : Model -> Html Msg
pageView model =
    case model.pageModel of
        Home homeModel ->
            Home.view homeModel
                |> Html.map GotHomeMsg

        Post postModel ->
            Post.view postModel
                |> Html.map GotPostMsg

        NotFound ->
            div [] [ text "Not found!" ]


mainView : Model -> Html Msg
mainView model =
    div [ class "main" ]
        [ navView
        , userView model.session.user
        , pageView model
        ]


view : Model -> Browser.Document Msg
view model =
    { title = "Elm App"
    , body = [ mainView model ]
    }



-- Main


init : String -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init _ url key =
    let
        currentRoute =
            Routing.routeFromUrl url

        session =
            { key = key
            , user = Session.Guest
            }
    in
    ( { session = session, currentRoute = currentRoute, pageModel = Home Home.defaultModel }
    , Cmd.batch
        [ Routing.routeTo key url
        , Cmd.none
        ]
    )


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
