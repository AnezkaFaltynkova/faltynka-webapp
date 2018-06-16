module View exposing (..)

import Html exposing (Html, div, text)
import Msgs exposing (Msg)
import Models exposing (Model)
import Pages.Login
import Pages.Decks
import Pages.StudyNewFront
import Pages.StudyOldFront
import Pages.StudyNewBack
import Pages.StudyOldBack


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.LoginRoute ->
            Pages.Login.view model

        Models.DecksRoute ->
            Pages.Decks.view model

        Models.StudyNewRoute ->
            Pages.StudyNewFront.view model.studyingNew

        Models.StudyNewBackRoute ->
            Pages.StudyNewBack.view model.studyingNew

        Models.StudyOldRoute ->
            Pages.StudyOldFront.view model.studyingOld

        Models.StudyOldBackRoute ->
            Pages.StudyOldBack.view model.studyingOld

        Models.NotFoundRoute ->
            notFoundView


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]