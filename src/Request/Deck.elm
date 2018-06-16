module Request.Deck exposing (createDeck, deleteDeck)

import Request.Helpers exposing (apiUrl)
import Models exposing (User, DeckToCreate, Deck)
import Json.Encode as Encode
import Http

createDeck : User -> DeckToCreate -> Http.Request ()
createDeck user deckToCreate =
  Http.request
    { method          = "POST"
    , headers         = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
    , url             = apiUrl "/secure/decks"
    , body            = Http.jsonBody (encodeDeck deckToCreate)
    , expect          = expectUnit
    , timeout         = Nothing
    , withCredentials = False    }

deleteDeck : User -> Deck -> Http.Request ()
deleteDeck user deck =
  Http.request
    { method          = "DELETE"
    , headers         = [ Http.header "Authorization" ("Bearer " ++ user.token) ]
    , url             = apiUrl ("/secure/decks/" ++ deck.deckId)
    , body            = Http.emptyBody
    , expect          = expectUnit
    , timeout         = Nothing
    , withCredentials = False    }

encodeDeck: DeckToCreate -> Encode.Value
encodeDeck deck =
    let
        list =
            [ ( "name", Encode.string deck.deckName )
            , ( "limitNewPerDay", Encode.int deck.limitNewPerDay )
            ]
    in
        list
            |> Encode.object

expectUnit : Http.Expect ()
expectUnit =
    Http.expectStringResponse << always <| Ok ()