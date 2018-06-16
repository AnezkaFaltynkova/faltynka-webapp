module Request.DecksToLearn exposing (fetchDecksToLearn, decodeVocabulary)

import Request.Helpers exposing (apiUrl)
import Models exposing (User, Deck, Vocabulary)
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)
import Http


fetchDecksToLearn: User -> Http.Request (List (Deck))
fetchDecksToLearn user =
  Http.request
    { method          = "GET"
    , headers         = [ Http.header "Content-Type"  "application/json"
                        , Http.header "Authorization" ("Bearer " ++ user.token) ]
    , url             = apiUrl "/secure/decks-to-learn"
    , body            = Http.emptyBody
    , expect          = Http.expectJson decksToLearnDecoder
    , timeout         = Nothing
    , withCredentials = False    }


decksToLearnDecoder : Decode.Decoder (List Deck)
decksToLearnDecoder =
    Decode.field "decksWithVocabulariesToLearn" (Decode.list deckDecoder)


deckDecoder : Decode.Decoder Deck
deckDecoder =
    decode Deck
        |> required "deckId" Decode.string
        |> required "deckName" Decode.string
        |> required "newVocabulariesToLearn" (Decode.list decodeVocabulary)
        |> required "oldVocabulariesToLearn" (Decode.list decodeVocabulary)

decodeVocabulary: Decode.Decoder Vocabulary
decodeVocabulary =
    decode Vocabulary
        |> required "id" Decode.string
        |> required "deckId" Decode.string
        |> required "front" Decode.string
        |> required "back" Decode.string
        |> optional "currentInterval" Decode.int 0
        |> required "newVocabulary" Decode.bool
        |> optional "nextLearnedAt" Decode.string ""
