module CustomTypes exposing (..)

type alias Model = 
    { svgShapes : List Shape
    , inputShapeType : ShapeType
    , inputXPos : String
    , inputYPos : String
    , inputWidth : String
    , inputHeight : String
    , inputColor : String
    , selectedShape : Int
    }

type alias Shape =
    { id : Int
    , shapeType : ShapeType
    , xPos : String
    , yPos : String
    , width : String
    , height : String
    , color : String
    }

type ShapeType = Ellipse | Rectangle

type Msg
    = CreateShape
    | InputShapeType ShapeType
    | InputXPos String
    | InputYPos String
    | InputWidth String
    | InputHeight String
    | InputColor String
    | SelectShape Int
    | RemoveShape
    | EditShape