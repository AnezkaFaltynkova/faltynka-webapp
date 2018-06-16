module Request.User exposing (login)

import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Request.Helpers exposing (apiUrl)
import Util exposing ((=>))





login : { r | email : String, password : String } -> Http.Request String
login { email, password } =
    let
        body =
            Encode.object [ "email" => Encode.string email
                          , "password" => Encode.string password
                          ]
                |> Http.jsonBody
    in
    Decode.field "token" Decode.string
        |> Http.post (apiUrl "/user/login") body


