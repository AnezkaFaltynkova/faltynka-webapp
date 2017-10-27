import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode


main =
  Html.program { init = init, view = view, update = update, subscriptions = subscriptions }

-- MODEL

type alias Model =
  { status : String
  }

init =
  ( Model "Default Status"
  , Cmd.none
  )


-- UPDATE

type Msg
  = StatusFetch (Result Http.Error String)
  | FetchStatus

update : Msg -> Model -> ( Model, Cmd Msg)
update msg model =
  case msg of
    FetchStatus ->
      ( model, getStatus )

    StatusFetch (Ok incomingStatus) ->
      ( { model | status = incomingStatus }, Cmd.none )

    StatusFetch (Err error) ->
      ( { model | status = toString error }, Cmd.none )

-- HTTP

getStatus : Cmd Msg
getStatus =
  Http.send StatusFetch (Http.get "http://localhost:8888/alive" decodeStatus)

decodeStatus : Decode.Decoder String
decodeStatus =
  Decode.field "status" Decode.string

-- VIEW

view : Model -> Html Msg
view model =
  div []
     [ button [ onClick FetchStatus ] [ text "Get Status" ]
     , h2 [] [text model.status]
     ]



-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none