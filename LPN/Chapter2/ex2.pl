house_elf(dobby).
witch(hermione).
witch('McGonagall').
witch(rita_skeeter).
wizard(something).
magic(X) :- house_elf(X).
magic(X) :- wizard(X).
magic(X) :- witch(X).