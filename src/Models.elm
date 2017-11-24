module Models exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipeline exposing (decode, required)

type alias Model =
    { user : User
    }


initialModel : Model
initialModel =
    { user = User "" "" ""
    }

type alias User =
    { email : String
    , password : String
    , token : String
    }

userDecoder : Decoder User
userDecoder =
    decode User
        |> required "email" Decode.string
        |> required "token" Decode.string