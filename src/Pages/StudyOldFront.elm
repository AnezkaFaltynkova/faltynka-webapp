module Pages.StudyOldFront exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Models exposing (Model, Vocabulary)


view : List (Vocabulary) -> Html Msg
view vocabularies =
    div []
        [ nav
        , div [] [button [ onClick BackToDecks ] [ text "Back to Decks" ]]
        , div [] [ showFrontOrDone (getFirstVocabulary vocabularies) ]
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Faltynka" ] ]


getFirstVocabulary: List (Vocabulary) -> Maybe Vocabulary
getFirstVocabulary vocabularies =
    List.head vocabularies

showFrontOrDone: Maybe Vocabulary -> Html Msg
showFrontOrDone maybe =
    case maybe of
        Just value ->
            div []
                [ div [] [text value.front]
                , div [] [ button [ onClick ShowOldBack ] [ text "Show" ] ]
                ]

        Nothing ->
            div []
                [ text "There are any old vocabularies to learn today for this deck"
                ]