module Document exposing
    ( Document
    , map
    , toBrowserDocument
    )

import Browser
import Element exposing (..)


type alias Document msg =
    { title : String
    , body : List (Element msg)
    }


map : (a -> b) -> Document a -> Document b
map fn document =
    { title = document.title
    , body = List.map (Element.map fn) document.body
    }


toBrowserDocument : Document msg -> Browser.Document msg
toBrowserDocument document =
    { title = document.title
    , body =
        [ Element.layout []
            (column
                [ width fill
                , height fill
                ]
                document.body
            )
        ]
    }