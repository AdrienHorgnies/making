.PHONY = hello

hello: person
	echo "#!/bin/bash" > hello
	echo "echo 'Hello, $(shell cat person)!'" >>  hello
	chmod +x hello

goodbye: person
	echo "#!/bin/bash" > goodbye
	echo "echo 'Goodbye, $(shell cat person)!'" >>  goodbye
	chmod +x goodbye

c: a b
	cp a c
	cat b >> c

touchp: touchtemplate person
	sed "s/{{filename}}/$(shell cat person)/" touchtemplate > touchp
	chmod +x touchp

clean:
	rm -f a b c hello goodbye touchp
