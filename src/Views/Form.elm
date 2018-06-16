module Views.Form exposing (input, password, textarea, number)

import Html exposing (Attribute, Html, fieldset, li, text, ul)
import Html.Attributes exposing (class, type_)


password : List (Attribute msg) -> List (Html msg) -> Html msg
password attrs =
    control Html.input ([ type_ "password" ] ++ attrs)


input : List (Attribute msg) -> List (Html msg) -> Html msg
input attrs =
    control Html.input ([ type_ "text" ] ++ attrs)

number : List (Attribute msg) -> List (Html msg) -> Html msg
number attrs =
    control Html.input ([ type_ "number" ] ++ attrs)


textarea : List (Attribute msg) -> List (Html msg) -> Html msg
textarea =
    control Html.textarea

-- INTERNAL --


control :
    (List (Attribute msg) -> List (Html msg) -> Html msg)
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
control element attributes children =
    fieldset [ class "form-group" ]
        [ element (class "form-control" :: attributes) children ]