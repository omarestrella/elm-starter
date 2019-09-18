module Session exposing (Session, User(..))

import Browser.Navigation as Navigation


type User
    = Guest
    | User UserData


type alias UserData =
    { firstName : String
    , lastName : String
    }


type alias Session =
    { key : Navigation.Key
    , user : User
    }
