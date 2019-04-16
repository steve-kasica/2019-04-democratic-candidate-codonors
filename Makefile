default:

clean:
	rm outputs/*

reproduce: clean
	nbexec notebooks
