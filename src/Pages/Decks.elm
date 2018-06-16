module Pages.Decks exposing (..)

import Msgs exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Model, Deck, DeckToCreate)
import Dialog
import Views.Form as Form

view : Model -> Html Msg
view model =
    div []
        [ bootstrap
        , nav
        , list model.decksToLearn
        , div [] [ button [ onClick ToggleCreateDeckPopup ] [ text "Create New Deck"] ]
        , Dialog.view
            (if model.isPopupCreateDeckActive then
                Just (dialogConfigCreateDeck model)
            else
                Nothing
            )
        , Dialog.view
            (if model.isPopupDeleteDeckActive then
                Just (dialogConfigDeleteDeck model.deckToDelete )
            else
                Nothing
            )
        , Dialog.view
            (if model.isPopupUpdateDeckActive then
                Just (dialogConfigUpdateDeck model.deckToUpdate )
            else
                Nothing
            )
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Decks" ] ]


list : List Deck -> Html Msg
list decks =
    div [ class "p2" ]
        [ table []
            [
             tbody [] (List.map deckRow decks)
            ]
        ]


deckRow : Deck -> Html Msg
deckRow deck =
    tr []
        [ td [] [ button [ onClick (ToggleDeleteDeckPopup deck) ] [ text "Delete"] ]
        , td [] [ button [] [ text "Statistics"] ]
        , td [] [ button [] [ text "Setup"] ]
        , td [] [ button [] [ text "Add New"] ]
        , td [] [ text deck.deckName ]
        , td [] [ button [ onClick (StudyNew deck.newVocabulariesToLearn) ] [ text ("Study " ++ (toString (List.length deck.newVocabulariesToLearn)) ++ " New") ]]
        , td [] [ button [ onClick (StudyOld deck.oldVocabulariesToLearn) ] [ text ("Study " ++ (toString (List.length deck.oldVocabulariesToLearn)) ++ " Old") ]]

        ]

dialogConfigCreateDeck : Model -> Dialog.Config Msg
dialogConfigCreateDeck model =
    { closeMessage = Just ToggleCreateDeckPopup
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Create New Deck" ])
    , body = Just (viewFormCreateNewDeck model)
    , footer = Nothing
    }

viewFormCreateNewDeck : Model -> Html Msg
viewFormCreateNewDeck model =
    Html.form [ onSubmit SaveCreateDeckPopup ]
        [ Form.input
            [ class "form-control-lg"
            , placeholder "Deck Name"
            , onInput SetDeckName
            ]
            []
        , Form.number
            [ class "form-control-lg"
            , placeholder "Limit of new vocabularies per day"
            , onInput SetLimitNewPerDay
            ]
            []
        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
            [ text "Create" ]
        , text model.textMessage
        ]

dialogConfigDeleteDeck : Deck -> Dialog.Config Msg
dialogConfigDeleteDeck deck =
    { closeMessage = Just (ToggleDeleteDeckPopup (Deck "" "" [] []))
    , containerClass = Nothing
    , header = Just (h3 [] [ text "Delete Deck" ])
    , body = Just (div[]
                       [ text ("Are you sure you want to delete deck " ++ deck.deckName ++ " with all its vocabularies?") ])
    , footer = Just (div []
                        [ button [ onClick (SubmitDeleteDeck deck) ]
                            [ text "Delete" ]])
    }

bootstrap : Html msg
bootstrap =
    node "link"
        [ href "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css"
        , rel "stylesheet"
        ]
        []