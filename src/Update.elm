module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model, Route(..), Vocabulary, DeckToCreate)
import Http
import Request.User exposing (..)
import Request.DecksToLearn exposing (..)
import Request.Vocabulary exposing (..)
import Request.Deck exposing (..)
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
        ToggleCreateDeckPopup ->
            ({ model | isPopupCreateDeckActive = not model.isPopupCreateDeckActive }, Cmd.none)
        SaveCreateDeckPopup ->
            ( model, Http.send OnCreateNewDeck (Request.Deck.createDeck model.user model.deckToCreate))
        ToggleDeleteDeckPopup deck ->
            ({ model | isPopupDeleteDeckActive = not model.isPopupDeleteDeckActive, deckToDelete = deck }, Cmd.none)
        SubmitDeleteDeck deck ->
            ( model, Http.send OnDeleteDeck (Request.Deck.deleteDeck model.user deck))
        SetEmail email ->
            let
                oldUser = model.user
                newUser = { oldUser | email = email }
            in
                ({ model | user = newUser}, Cmd.none)
        SetPassword password ->
            let
                oldUser = model.user
                newUser = { oldUser | password = password }
            in
                ({ model | user = newUser}, Cmd.none)
        SubmitForm ->
            ( model, Http.send OnUserLogin (Request.User.login model.user) )

        SetDeckName deckName ->
            let
                oldDeck = model.deckToCreate
                newDeck = { oldDeck | deckName = deckName }
            in
                ({ model | deckToCreate = newDeck}, Cmd.none)

        SetLimitNewPerDay limitNewPerDay ->
            let
                oldDeck = model.deckToCreate
                newDeck = { oldDeck | limitNewPerDay = Result.withDefault 0 (String.toInt limitNewPerDay) }
            in
                ({ model | deckToCreate = newDeck}, Cmd.none)

        StudyNew vocabularies ->
            ({ model | studyingNew = vocabularies, route = StudyNewRoute}, Cmd.none)

        ShowNewBack ->
            ({ model | route = StudyNewBackRoute }, Cmd.none )

        ShowOldBack ->
            ({ model | route = StudyOldBackRoute }, Cmd.none )

        DidNotKnowNew ->
            ({ model | studyingNew = processUnknownVocabulary (List.head model.studyingNew) model.studyingNew, route = StudyNewRoute}, Cmd.none )

        DidNotKnowOld ->
            ({ model | studyingOld = processUnknownVocabulary (List.head model.studyingOld) model.studyingOld, route = StudyOldRoute}, Cmd.none )

        KnewNew ->
            let
                maybeKnownVocabulary = List.head model.studyingNew
                updatedVocabulary = processKnownNewVocabulary maybeKnownVocabulary
            in
                ( model , updateNewKnownVocabulary model updatedVocabulary )

        KnewOld ->
            let
                maybeKnownVocabulary = List.head model.studyingOld
                updatedVocabulary = processKnownOldVocabulary maybeKnownVocabulary
            in
                ( model , updateOldKnownVocabulary model updatedVocabulary )

        StudyOld vocabularies ->
            ({ model | studyingOld = vocabularies, route = StudyOldRoute}, Cmd.none)

        BackToDecks ->
            ( model , Http.send OnFetchDecksToLearn (Request.DecksToLearn.fetchDecksToLearn model.user) )

        OnUserLogin (Ok token) ->
            let
                oldUser = model.user
                newUser = { oldUser | token = token }
            in
                ({ model | user = newUser }, Http.send OnFetchDecksToLearn (Request.DecksToLearn.fetchDecksToLearn newUser) )

        OnUserLogin (Err error) ->
            ( { model | textMessage = (toString error)}, Cmd.none )

        OnFetchDecksToLearn (Ok decks) ->
            ( { model | decksToLearn = decks, route = DecksRoute} , Cmd.none )

        OnFetchDecksToLearn (Err error) ->
            ( { model | textMessage = (toString error)}, Cmd.none )

        OnUpdateNewVocabulary (Ok vocabulary) ->
            ({ model | studyingNew = getTailOrEmptyList (List.tail model.studyingNew), route = StudyNewRoute }, Cmd.none )

        OnUpdateNewVocabulary (Err error) ->
            ({ model | textMessage = (toString error)}, Cmd.none)

        OnUpdateOldVocabulary (Ok vocabulary) ->
            ({ model | studyingOld = getTailOrEmptyList (List.tail model.studyingOld), route = StudyOldRoute }, Cmd.none )

        OnUpdateOldVocabulary (Err error) ->
            ({ model | textMessage = (toString error)}, Cmd.none)

        OnCreateNewDeck (Ok ()) ->
            ({ model | isPopupCreateDeckActive = False }, Http.send OnFetchDecksToLearn (Request.DecksToLearn.fetchDecksToLearn model.user))

        OnCreateNewDeck (Err error) ->
            ({ model | textMessage = (toString error)}, Cmd.none)

        OnDeleteDeck (Ok ()) ->
            ({ model | isPopupDeleteDeckActive = False }, Http.send OnFetchDecksToLearn (Request.DecksToLearn.fetchDecksToLearn model.user))

        OnDeleteDeck (Err error) ->
            ({ model | textMessage = (toString error)}, Cmd.none)

        OnLocationChange location ->
            let
                newRoute = parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )


processUnknownVocabulary: Maybe Vocabulary -> List (Vocabulary) -> List (Vocabulary)
processUnknownVocabulary maybe newVocabularies =
    case maybe of
        Just value ->
             let
                updatedVocabulary = { value | currentInterval = 1 }
             in
                getTailOrEmptyList (List.tail newVocabularies) ++ [ updatedVocabulary ]

        Nothing ->
             newVocabularies

getTailOrEmptyList: Maybe (List (Vocabulary)) -> List (Vocabulary)
getTailOrEmptyList maybeList =
    case maybeList of
        Just value ->
            value
        Nothing ->
            []


processKnownNewVocabulary: Maybe Vocabulary ->  Maybe Vocabulary
processKnownNewVocabulary maybe =
    case maybe of
        Just value ->
            let
                newValue = { value | currentInterval = setCurrentIntervalKnownNew value.currentInterval }
            in
                Just newValue

        Nothing ->
            Nothing

setCurrentIntervalKnownNew: Int -> Int
setCurrentIntervalKnownNew currentInterval =
    if currentInterval == 1 then 1 else 2

updateNewKnownVocabulary: Model -> Maybe Vocabulary -> Cmd Msg
updateNewKnownVocabulary model maybe =
    case maybe of
        Just value ->
            Http.send OnUpdateNewVocabulary (Request.Vocabulary.updateNewVocabulary model.user value)

        Nothing ->
            Cmd.none

processKnownOldVocabulary: Maybe Vocabulary ->  Maybe Vocabulary
processKnownOldVocabulary maybe =
    case maybe of
        Just value ->
            let
                newValue = { value | currentInterval = setCurrentIntervalKnownOld value.currentInterval }
            in
                Just newValue

        Nothing ->
            Nothing

setCurrentIntervalKnownOld: Int -> Int
setCurrentIntervalKnownOld currentInterval =
    if currentInterval == 1 then 1 else 2 * currentInterval

updateOldKnownVocabulary: Model -> Maybe Vocabulary -> Cmd Msg
updateOldKnownVocabulary model maybe =
    case maybe of
        Just value ->
            Http.send OnUpdateOldVocabulary (Request.Vocabulary.updateOldVocabulary model.user value)

        Nothing ->
            Cmd.none