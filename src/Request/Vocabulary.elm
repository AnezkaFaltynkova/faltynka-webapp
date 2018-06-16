module Request.Vocabulary exposing (updateNewVocabulary, updateOldVocabulary)

import Request.Helpers exposing (apiUrl)
import Models exposing (User, Deck, Vocabulary)
import Json.Encode as Encode
import Http
import Request.DecksToLearn exposing (decodeVocabulary)


updateNewVocabulary : User -> Vocabulary -> Http.Request (Vocabulary)
updateNewVocabulary user vocabulary =
  Http.request
    { method          = "PUT"
    , headers         = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
    , url             = apiUrl "/secure/vocabulary/new"
    , body            = Http.jsonBody (encodeVocabulary vocabulary)
    , expect          = Http.expectJson decodeVocabulary
    , timeout         = Nothing
    , withCredentials = False    }

updateOldVocabulary : User -> Vocabulary -> Http.Request (Vocabulary)
updateOldVocabulary user vocabulary =
  Http.request
    { method          = "PUT"
    , headers         = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
    , url             = apiUrl "/secure/vocabulary/old"
    , body            = Http.jsonBody (encodeVocabulary vocabulary)
    , expect          = Http.expectJson decodeVocabulary
    , timeout         = Nothing
    , withCredentials = False    }

encodeVocabulary: Vocabulary -> Encode.Value
encodeVocabulary vocabulary =
    let
        list =
            [ ( "id", Encode.string vocabulary.id )
            , ( "deckId", Encode.string vocabulary.deckId )
            , ( "front", Encode.string vocabulary.front )
            , ( "back", Encode.string vocabulary.back )
            , ( "currentInterval", Encode.int vocabulary.currentInterval )
            , ( "newVocabulary", Encode.bool vocabulary.newVocabulary )
            , ( "nextLearnedAt", Encode.string vocabulary.nextLearnedAt )
            ]
    in
        list
            |> Encode.object