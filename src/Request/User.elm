--module Request.User exposing (edit, login, register, storeSession)
module Request.User exposing (login)


import Models exposing (User)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams)
import Json.Decode as Decode
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra
import Request.Helpers exposing (apiUrl)
import Util exposing ((=>))





login : { r | email : String, password : String } -> Http.Request User
login { email, password } =
    let
        user =
            Encode.object
                [ "email" => Encode.string email
                , "password" => Encode.string password
                ]

        body =
            Encode.object [ "user" => user ]
                |> Http.jsonBody
    in
    Decode.field "user" Models.userDecoder
        |> Http.post (apiUrl "/users/login") body


