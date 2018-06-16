module Pages.StudyOldBack exposing (..)

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
        , div [] [ showFrontAndBack (getFirstVocabulary vocabularies) ]
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Faltynka" ] ]


getFirstVocabulary: List (Vocabulary) -> Maybe Vocabulary
getFirstVocabulary vocabularies =
    List.head vocabularies

showFrontAndBack: Maybe Vocabulary -> Html Msg
showFrontAndBack maybe =
    case maybe of
        Just value ->
            div []
                [ div [] [ text value.front ]
                , div [] [ text value.back ]
                , div [] [ button [ onClick DidNotKnowOld ] [ text "I didn't know" ]
                         , button [ onClick KnewOld ] [ text "I knew"] ]
                ]

        Nothing ->
            div []
                [ text "The vocabulary disappeared"
                ]