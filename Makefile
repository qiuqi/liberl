REBAR=rebar3

.PHONY: all compile clean eunit test eqc doc check dialyzer

all: 
	@$(REBAR) compile 

edoc: all
	@$(REBAR) doc

test:
	$(REBAR) eunit

clean:
	@$(REBAR) clean
