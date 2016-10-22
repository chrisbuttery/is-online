module Main exposing (..)

import Html exposing (Html, div, text)
import Html.App as App
import IsOnline


type alias Model =
    { status : IsOnline.Model
    }


initialModel =
    { status = IsOnline.initialModel
    }


type Msg
    = StatusMsg IsOnline.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StatusMsg subMsg ->
            let
                ( updatedStatusModel, statusCmd ) =
                    IsOnline.update subMsg model.status
            in
                ( { model | status = updatedStatusModel }, Cmd.map StatusMsg statusCmd )


renderStatus : Model -> Html Msg
renderStatus model =
    let
        status =
            model.status
    in
        case status.online of
            IsOnline.Offline ->
                -- text ""
                text "boo"

            IsOnline.Online _ ->
                text "Yay you're online - go do something!"


view : Model -> Html Msg
view model =
    div []
        [ renderStatus model
        , App.map StatusMsg (IsOnline.view model.status)
        ]


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.batch [ Cmd.map StatusMsg IsOnline.setRandomHost ] )


main : Program Never
main =
    App.program
        { init = init
        , update = update
        , view = view
        , subscriptions = (\_ -> Sub.none)
        }
