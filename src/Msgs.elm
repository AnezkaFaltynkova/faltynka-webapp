module Msgs exposing (..)

import Http
import Models exposing (User, Deck, Vocabulary, DeckToCreate)
import Navigation exposing (Location)

type Msg
    = SubmitForm
    | SetEmail String
    | SetPassword String
    | SetDeckName String
    | SetLimitNewPerDay String
    | NoOp
    | OnUserLogin (Result Http.Error String)
    | OnFetchDecksToLearn (Result Http.Error (List (Deck)))
    | OnUpdateNewVocabulary (Result Http.Error Vocabulary)
    | OnUpdateOldVocabulary (Result Http.Error Vocabulary)
    | OnCreateNewDeck (Result Http.Error ())
    | OnDeleteDeck (Result Http.Error ())
    | OnLocationChange Location
    | StudyNew (List (Vocabulary))
    | StudyOld (List (Vocabulary))
    | BackToDecks
    | ShowNewBack
    | ShowOldBack
    | DidNotKnowNew
    | KnewNew
    | KnewOld
    | DidNotKnowOld
    | ToggleCreateDeckPopup
    | SaveCreateDeckPopup
    | ToggleDeleteDeckPopup Deck
    | SubmitDeleteDeck Deck