module Update exposing (..)

import Msgs exposing (Msg(..))
import Models exposing (Model)
import Http
import Request.User exposing (..)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )
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
            ( model, Http.send NoOp (Request.User.login model.user) )