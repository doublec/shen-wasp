all: shen

MO = \
	compiled/core.kl.mo \
	compiled/macros.kl.mo \
	compiled/sequent.kl.mo \
	compiled/track.kl.mo \
	compiled/writer.kl.mo \
	compiled/declarations.kl.mo \
	compiled/prolog.kl.mo \
	compiled/sys.kl.mo \
	compiled/t-star.kl.mo \
	compiled/yacc.kl.mo \
	compiled/load.kl.mo \
	compiled/reader.kl.mo \
	compiled/toplevel.kl.mo \
	compiled/types.kl.mo

KL = \
	kl/core.kl \
	kl/macros.kl \
	kl/sequent.kl \
	kl/track.kl \
	kl/writer.kl \
	kl/declarations.kl \
	kl/prolog.kl \
	kl/sys.kl \
	kl/t-star.kl \
	kl/yacc.kl \
	kl/load.kl \
	kl/reader.kl \
	kl/toplevel.kl \
	kl/types.kl

compiled/core.kl.mo: compiled/core.kl.ms
	waspc compiled/core.kl.ms

compiled/macros.kl.mo: compiled/macros.kl.ms
	waspc compiled/macros.kl.ms

compiled/sequent.kl.mo: compiled/sequent.kl.ms
	waspc compiled/sequent.kl.ms

compiled/track.kl.mo: compiled/track.kl.ms
	waspc compiled/track.kl.ms

compiled/writer.kl.mo: compiled/writer.kl.ms
	waspc compiled/writer.kl.ms

compiled/declarations.kl.mo: compiled/declarations.kl.ms
	waspc compiled/declarations.kl.ms

compiled/prolog.kl.mo: compiled/prolog.kl.ms
	waspc compiled/prolog.kl.ms

compiled/sys.kl.mo: compiled/sys.kl.ms
	waspc compiled/sys.kl.ms

compiled/t-star.kl.mo: compiled/t-star.kl.ms
	waspc compiled/t-star.kl.ms

compiled/yacc.kl.mo: compiled/yacc.kl.ms
	waspc compiled/yacc.kl.ms

compiled/load.kl.mo: compiled/load.kl.ms
	waspc compiled/load.kl.ms

compiled/reader.kl.mo: compiled/reader.kl.ms
	waspc compiled/reader.kl.ms

compiled/toplevel.kl.mo: compiled/toplevel.kl.ms
	waspc compiled/toplevel.kl.ms

compiled/types.kl.mo: compiled/types.kl.ms
	waspc compiled/types.kl.ms

compiler.mo: compiler.ms
	waspc declarations.ms

driver.mo: driver.ms primitives.ms declarations.ms compiler.ms
	waspc driver.ms

overwrites-internal.mo: overwrites-internal.ms
	waspc overwrites-internal.ms

primitives.mo: primitives.ms
	waspc primitives.ms

shen.mo: shen.ms $(MO)
	waspc shen.ms

shen: compiler.mo driver.mo overwrites-internal.mo primitives.mo shen.mo $(MO) $(KL)
	waspc -exe shen shen.ms
