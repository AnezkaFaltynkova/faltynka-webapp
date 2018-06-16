module Pages.Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Msgs exposing (Msg(..))
import Views.Form as Form
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ nav
        , viewForm
        , text model.textMessage
        ]


nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black" ]
        [ div [ class "left p2" ] [ text "Faltynka" ] ]



viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input
            [ class "form-control-lg"
            , placeholder "Email"
            , onInput SetEmail
            ]
            []
        , Form.password
            [ class "form-control-lg"
            , placeholder "Password"
            , onInput SetPassword
            ]
            []
        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
            [ text "Sign in" ]
        ]