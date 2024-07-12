.PHONY = hello

hello: person
	echo "#!/bin/bash" > hello
	echo "echo 'Hello, $(shell cat person)!'" >>  hello
	chmod +x hello

clean:
	rm -f hello
