# Basket

KDB Market data provider

## KDB Initialization

q.exe -p 5001

.u.upd:insert

basket:([] dt:"d"$(); tm:"t"$(); sym:`$(); px:"f"$(); vol:"i"$())

## Compilation

mix deps.get

cp config/rebar.config deps/qErlang

mix run --no-start

## Bootcamp run on Windows

bin/bootcamp.bat start

## Basket run Linux

bin/basket start
