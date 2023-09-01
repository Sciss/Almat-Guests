module Syntax where

type Name = String

data Expr
  = Float Double
  | BinOp Op
          Expr
          Expr
  | Var String
  | Let String
        Expr
        Expr
  | Call Name
         [Expr]
  | FunctionDefinitionCont Name
                           [Expr]
                           Expr
                           [Expr]
  | FunctionDefinition Name
                       [Expr]
                       Expr
  deriving (Eq, Ord, Show)

data Op
  = Plus
  | Minus
  | Times
  | Divide
  deriving (Eq, Ord, Show)
