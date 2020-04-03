module Components exposing (..)

import Html exposing (Html, div, input, br, button, text)
import Html.Events exposing (onInput, onClick)
import Html.Attributes as At

import Svg exposing (Svg)
import Svg.Attributes as Sat

import CustomTypes exposing (Msg(..), ShapeType(..), Shape)


propertyInput : String -> (String -> Msg) -> String -> Html Msg
propertyInput theText theInput theValue =
    div [] 
        [ Html.text theText
        , input [ onInput theInput, At.value theValue ] []
        , br [] []
        ]

chooseShape : ShapeType -> String -> Html Msg
chooseShape shapeType textToShow=
    button [ onClick <| InputShapeType shapeType ] [ Html.text textToShow ]

applyFunction : Msg -> String -> Html Msg
applyFunction msg textToShow =
    button [ onClick msg ] [ Html.text textToShow ]

selectShapeButton : Shape -> Html Msg
selectShapeButton shape =
    
    button [ onClick <| SelectShape shape.id, At.class "selectShapeButton" ] 
        [ text shape.name ]

propertyInputs : String -> String -> String -> String -> String -> String -> Html Msg
propertyInputs name xPos yPos width height color =
    div [ At.class "propertyInputs" ] 
        [ text "type: "
        , chooseShape Ellipse "Ellipse"
        , chooseShape Rectangle "Rectangle"
        , propertyInput "name: " InputName name
        , propertyInput "x pos: " InputXPos xPos 
        , propertyInput "y pos: " InputYPos yPos
        , propertyInput "width: " InputWidth width
        , propertyInput "height: " InputHeight height
        , propertyInput "color: " InputColor color
        ]
        

commandButtons : Html Msg
commandButtons =
    div [ At.class "commandButtons" ] 
        [ applyFunction EditShape "Save"
        , br [] []
        , applyFunction CreateShape "New"
        , br [] []
        , applyFunction RemoveShape "Remove"
        ]


svgEllipse : String -> String -> String -> String -> String -> Int -> Svg Msg
svgEllipse xPos yPos width height color id =
    Svg.ellipse 
        [ Sat.cx xPos
        , Sat.cy yPos
        , Sat.rx width
        , Sat.ry height
        , Sat.fill color 
        , onClick <| SelectShape id
        ] []

svgRect : String -> String -> String -> String -> String -> Int -> Svg Msg
svgRect xPos yPos width height color id =
    Svg.rect
        [ Sat.x xPos
        , Sat.y yPos
        , Sat.width width
        , Sat.height height
        , Sat.fill color 
        , onClick <| SelectShape id
        ] []