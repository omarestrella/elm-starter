module Routing exposing (Route(..), routeFromUrl, routeLink, routeTo)

import Browser.Navigation as Navigation
import Html exposing (Html, a, text)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Url exposing (Url)
import Url.Builder as Builder
import Url.Parser as Parser exposing ((</>), Parser, int, map, oneOf, parse, s, top)


type Route
    = PostRoute Int
    | HomeRoute
    | NotFoundRoute


pushRouteUrl : Route -> Navigation.Key -> Cmd msg
pushRouteUrl route key =
    Navigation.pushUrl key (routePath route)


routePath : Route -> String
routePath route =
    case route of
        PostRoute page ->
            Builder.absolute
                [ "post", String.fromInt page ]
                []

        HomeRoute ->
            Builder.absolute [ "" ] []

        NotFoundRoute ->
            Builder.absolute [ "not-found" ] []


parseRoute : Parser (Route -> a) a
parseRoute =
    oneOf
        [ map HomeRoute
            top
        , map PostRoute
            (s "post" </> int)
        ]


routeFromUrl : Url -> Route
routeFromUrl url =
    case parse parseRoute url of
        Just route ->
            route

        Nothing ->
            NotFoundRoute



-- Public


routeLink : String -> ( Route, Maybe msg ) -> Html msg
routeLink text_ ( route, handler ) =
    case handler of
        Nothing ->
            a [ href (routePath route) ]
                [ text text_ ]

        Just clickMsg ->
            a [ href (routePath route), onClick clickMsg ]
                [ text text_ ]


routeTo : Navigation.Key -> Url -> Cmd msg
routeTo key url =
    let
        route =
            routeFromUrl url
    in
    pushRouteUrl route key
