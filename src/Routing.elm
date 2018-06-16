module Routing exposing (..)

import Navigation exposing (Location)
import Models exposing (Route(..))
import UrlParser exposing (..)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map LoginRoute top
        , map DecksRoute (s "decks")
        , map LoginRoute (s "login")
        , map StudyNewRoute (s "study-new")
        , map StudyNewBackRoute (s "study-new-back")
        , map StudyOldRoute (s "study-old")
        , map StudyOldBackRoute (s "study-old-back")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute