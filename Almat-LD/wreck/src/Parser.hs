module Parser where

import Text.Parsec
import Text.Parsec.String (Parser)

import qualified Text.Parsec.Expr as Ex
import qualified Text.Parsec.Token as Tok

import Lexer
import Syntax

binary s f assoc = Ex.Infix (reservedOp s >> return (BinOp f)) assoc

table =
  [ [binary "*" Times Ex.AssocLeft, binary "/" Divide Ex.AssocLeft]
  , [binary "+" Plus Ex.AssocLeft, binary "-" Minus Ex.AssocLeft]
  ]

int :: Parser Expr
int = do
  n <- integer
  return $ Float (fromInteger n)

floating :: Parser Expr
floating = do
  n <- float
  return $ Float n

expr :: Parser Expr
expr = Ex.buildExpressionParser table factor

variable :: Parser Expr
variable = do
  var <- identifier
  return $ Var var

variableAssignment :: Parser Expr
variableAssignment = do
  reserved "let"
  var <- identifier
  reserved "="
  value <- expr
  reserved "in"
  body <- expr
  return $ Let var value body

function :: Parser Expr
function = do
  name <- identifier
  args <- many variable
  reserved "="
  body <- expr
  return $ FunctionDefinition name args body

call :: Parser Expr
call =
  parens $ do
    name <- identifier
    args <- many expr
    return $ Call name args

functionCont :: Parser Expr
functionCont = do
  name <- identifier
  args <- many variable
  reserved "="
  body <- expr
  reserved ","
  continue <- many1 expr
  return $ FunctionDefinitionCont name args body continue

factor :: Parser Expr
factor =
  try floating <|> try int <|> try functionCont <|> try function <|> try call <|>
  variableAssignment <|>
  variable <|>
  parens expr

contents :: Parser a -> Parser a
contents p = do
  Tok.whiteSpace lexer
  r <- p
  eof
  return r

defn :: Parser Expr
defn = try function <|> expr

toplevel :: Parser [Expr]
toplevel =
  many $ do
    def <- defn
    reservedOp ";"
    return def

parseExpr :: String -> Either ParseError Expr
parseExpr s = parse (contents expr) "<stdin>" s

parseToplevel :: String -> Either ParseError [Expr]
parseToplevel s = parse (contents toplevel) "<stdin>" s
