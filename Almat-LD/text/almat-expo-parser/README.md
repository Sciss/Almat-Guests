# ALMAT RC Exposition Parser

## Building

You need to have the Haskell compiler `ghc` and `stack` installed: see
`https://docs.haskellstack.org/en/stable/README/`

Once installed you can build the program:
`$ stack build`

## Running

`$ stack exec -- almat-expo-parser-exe {exposition id} {page id}`

The json will be printed on stdout.