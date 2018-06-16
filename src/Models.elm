module Models exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required, hardcoded)

type alias Model =
    { user : User
    , route : Route
    , decksToLearn : List (Deck)
    , studyingNew : List (Vocabulary)
    , studyingOld : List (Vocabulary)
    , isPopupCreateDeckActive: Bool
    , isPopupDeleteDeckActive: Bool
    , isPopupUpdateDeckActive: Bool
    , deckToCreate : DeckToCreate
    , deckToUpdate : DeckToUpdate
    , deckToDelete : Deck
    , textMessage : String
    }

type Route
    = LoginRoute
    | DecksRoute
    | StudyNewRoute
    | StudyNewBackRoute
    | StudyOldRoute
    | StudyOldBackRoute
    | NotFoundRoute


initialModel : Route -> Model
initialModel route =
    { user = User "" "" ""
    , route = route
    , decksToLearn = []
    , studyingNew = []
    , studyingOld = []
    , isPopupCreateDeckActive = False
    , isPopupDeleteDeckActive = False
    , isPopupUpdateDeckActive = False
    , deckToCreate = DeckToCreate "" 0
    , deckToDelete = Deck "" "" [] []
    , deckToUpdate = DeckToUpdate "" "" 0
    , textMessage = ""
    }

type alias User =
    { email : String
    , password : String
    , token : String
    }

type alias Deck =
    { deckId : String
    , deckName: String
    , newVocabulariesToLearn: List (Vocabulary)
    , oldVocabulariesToLearn: List (Vocabulary)
    }

type alias DeckToCreate =
    { deckName: String
    , limitNewPerDay: Int
    }

type alias DeckToUpdate =
    { id: String
    , name: String
    , limitNewPerDay: Int
    }

type alias Vocabulary =
    { id: String
    , deckId: String
    , front: String
    , back: String
    , currentInterval: Int
    , newVocabulary: Bool
    , nextLearnedAt: String
    }

userDecoder : Decoder User
userDecoder =
    decode User
        |> required "email" Decode.string
        |> hardcoded ""
        |> required "token" Decode.string
